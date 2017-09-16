# KeyboardAdjuster

[![CI Status](http://img.shields.io/travis/lionheart/KeyboardAdjuster.svg?style=flat)](https://travis-ci.org/lionheart/KeyboardAdjuster)
[![Version](https://img.shields.io/cocoapods/v/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
![Swift](http://img.shields.io/badge/swift-3-blue.svg?style=flat)

KeyboardAdjuster will adjust the bottom position of any given `UIView` when a keyboard appears on screen. All you have to do is provide an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. KeyboardAdjuster will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

If you're currently choosing between KeyboardAdjuster and another alternative, please read about our [philosophy](https://gist.github.com/dlo/86208878ff976261fa16)

Note: KeyboardAdjuster requires layout anchors in your build target, so it will only work with iOS 9 or above. If you'd like to add support for earlier iOS versions, please submit a pull request.

KeyboardAdjuster is a Swift port of [LHSKeyboardAdjuster](https://github.com/lionheart/LHSKeyboardAdjuster), which targets projects written in Objective-C.

## Installation

KeyboardAdjuster is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyboardAdjuster"
```

## Usage

1. In your view controller file, import `KeyboardAdjuster`.

   ```swift
   import KeyboardAdjuster
   ```

2. Make your `UIViewController` conform to `KeyboardAdjuster` and define a property called `keyboardAdjustmentHelper`.

   ```swift
   class MyViewController: UIViewController, KeyboardAdjuster {
       var keyboardAdjustmentHelper = KeyboardAdjustmentHelper()
   }
   ```

2. Figure out which view you'd like to pin to the top of the keyboard. A `UIScrollView`, `UITableView`, or `UITextView` are likely candidates. Then, wherever you're setting up your view constraints, set `keyboardAdjustmentHelper.constraint` to the constraint pinning the bottom of this view to the bottom of the screen:

   ```swift
   class MyViewController: UIViewController, KeyboardAdjuster {
       func viewDidLoad() {
           super.viewDidLoad()

           keyboardAdjustmentHelper.constraint = view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor)
       }
   }
   ```

   KeyboardAdjuster will automatically activate `keyboardAdjusterConstraint` for you.

3. All you need to do now is activate and deactivate the automatic adjustments in your `viewWillAppear(animated:)` and `viewWillDisappear(animated:)` methods.

   ```swift
   class MyViewController: UIViewController, KeyboardAdjuster {
       override func viewWillAppear(animated: Bool) {
           super.viewWillAppear(animated)

           activateKeyboardAdjuster()
       }

       override func viewWillDisappear(animated: Bool) {
           super.viewWillDisappear(animated)

           deactivateKeyboardAdjuster()
       }
   }
   ```

4. And you're done! Whenever a keyboard appears, your views will be automatically resized.

## How It Works

KeyboardAdjuster registers NSNotificationCenter callbacks for keyboard appearance and disappearance. When a keyboard appears, it pulls out the keyboard size from the notification, along with the duration of the keyboard animation, and applies that to the view constraint adjustment.

## Author

[Dan Loewenherz](https://github.com/dlo)

## License

KeyboardAdjuster is available under the Apache 2.0 LICENSE. See the [LICENSE](LICENSE) file for more info.
