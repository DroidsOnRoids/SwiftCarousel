//
//  SwiftCarousel.swift
//  SwiftCarousel
//
//  Created by Łukasz Mróz on 02.12.2015.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

import UIKit

@objc public protocol SwiftCarouselDelegate {
    optional func didSelectItem(item item: UIView, index: Int) -> UIView?
    optional func didDeselectItem(item item: UIView, index index: Int) -> UIView?
    optional func didScroll(toOffset offset: CGPoint) -> Void
    optional func willBeginDragging(withOffset offset: CGPoint) -> Void
    optional func didEndDragging(withOffset offset: CGPoint) -> Void
}

public enum SwiftCarouselResizeType {
    case WithoutResizing(CGFloat) // UIView frames are already specified
    case VisibleItemsPerPage(Int) // Fill bases on visible items
    case FloatWithSpacing(CGFloat) // It floats one after another, using sizeToFit()
}

//TODO: Vertical/horizontal
public class SwiftCarousel: UIView, UIScrollViewDelegate {
    let maxVelocity: CGFloat = 100.0
    
    //MARK: - Properties
    private var originalChoicesNumber: Int = 0
    private var choices: Array<UIView> = []
    private var scrollView = UIScrollView()
    private var spacing: Double = 0.0
    private var currentSelectedIndex: Int?
    private var currentRealSelectedIndex: Int?
    public var delegate: SwiftCarouselDelegate?
    
    public var resizeType: SwiftCarouselResizeType = .WithoutResizing(0) {
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
        let view = viewAtLocation(CGPoint(x: scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame)/2, y: CGRectGetMinY(scrollView.frame)))
        guard var index = choices.indexOf({ $0 == view }) else {
            return nil
        }
        
        while index >= originalChoicesNumber {
            index -= originalChoicesNumber
        }
        
        return index
    }
    
    private var realSelectedIndex: Int? {
        let view = viewAtLocation(CGPoint(x: scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame)/2, y: CGRectGetMinY(scrollView.frame)))
        guard let index = choices.indexOf({ $0 == view }) else {
            return nil
        }
        
        return index
    }
    
    public var items: Array<UIView> {
        get {
            return Array<UIView>(choices[choices.count/3..<(choices.count/3 + originalChoicesNumber)])
        }
        set {
            originalChoicesNumber = newValue.count
            (0..<3).forEach { counter in
                let newViews: Array<UIView> = newValue.map { choice in
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
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(frame: CGRect, choices: Array<UIView>) {
        self.init(frame: frame)
        setup()
        items = choices
    }
    
    //MARK: - Setups
    private func setup() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: .AlignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .AlignAllCenterY, metrics: nil, views: ["scrollView": scrollView]))
        
        scrollView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }
    
    private func setupViews(views: Array<UIView>) {
        var x: CGFloat = 0.0
        if case .FloatWithSpacing(_) = resizeType {
                views.forEach{ $0.sizeToFit() }
        }
        
        views.forEach{ choice in
            var additionalSpacing: CGFloat = 0.0
            switch resizeType {
            case .WithoutResizing(let spacing): additionalSpacing = spacing
            case .FloatWithSpacing(let spacing): additionalSpacing = spacing
            case .VisibleItemsPerPage(let visibleItems):
                choice.frame.size.width = scrollView.frame.width/CGFloat(visibleItems)
                if (CGRectGetHeight(choice.frame) > 0) {
                    let aspectRatio: CGFloat = CGRectGetWidth(choice.frame)/CGRectGetHeight(choice.frame)
                    choice.frame.size.height = floor(CGRectGetWidth(choice.frame)*aspectRatio) > CGRectGetHeight(frame) ? CGRectGetHeight(frame) : floor(CGRectGetWidth(choice.frame)*aspectRatio)
                } else {
                    choice.frame.size.height = CGRectGetHeight(frame)
                }
            }
            choice.frame.origin.x = x
            x += CGRectGetWidth(choice.frame) + additionalSpacing
        }
        
        
        scrollView.subviews.forEach{ $0.removeFromSuperview() }
        views.forEach{ scrollView.addSubview($0) }
        layoutIfNeeded()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var width: CGFloat = 0.0
        switch resizeType {
        case .FloatWithSpacing(_):
            width = CGRectGetMaxX(choices.last!.frame)
        case .VisibleItemsPerPage(_):
            width = choices.reduce(0.0) { $0 + $1.frame.width}
        default:
            break
        }
        
        scrollView.contentSize = CGSize(width: width, height: frame.height)
        
        // Center the view
        if defaultSelectedIndex != nil {
            selectItem(defaultSelectedIndex!, animated: false)
        } else {
            selectItem(0, animated: false)
        }
    }
    
    //MARK: - UIScrollViewDelegate
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("Did end decelerating")
        didSelectItem()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("Did end animation")
        didSelectItem()
    }
    
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
        guard let currentRealSelectedIndex = self.currentRealSelectedIndex, currentSelectedIndex = self.currentSelectedIndex where currentSelectedIndex != selectedIndex else {
            return
        }
        
        delegate?.didDeselectItem?(item: choices[currentRealSelectedIndex], index: currentSelectedIndex)
    }
    
    public func scrollViewWillEndDecelerating(scrollView: UIScrollView) {
        var newOffset: CGFloat!
        if (CGRectGetMinX(scrollView.bounds) >= scrollView.contentSize.width * 2/3) {
            let newView = nearestViewAtLocation(CGPoint(x: scrollView.contentOffset.x - scrollView.contentSize.width * 1/3, y: CGRectGetMinY(scrollView.frame)))
            newOffset = CGRectGetMinX(newView.frame)
        } else if (CGRectGetMaxX(scrollView.bounds) <= scrollView.contentSize.width * 1/3) { // First part
            let newView = nearestViewAtLocation(CGPoint(x: scrollView.contentOffset.x + scrollView.contentSize.width * 1/3, y: CGRectGetMinY(scrollView.frame)))
            newOffset = CGRectGetMinX(newView.frame)
        }
        
        guard newOffset != nil else {
            return
        }
        
        scrollView.contentOffset.x = newOffset
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.willBeginDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        var newOffset: CGFloat!
        if (CGRectGetMinX(scrollView.bounds) >= scrollView.contentSize.width * 2/3) {
            newOffset = scrollView.contentOffset.x - scrollView.contentSize.width * 1/3
        } else if (CGRectGetMaxX(scrollView.bounds) <= scrollView.contentSize.width * 1/3) { // First part
            newOffset = scrollView.contentOffset.x + scrollView.contentSize.width * 1/3
        }
        
        guard newOffset != nil && newOffset > 0 else {
            return
        }
        
        scrollView.contentOffset.x = newOffset
        delegate?.didScroll?(toOffset: scrollView.contentOffset)
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var velocity = velocity.x * 1000.0
        if velocity > maxVelocity {
            velocity = maxVelocity
        } else if velocity < -maxVelocity {
            velocity = -maxVelocity
        }
        
        var targetX = scrollView.contentOffset.x + scrollView.frame.width/2 + velocity
        if (targetX > scrollView.contentSize.width || targetX < 0)  {
            targetX = scrollView.contentSize.width*1/3  + scrollView.frame.width/2 + velocity
        }
        
        let choiceView = nearestViewAtLocation(CGPoint(x: targetX, y: CGRectGetMinY(scrollView.frame)))
        targetContentOffset.memory.x = choiceView.center.x - scrollView.frame.width/2
    }
    
    
    private func refreshChoices() {
        scrollView.subviews.forEach{ $0.removeFromSuperview() }
    }
    
    private func willChangePart(point: CGPoint) -> Bool {
        if (point.x >= scrollView.contentSize.width * 2/3 ||
            point.x <= scrollView.contentSize.width * 1/3) {
                
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
        if case .FloatWithSpacing(let spacing) = resizeType {
            step = spacing
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
    
    //TODO: Scroll to nearest, not the original
    public func selectItem(choice: Int, animated: Bool) {
        guard choice < choices.count/3 else {
            return
        }
        let index = (choices.count/3 + choice)
        let choiceView = choices[index]
        let x = choiceView.center.x - scrollView.frame.width/2
        scrollView.setContentOffset(CGPoint(x: x, y: scrollView.contentOffset.y), animated: animated)
        if !animated {
            didSelectItem()
        }
    }
}

extension UIView {
    func copyView() -> UIView {
        let serialized = NSKeyedArchiver.archivedDataWithRootObject(self)
        return NSKeyedUnarchiver.unarchiveObjectWithData(serialized) as! UIView
    }
}
