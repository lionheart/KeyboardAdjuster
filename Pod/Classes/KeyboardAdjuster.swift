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

public protocol KeyboardAdjuster: class {
    var keyboardAdjusterConstraint: NSLayoutConstraint? { get set }
    var keyboardAdjusterAnimated: Bool? { get set }
}

private extension UIViewController {
    enum KeyboardState {
        case hidden
        case visible
    }

    func keyboardChangedAppearance(_ sender: Notification, toState: KeyboardState) {
        guard let conformingSelf = self as? KeyboardAdjuster,
            let constraint = conformingSelf.keyboardAdjusterConstraint,
            let userInfo = (sender as NSNotification).userInfo as? [String: AnyObject],
            let _curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: _curve),
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }

        if let block = sender.object as? (() -> Void) {
            block()
        }

        var curveAnimationOption: UIViewAnimationOptions
        switch curve {
        case .easeIn:
            curveAnimationOption = .curveEaseIn

        case .easeInOut:
            curveAnimationOption = UIViewAnimationOptions()

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

        let animated = conformingSelf.keyboardAdjusterAnimated ?? false
        if animated {
            let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, curveAnimationOption]
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: self.view.layoutIfNeeded, completion:nil)
        } else {
            view.layoutIfNeeded()
        }
    }

    /**
     A callback that manages the bottom constraint when the keyboard is about to be hidden.

     - parameter sender: An `NSNotification` containing a `Dictionary` with information regarding the keyboard appearance.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 18, 2016
     */
    @objc func keyboardWillHide(_ sender: Notification) {
        keyboardChangedAppearance(sender, toState: .hidden)
    }

    /**
     A callback that manages the bottom constraint after the keyboard is shown.

     - parameter sender: An `NSNotification` containing a `Dictionary` with information regarding the keyboard appearance.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 18, 2016
     */
    @objc func keyboardDidShow(_ sender: Notification) {
        keyboardChangedAppearance(sender, toState: .visible)
    }
}

extension KeyboardAdjuster where Self: UIViewController {
    /**
     Activates keyboard adjustment for the calling view controller.

     - seealso: `activateKeyboardAdjuster(showBlock:hideBlock:)`
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 18, 2016
     */
    public func activateKeyboardAdjuster() {
        activateKeyboardAdjuster(nil, hideBlock: nil)
    }

    /**
     Enable keyboard adjustment for the current view controller, providing optional closures to call when the keyboard appears and when it disappears.
     
     - parameter showBlock: (optional) a closure that's called when the keyboard appears
     - parameter hideBlock: (optional) a closure that's called when the keyboard disappears
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 18, 2016
     */
    public func activateKeyboardAdjuster(_ showBlock: AnyObject?, hideBlock: AnyObject?) {
        // Activate the bottom constraint.
        keyboardAdjusterConstraint?.isActive = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: hideBlock)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: showBlock)

        guard let viewA = keyboardAdjusterConstraint?.firstItem as? UIView,
            let viewB = keyboardAdjusterConstraint?.secondItem as? UIView else {
                return
        }

        if viewB.subviews.contains(viewA) {
            assertionFailure("Please reverse the order of arguments in your keyboard Adjuster constraint.")
        }
    }
    
    /**
     Call this in your `viewWillDisappear` method for your `UIViewController`. This method removes any active keyboard observers from your view controller.

     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 18, 2016
     */
    public func deactivateKeyboardAdjuster() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
}
