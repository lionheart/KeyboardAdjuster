//
//  Copyright 2016 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

public struct KeyboardAdjustmentHelper {
    public var constraint: NSLayoutConstraint?
    public var animated = false

    fileprivate var willHideBlockObserver: NSObjectProtocol?
    fileprivate var willShowBlockObserver: NSObjectProtocol?

    public init() { }
}

public protocol KeyboardAdjuster: class {
    var keyboardAdjustmentHelper: KeyboardAdjustmentHelper { get set }
}

private extension UIViewController {
    enum KeyboardState {
        case hidden
        case visible
    }

    private func keyboardWillChangeAppearance(_ sender: Notification, toState: KeyboardState) {
        guard let conformingSelf = self as? KeyboardAdjuster,
            let constraint = conformingSelf.keyboardAdjustmentHelper.constraint,
            let userInfo = (sender as NSNotification).userInfo as? [String: AnyObject],
            let _curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: _curve),
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }

        let curveAnimationOption: UIViewAnimationOptions
        switch curve {
        case .easeIn:
            curveAnimationOption = .curveEaseIn

        case .easeInOut:
            curveAnimationOption = []

        case .easeOut:
            curveAnimationOption = .curveEaseOut

        case .linear:
            curveAnimationOption = .curveLinear
        }

        switch toState {
        case .hidden:
            constraint.constant = 0

        case .visible:
            guard let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                debugPrint("UIKeyboardFrameEndUserInfoKey not available.")
                break
            }

            let frame = value.cgRectValue
            let keyboardFrameInViewCoordinates = view.convert(frame, from: nil)
            constraint.constant = view.bounds.height - keyboardFrameInViewCoordinates.origin.y
        }

        if conformingSelf.keyboardAdjustmentHelper.animated {
            let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, curveAnimationOption]
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            view.layoutIfNeeded()
        }
    }

    /**
     A callback that manages the bottom constraint when the keyboard is about to be hidden.

     - parameter sender: An `NSNotification` containing a `Dictionary` with information regarding the keyboard appearance.
     - Date: February 18, 2016
     */
    @objc func keyboardWillHide(_ sender: Notification) {
        keyboardWillChangeAppearance(sender, toState: .hidden)
    }

    /**
     A callback that manages the bottom constraint before the keyboard is shown.

     - parameter sender: An `NSNotification` containing a `Dictionary` with information regarding the keyboard appearance.
     - Date: February 18, 2016
     */
    @objc func keyboardWillShow(_ sender: Notification) {
        keyboardWillChangeAppearance(sender, toState: .visible)
    }
}

extension KeyboardAdjuster where Self: UIViewController {
    /**
     Activates keyboard adjustment for the calling view controller.

     - SeeAlso: `activateKeyboardAdjuster(showBlock:hideBlock:)`
     - Date: February 18, 2016
     */
    public func activateKeyboardAdjuster() {
        activateKeyboardAdjuster(nil, hideBlock: nil)
    }

    /**
     Enable keyboard adjustment for the current view controller, providing optional closures to call when the keyboard appears and when it disappears.
     
     - parameter showBlock: (optional) a closure that's called when the keyboard appears
     - parameter hideBlock: (optional) a closure that's called when the keyboard disappears
     - Date: February 18, 2016
     */
    public func activateKeyboardAdjuster(_ showBlock: (() -> Void)?, hideBlock: (() -> Void)?) {
        guard let constraint = keyboardAdjustmentHelper.constraint else {
            return
        }

        // Activate the bottom constraint.
        constraint.isActive = true

        let center = NotificationCenter.default
        let queue = OperationQueue.main
        keyboardAdjustmentHelper.willHideBlockObserver = center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: queue, using: { [weak self] notification in
            self?.keyboardWillHide(notification)
            
            hideBlock?()
        })

        keyboardAdjustmentHelper.willShowBlockObserver = center.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: queue, using: { [weak self] notification in
            self?.keyboardWillShow(notification)
            
            showBlock?()
        })

        guard let viewA = constraint.firstItem as? UIView,
            let viewB = constraint.secondItem as? UIView else {
                return
        }

        guard viewA.subviews.contains(viewB) else {
            fatalError("Please reverse the order of arguments in your keyboard adjuster constraint.")
        }
    }
    
    /**
     Call this in your `viewWillDisappear` method for your `UIViewController`. This method removes any active keyboard observers from your view controller.

     - Date: February 18, 2016
     */
    public func deactivateKeyboardAdjuster() {
        // See https://useyourloaf.com/blog/unregistering-nsnotificationcenter-observers-in-ios-9/
        guard let willShowBlockObserver = keyboardAdjustmentHelper.willShowBlockObserver,
            let willHideBlockObserver = keyboardAdjustmentHelper.willHideBlockObserver else {
                return
        }

        let center = NotificationCenter.default
        center.removeObserver(willShowBlockObserver)
        center.removeObserver(willHideBlockObserver)
    }
}
