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

/// Enum to indicate resize type Carousel will be using.
public enum SwiftCarouselResizeType {
    /// WithoutResizing is adding frames as they are.
    /// Parameter = spacing between UIViews.
    /// !!You need to pass correct frame sizes as items!!
    case withoutResizing(CGFloat)
    
    /// VisibleItemsPerPage will try to fit the number of items you specify
    /// in the whole screen (will resize them of course).
    /// Parameter = number of items visible on screen.
    case visibleItemsPerPage(Int)
    
    /// FloatWithSpacing will use sizeToFit() on your views to correctly place images
    /// It is helpful for instance with UILabels (Example1 in Examples folder).
    /// Parameter = spacing between UIViews.
    case floatWithSpacing(CGFloat)
}
