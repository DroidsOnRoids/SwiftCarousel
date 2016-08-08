# SwiftCarousel

[![Version](https://img.shields.io/cocoapods/v/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)
[![Platform](https://img.shields.io/cocoapods/p/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)
[![Twitter](https://img.shields.io/badge/twitter-@thesunshinejr-blue.svg?style=flat)](https://twitter.com/thesunshinejr)

<br />
## Due to lack of time, I can't really maintain this project anymore. 😓  If anyone is up for doing so, please contact me.</span>
<br />

SwiftCarousel is a lightweight, written natively in Swift, circular UIScrollView.<br />
So what is there more to that than just a circular scroll view? You can spin it like a real carousel!

<div style="width: 100%; text-align: center;">
<div style="width: 550px;margin: 0 auto;">
<img src="https://media.giphy.com/media/13AYJc6zZ870re/giphy.gif" alt="SwiftCarousel example" style="float: left;">
<img src="https://media.giphy.com/media/Mv8KJ3qxspXy0/giphy.gif" alt="SwiftCarousel example" style="float: right;">
</div>
</div>

## Requirements

Swift 2.0, iOS 9

## Installation

SwiftCarousel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftCarousel"
```

Then run `pod install` and it should be 🔥
Also remember to add `import SwiftCarousel` in your project.

## Examples
You can use Examples directory for examples with creating SwiftCarousel using IB or code.

## Basic usage using Interface Builder (Storyboard/xibs)

First, create `UIView` object and assign `SwiftCarousel` class to it.
Then we need to assign some selectable `UIViews`. It might be `UILabels`, `UIImageViews` etc.
The last step would be setting correct `resizeType` parameter which contains:

```swift
public enum SwiftCarouselResizeType {
    // WithoutResizing is adding frames as they are.
    // Parameter = spacing between UIViews.
    // !!You need to pass correct frame sizes as items!!
    case WithoutResizing(CGFloat)

    // VisibleItemsPerPage will try to fit the number of items you specify
    // in the whole screen (will resize them of course).
    // Parameter = number of items visible on screen.
    case VisibleItemsPerPage(Int)

    // FloatWithSpacing will use sizeToFit() on your views to correctly place images
    // It is helpful for instance with UILabels (Example1 in Examples folder).
    // Parameter = spacing between UIViews.
    case FloatWithSpacing(CGFloat)
}
```

Basic setup would look like:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    items = ["Elephants", "Tigers", "Chickens", "Owls", "Rats", "Parrots", "Snakes"]
    itemsViews = items!.map { labelForString($0) }
    carousel.items = itemsViews!
    carousel.resizeType = .VisibleItemsPerPage(3)
    carousel.defaultSelectedIndex = 3 // Select default item at start
    carousel.delegate = self
}

func labelForString(string: String) -> UILabel {
    let text = UILabel()
    text.text = string
    text.textColor = .blackColor()
    text.textAlignment = .Center
    text.font = .systemFontOfSize(24.0)
    text.numberOfLines = 0

    return text
}
```

## Basic usage using pure code

Here we use `itemsFactory(itemsCount:facory:)` method. This method allows you to setup your carousel using closure rather than static array of views. Why would we want to use that? In case of quite complicated logic. E.g. if you want to have `CALayer` properties all across the carousel.

```swift
let carouselFrame = CGRect(x: view.center.x - 200.0, y: view.center.y - 100.0, width: 400.0, height: 200.0)
carouselView = SwiftCarousel(frame: carouselFrame)
try! carouselView.itemsFactory(itemsCount: 5) { choice in
    let imageView = UIImageView(image: UIImage(named: "puppy\(choice+1)"))
    imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 200.0, height: 200.0))

    return imageView
}
carouselView.resizeType = .WithoutResizing(10.0)
carouselView.delegate = self
carouselView.defaultSelectedIndex = 2
view.addSubview(carouselView)
```

## Additional methods, properties & delegate

You can use method `selectItem(_:animated:)` to programmatically select your item:
```swift
carousel.selectItem(1, animated: true)
```

Or you can set default selected item:
```swift
carousel.defaultSelectedIndex = 3
```

You can disable selecting item by tapping it (its enabled by default):
```swift
carousel.selectByTapEnabled = false
```

You can also get current selected index:
```swift
let selectedIndex = carousel.selectedIndex
```

You can implement `SwiftCarouselDelegate` protocol:
```swift
@objc public protocol SwiftCarouselDelegate {
    optional func didSelectItem(item item: UIView, index: Int, tapped: Bool) -> UIView?
    optional func didDeselectItem(item item: UIView, index: Int) -> UIView?
    optional func didScroll(toOffset offset: CGPoint) -> Void
    optional func willBeginDragging(withOffset offset: CGPoint) -> Void
    optional func didEndDragging(withOffset offset: CGPoint) -> Void
}
```

Then you need to set the `delegate` property:
```swift
carousel.delegate = self
```

If you need more, basic usages in Example1 project in directory Examples.

## Known limitations

The original views are internally copied to using the `copyView` method defined in the `UIView+SwiftCarousel` extension when using the `items` property. This performs a shallow copy of the view using `NSKeyedUnarchiver` and `NSKeyedArchiver`. So, if a custom `UIView` subclass with references to external objects is used, those references might be nil when `didSelectItem` and `didDeselectItem` delegate methods are called. To avoid this situation, the `itemsFactory` method can be used instead of the `items` property to setup the carousel.

## Contributing
Feel free to make issues/pull requests if you have some questions, ideas for improvement, or maybe bugs you've found.
After some contribution I'm giving write access as a thank you 🎉

## Author

Sunshinejr, thesunshinejr@gmail.com, <a href="https://twitter.com/thesunshinejr">@thesunshinejr</a>

## License

SwiftCarousel is available under the MIT license. See the LICENSE file for more info.
