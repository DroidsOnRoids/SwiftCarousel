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


@objc public protocol SwiftCarouselDelegate {
    /**
     Delegate method that fires up when item has been selected.
     If there was an animation, it fires up _after_ animation.
     Warning! Do not rely on item to get index from your data source. 
     Index is passed as a variable in that function and you should use it instead.
     
     - parameter item:  Item that is selected. You can style it as you want.
     - parameter index: Index of selected item that you can use with your data source.
     - parameter tapped: Indicate that the item has been tapped, true it means that it was tapped before the selection, and false that was scrolled.
     
     - returns: Return UIView that you customized (or not).
     */
    @objc optional func didSelectItem(item: UIView, index: Int, tapped: Bool) -> UIView?
    
    /**
     Delegate method that fires up when item has been deselected.
     If there was an animation, it fires up _after_ animation.
     Warning! Do not rely on item to get index from your data source.
     Index is passed as a variable in that function and you should use it instead.
     
     - parameter item:  Item that is deselected. You can style it as you want.
     - parameter index: Index of deselected item that you can use with your data source.
     
     - returns: Return UIView that you customized (or not).
     */
    @objc optional func didDeselectItem(item: UIView, index: Int) -> UIView?
    
    /**
     Delegate method that fires up when Carousel has been scrolled.
     
     - parameter offset: New offset of the Carousel.
     */
    @objc optional func didScroll(toOffset offset: CGPoint)
    /**
     Delegate method that fires up just before someone did dragging.
     
     - parameter offset: Current offset of the Carousel.
     */
    @objc optional func willBeginDragging(withOffset offset: CGPoint)
    /**
     Delegate method that fires up right after someone did end dragging.
     
     - parameter offset: New offset of the Carousel.
     */
    @objc optional func didEndDragging(withOffset offset: CGPoint)
}
