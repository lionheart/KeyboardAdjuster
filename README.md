# KeyboardAdjuster

[![CI Status](http://img.shields.io/travis/lionheart/KeyboardAdjuster.svg?style=flat)](https://travis-ci.org/lionheart/KeyboardAdjuster)
[![Version](https://img.shields.io/cocoapods/v/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
[![License](https://img.shields.io/cocoapods/l/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)

KeyboardAdjuster will adjust the bottom position of any given `UIView` when a keyboard appears on screen. All you have to do is provide an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. KeyboardAdjuster will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

If you're currently choosing between KeyboardAdjuster and another alternative, please read about our [philosophy](https://gist.github.com/dlo/86208878ff976261fa16)

Note: KeyboardAdjuster requires layout anchors in your build target, so it will only work with iOS 9 or above. If you'd like to add support for earlier iOS versions, please submit a pull request.

KeyboardAdjuster is a Swift port of [LHSKeyboardAdjusting](https://github.com/lionheart/LHSKeyboardAdjusting), which targets projects written in Objective-C.

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

2. Make sure your `UIViewController` conforms to `KeyboardAdjusting`, and define two properties. Set `keyboardAdjustmentAnimated` to `true` or `false`, depending on whether you want the constraint adjustment to be animated.

   ```swift
   class MyViewController: UIViewController, KeyboardAdjusting {
       var keyboardAdjustmentConstraint: NSLayoutConstraint?
       var keyboardAdjustmentAnimated: Bool? = false

       // ...
   }
   ```

2. Figure out which view you'd like to pin to the top of the keyboard. A `UIScrollView`, `UITableView`, or `UITextView` are likely candidates. Then, wherever you're setting up your view constraints, set `keyboardAdjustmentConstraint` to the constraint pinning the bottom of this view to the bottom of the screen:

   ```swift
   class MyViewController: UIViewController, KeyboardAdjusting {
       // ...

       func viewDidLoad() {
           super.viewDidLoad()

           // Your other setup code here...

           keyboardAdjustmentConstraint = view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor)
       }

       // ...
   }
   ```

   KeyboardAdjuster will automatically activate `keyboardAdjustmentConstraint` for you.

3. All you need to do now is activate and deactivate the automatic adjustments in your `viewWillAppear(animated:)` and `viewWillDisappear(animated:)` methods.

   ```swift
   class MyViewController: UIViewController, KeyboardAdjusting {
       // ...

       override func viewWillAppear(animated: Bool) {
           super.viewWillAppear(animated)
           activateKeyboardAdjustment()
       }

       override func viewWillDisappear(animated: Bool) {
           super.viewWillDisappear(animated)
           deactivateKeyboardAdjustment()
       }

       // ...
   }
   ```

4. And you're done! Whenever a keyboard appears, your views will be automatically resized.

## How It Works

KeyboardAdjuster registers NSNotificationCenter callbacks for keyboard appearance and disappearance. When a keyboard appears, it pulls out the keyboard size from the notification, along with the duration of the keyboard animation, and applies that to the view constraint adjustment.

## Author

[Dan Loewenherz](https://github.com/dlo)

## License

KeyboardAdjuster is available under the Apache 2.0 LICENSE. See the [LICENSE](LICENSE) file for more info.
