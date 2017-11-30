# KeyboardAdjuster

[![CI Status](http://img.shields.io/travis/lionheart/KeyboardAdjuster.svg?style=flat)](https://travis-ci.org/lionheart/KeyboardAdjuster)
[![Version](https://img.shields.io/cocoapods/v/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardAdjuster.svg?style=flat)](http://cocoapods.org/pods/KeyboardAdjuster)
![Swift](http://img.shields.io/badge/swift-4-blue.svg?style=flat)

KeyboardAdjuster adjusts your views to avoid the keyboard ⌨️. That's pretty much all there is to it. It's battle-tested and easy to integrate into any project--Storyboards or code, doesn't matter.

### Requirements

* [x] Auto Layout
* [x] iOS 9.0-11.0+
* [ ] macOS (please contribute!)
* [ ] tvOS (please contribute!)

KeyboardAdjuster started as a Swift port of [LHSKeyboardAdjuster](https://github.com/lionheart/LHSKeyboardAdjusting), which is recommended for projects written in Objective-C.

If you're currently choosing between KeyboardAdjuster and another alternative, please read about our [philosophy](https://gist.github.com/dlo/86208878ff976261fa16).

### Support KeyboardAdjuster

Supporting KeyboardAdjuster, keeping it up to date with the latest iOS versions, etc., takes a lot of time! So, if you're a developer who's gotten some utility out of this library, please support it by starring the repo. This increases its visibility in GitHub search and encourages others to contribute. 🙏🏻🍻

## Installation

KeyboardAdjuster is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "KeyboardAdjuster", "~> 2"
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

2. Figure out which view you'd like to pin to the top of the keyboard--it's probably going to be a `UIScrollView`, `UITableView`, or `UITextView`. Then, wherever you're setting up your view constraints, set `keyboardAdjustmentHelper.constraint` to the Y-axis constraint pinning the bottom of this view:

   ```swift
   class MyViewController: UIViewController, KeyboardAdjuster {
       func viewDidLoad() {
           super.viewDidLoad()

           keyboardAdjustmentHelper.constraint = view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor)
       }
   }
   ```

   <details>
     <summary><strong>NOTE:</strong> If you're using iOS 11 and your view is using the <code>safeAreaLayoutGuide</code> to set constraints, click here to view an alternate approach.</summary>

     ```swift
     func viewDidLoad() {
         super.viewDidLoad()

         if #available(iOS 11, *) {
             keyboardAdjustmentHelper.constraint = view.safeAreaLayoutGuide.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor)
         } else {
             keyboardAdjustmentHelper.constraint = view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor)
         }
     }
     ```
   </details>

3. Finally, in your `viewWillAppear(_:)` and `viewWillDisappear(_:)` methods:

   ```swift
   class MyViewController: UIViewController, KeyboardAdjuster {
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           activateKeyboardAdjuster()
       }

       override func viewWillDisappear(_ animated: Bool) {
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
