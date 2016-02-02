/*
* Copyright (c) 2015 Droids on Roids LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

@objc public protocol SwiftCarouselDelegate {
    optional func didSelectItem(item item: UIView, index: Int) -> UIView?
    optional func didDeselectItem(item item: UIView, index: Int) -> UIView?
    optional func didScroll(toOffset offset: CGPoint) -> Void
    optional func willBeginDragging(withOffset offset: CGPoint) -> Void
    optional func didEndDragging(withOffset offset: CGPoint) -> Void
}

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

public class SwiftCarousel: UIView {
    //MARK: - Properties
    private var maxVelocity: CGFloat = 100.0
    private var shouldScroll = false
    private var shouldScrollToPosition: CGFloat = 0.0
    private var myContext = 0
    private var originalChoicesNumber = 0
    private var choices: [UIView] = []
    private var scrollView = UIScrollView()
    private var spacing: Double = 0.0
    private var currentSelectedIndex: Int?
    private var currentRealSelectedIndex: Int?
    public weak var delegate: SwiftCarouselDelegate?
    public var selectByTapEnabled = true
    
    public var resizeType: SwiftCarouselResizeType = .WithoutResizing(0.0) {
        didSet {
            setupViews(choices)
        }
    }
    
    public var defaultSelectedIndex: Int? {
        didSet {
            if (defaultSelectedIndex < 0) {
                defaultSelectedIndex = nil
            }
        }
    }
    
    public var selectedIndex: Int? {
        let view = viewAtLocation(CGPoint(x: scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame) / 2.0, y: CGRectGetMinY(scrollView.frame)))
        guard var index = choices.indexOf({ $0 == view }) else {
            return nil
        }
        
        while index >= originalChoicesNumber {
            index -= originalChoicesNumber
        }
        
        return index
    }
    
    private var realSelectedIndex: Int? {
        let view = viewAtLocation(CGPoint(x: scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame) / 2.0, y: CGRectGetMinY(scrollView.frame)))
        guard let index = choices.indexOf({ $0 == view }) else {
            return nil
        }
        
        return index
    }
    
    public var items: [UIView] {
        get {
            return [UIView](choices[choices.count / 3..<(choices.count / 3 + originalChoicesNumber)])
        }
        set {
            originalChoicesNumber = newValue.count
            (0..<3).forEach { counter in
                let newViews: [UIView] = newValue.map { choice in
                    // Return original view if middle section
                    if counter == 1 {
                        return choice
                    } else {
                        return choice.copyView()
                    }
                }
                self.choices.appendContentsOf(newViews)
            }
            setupViews(choices)
        }
    }
    
    // MARK: - Inits
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init(frame: CGRect, choices: [UIView]) {
        self.init(frame: frame)
        setup()
        items = choices
    }
    
    // MARK: - Setups
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    private func setup() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|",
            options: .AlignAllCenterX,
            metrics: nil,
            views: ["scrollView": scrollView])
        )
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|",
            options: .AlignAllCenterY,
            metrics: nil,
            views: ["scrollView": scrollView])
        )
        
        backgroundColor = .clearColor()
        scrollView.backgroundColor = .clearColor()
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        gestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupViews(views: [UIView]) {
        var x: CGFloat = 0.0
        if case .FloatWithSpacing(_) = resizeType {
            views.forEach { $0.sizeToFit() }
        }
        
        views.forEach { choice in
            var additionalSpacing: CGFloat = 0.0
            switch resizeType {
            case .WithoutResizing(let spacing): additionalSpacing = spacing
            case .FloatWithSpacing(let spacing): additionalSpacing = spacing
            case .VisibleItemsPerPage(let visibleItems):
                choice.frame.size.width = scrollView.frame.width / CGFloat(visibleItems)
                if (CGRectGetHeight(choice.frame) > 0.0) {
                    let aspectRatio: CGFloat = CGRectGetWidth(choice.frame)/CGRectGetHeight(choice.frame)
                    choice.frame.size.height = floor(CGRectGetWidth(choice.frame) * aspectRatio) > CGRectGetHeight(frame) ? CGRectGetHeight(frame) : floor(CGRectGetWidth(choice.frame) * aspectRatio)
                } else {
                    choice.frame.size.height = CGRectGetHeight(frame)
                }
            }
            choice.frame.origin.x = x
            x += CGRectGetWidth(choice.frame) + additionalSpacing
        }
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        views.forEach { scrollView.addSubview($0) }
        layoutIfNeeded()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var width: CGFloat = 0.0
        switch resizeType {
        case .FloatWithSpacing(_), .WithoutResizing(_):
            width = CGRectGetMaxX(choices.last!.frame)
        case .VisibleItemsPerPage(_):
            width = choices.reduce(0.0) { $0 + CGRectGetWidth($1.frame) }
        }
        
        scrollView.contentSize = CGSize(width: width, height: CGRectGetHeight(frame))
        maxVelocity = scrollView.contentSize.width / 6.0
        
        // Center the view
        if defaultSelectedIndex != nil {
            selectItem(defaultSelectedIndex!, animated: false)
        } else {
            selectItem(0, animated: false)
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?,
        change: [String : AnyObject]?,
        context: UnsafeMutablePointer<Void>) {
            if let _ = change?[NSKeyValueChangeNewKey] where keyPath == "contentOffset" {
                let newOffset = scrollView.contentOffset
                if shouldScroll {
                    if case (shouldScrollToPosition - 10..<shouldScrollToPosition + 10) = newOffset.x {
                        shouldScroll = false
                    }
                }
                
                if !shouldScroll {
                    var newOffsetX: CGFloat!
                    
                    if (newOffset.x >= scrollView.contentSize.width * 2.0 / 3.0) {
                        newOffsetX = newOffset.x - scrollView.contentSize.width / 3.0
                    } else if (CGRectGetMaxX(scrollView.bounds) <= scrollView.contentSize.width / 3.0) { // First part
                        newOffsetX = newOffset.x + scrollView.contentSize.width * 3.0
                    }
                    
                    guard newOffsetX != nil && newOffsetX > 0 else { return }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.shouldScroll = true
                        self.shouldScrollToPosition = newOffsetX
                        self.scrollView.contentOffset.x = newOffsetX
                        self.delegate?.didScroll?(toOffset: self.scrollView.contentOffset)
                    })
                }
            }
    }
    
    // MARK: - Gestures
    public func viewTapped(gestureRecognizer: UIGestureRecognizer) {
        if selectByTapEnabled {
            let touchPoint = gestureRecognizer.locationInView(scrollView)
            if let view = viewAtLocation(touchPoint), index = choices.indexOf(view) {
                selectItem(index, animated: true, force: true)
            }
        }
    }
    
    // MARK: - Helpers
    private func didSelectItem() {
        guard let selectedIndex = self.selectedIndex, realSelectedIndex = self.realSelectedIndex else {
            return
        }
        
        didDeselectItem()
        delegate?.didSelectItem?(item: choices[realSelectedIndex], index: selectedIndex)
        
        currentSelectedIndex = selectedIndex
        currentRealSelectedIndex = realSelectedIndex
    }
    
    private func didDeselectItem() {
        guard let currentRealSelectedIndex = self.currentRealSelectedIndex, currentSelectedIndex = self.currentSelectedIndex else {
            return
        }
        
        delegate?.didDeselectItem?(item: choices[currentRealSelectedIndex], index: currentSelectedIndex)
    }
    
    private func refreshChoices() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func willChangePart(point: CGPoint) -> Bool {
        if (point.x >= scrollView.contentSize.width * 2.0 / 3.0 ||
            point.x <= scrollView.contentSize.width / 3.0) {
                return true
        }
        
        return false
    }
    
    private func viewAtLocation(touchLocation: CGPoint) -> UIView? {
        for subview in scrollView.subviews where CGRectContainsPoint(subview.frame, touchLocation) {
            return subview
        }
        
        return nil
    }
    
    private func nearestViewAtLocation(touchLocation: CGPoint) -> UIView {
        if let newView = viewAtLocation(touchLocation) {
            return newView
        }
        
        // Now check left and right margins to nearest views
        var step: CGFloat = 1.0
        
        switch resizeType {
        case .FloatWithSpacing(let spacing):
            step = spacing
        case .WithoutResizing(let spacing):
            step = spacing
        default:
            break
        }
        
        var targetX = touchLocation.x
        
        // Left
        var leftView: UIView?
        
        repeat {
            targetX -= step
            leftView = viewAtLocation(CGPoint(x: targetX, y: touchLocation.y))
        } while (leftView == nil)
        
        let leftMargin = touchLocation.x - CGRectGetMaxX(leftView!.frame)
        
        // Right
        var rightView: UIView?
        
        repeat {
            targetX += step
            rightView = viewAtLocation(CGPoint(x: targetX, y: touchLocation.y))
        } while (rightView == nil)
        
        let rightMargin = CGRectGetMinX(rightView!.frame) - touchLocation.x
        
        if rightMargin < leftMargin {
            return rightView!
        } else {
            return leftView!
        }
    }
    
    private func selectItem(choice: Int, animated: Bool, force: Bool) {
        if !force {
            guard choice < choices.count / 3 else { return }
        }
        
        var min: Int = originalChoicesNumber
        var index: Int = choice
        
        if let realSelectedIndex = self.realSelectedIndex where !force {
            for choiceIndex in choice.stride(to: choices.count, by: originalChoicesNumber) {
                if abs(realSelectedIndex - choiceIndex) < min {
                    index = choiceIndex
                    min = abs(realSelectedIndex - choiceIndex)
                }
            }
        }
        
        let choiceView = choices[index]
        let x = choiceView.center.x - CGRectGetWidth(scrollView.frame) / 2.0
        
        scrollView.setContentOffset(CGPoint(x: x, y: scrollView.contentOffset.y), animated: animated)
        
        if !animated {
            didSelectItem()
        }
    }
    
    public func selectItem(choice: Int, animated: Bool) {
        selectItem(choice, animated: animated, force: false)
    }
}

// MARK: - UIScrollViewDelegate
extension SwiftCarousel: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        didSelectItem()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        didSelectItem()
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.willBeginDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var velocity = velocity.x * 300.0
        var targetX = scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame) / 2.0 + velocity
        
        if velocity >= maxVelocity {
            velocity = maxVelocity
        } else if velocity <= -maxVelocity {
            velocity = -maxVelocity
        }
        
        if (targetX > scrollView.contentSize.width || targetX < 0.0) {
            targetX = scrollView.contentSize.width / 3.0 + velocity
        }
        
        let choiceView = nearestViewAtLocation(CGPoint(x: targetX, y: CGRectGetMinY(scrollView.frame)))
        targetContentOffset.memory.x = choiceView.center.x - scrollView.frame.width / 2.0
    }
}

// MARK: - UIView Extension
extension UIView {
    func copyView() -> UIView {
        let serialized = NSKeyedArchiver.archivedDataWithRootObject(self)
        
        return NSKeyedUnarchiver.unarchiveObjectWithData(serialized) as! UIView
    }
}