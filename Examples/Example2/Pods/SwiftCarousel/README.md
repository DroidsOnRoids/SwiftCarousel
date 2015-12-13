# SwiftCarousel

[![Version](https://img.shields.io/cocoapods/v/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)
[![License](https://img.shields.io/cocoapods/l/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)
[![Platform](https://img.shields.io/cocoapods/p/SwiftCarousel.svg?style=flat)](http://cocoapods.org/pods/SwiftCarousel)

SwiftCarousel is a lightweight, written natively in Swift, circular UIScrollView.

<p align="center">
<img src="https://i.imgur.com/SPrBsy8.gif" alt="SwiftCarousel example">
</p>

## Requirements

Swift 2.0, iOS 9

## Installation

SwiftCarousel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftCarousel"
```

Or just copy `SwiftCarousel.swift` and you can use it without cocoapods.

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
    text.textColor = UIColor.blackColor()
    text.textAlignment = NSTextAlignment.Center
    text.font = UIFont.systemFontOfSize(24)
    text.numberOfLines = 0

    return text
}
```

## Basic usage using pure code

```swift
let rect = CGRect(origin: CGPoint(x: view.center.x - 200, y: view.center.y - 100), size: CGSize(width: 400, height: 200))
choices = (1...5).map{ choice in
    let imageView = UIImageView(image: UIImage(named: "puppy\(choice)"))
    imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 200, height: 200))

    return imageView
}
carouselView = SwiftCarousel(frame: rect, choices: choices)
carouselView.resizeType = .WithoutResizing(10)
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

You can also get current selected index:
```swift
  let selectedIndex = carousel.selectedIndex
```

You can implement `SwiftCarouselDelegate` protocol:
```swift
@objc public protocol SwiftCarouselDelegate {
    optional func didSelectItem(item item: UIView, index: Int) -> UIView?
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

## Author

Łukasz Mróz, lukasz.mroz@droidsonroids.pl, [Twitter](https://twitter.com/thesunshinejr)

## License

SwiftCarousel is available under the MIT license. See the LICENSE file for more info.
