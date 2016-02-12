//
//  KeyboardAdjuster.swift
//  Pods
//
//  Created by Daniel Loewenherz on 2/10/16.
//
//

import UIKit

public protocol KeyboardAdjusting {
    var keyboardAdjustmentConstraint: NSLayoutConstraint? { get set }
    var keyboardAdjustmentAnimated: Bool? { get set }
}

extension UIViewController {
    var keyboardAdjustmentConstraint: NSLayoutConstraint? { get { return nil } }
    var keyboardAdjustmentAnimated: Bool? { get { return nil } }

    func activateKeyboardAdjustment() {
        activateKeyboardAdjustment(nil, hideBlock: nil)
    }

    func activateKeyboardAdjustment(showBlock: AnyObject?, hideBlock: AnyObject?) {
        if let _ = keyboardAdjustmentConstraint {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: hideBlock)
            notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillHideNotification, object: showBlock)
        }
        else {
            print("You must define `keyboardAdjustmentConstraint` on your view controller to activate KeyboardAdjuster.")
        }
    }

    func deactivateKeyboardAdjustment() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }

    func keyboardWillHide(sender: NSNotification) {
        if let constraint = keyboardAdjustmentConstraint {
            if let block = sender.object as? (() -> Void) {
                block()
            }

            if let userInfo = sender.userInfo,
                duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval,
                curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationOptions,
                animated = keyboardAdjustmentAnimated {
                    constraint.constant = 0

                    if animated {
                        let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, curve]
                        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: {
                            self.view.layoutIfNeeded()
                            }, completion:nil)
                    }
                    else {
                        view.layoutIfNeeded()
                    }
            }
        }
    }

    func keyboardDidShow(sender: NSNotification) {
        if let constraint = keyboardAdjustmentConstraint {
            if let block = sender.object as? (() -> Void) {
                block()
            }

            if let userInfo = sender.userInfo as? [String: AnyObject],
                value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                    let frame = value.CGRectValue()
                    let keyboardFrameInViewCoordinates = view.convertRect(frame, fromView: nil)
                    if let duration: NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval,
                        curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationOptions,
                        animated = keyboardAdjustmentAnimated {
                            constraint.constant = CGRectGetHeight(view.bounds) - keyboardFrameInViewCoordinates.origin.y
                            let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, curve]
                            if animated {
                                UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: {
                                    self.view.layoutIfNeeded()
                                }, completion: nil)
                            }
                    }
            }
        }
    }
}