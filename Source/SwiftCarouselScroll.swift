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

public func ==(lhs: SwiftCarouselScroll, rhs: SwiftCarouselScroll) -> Bool {
    return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
}

/// Type for defining if the carousel should be constrained when scrolling.
public enum SwiftCarouselScroll: Equatable {
    /// .Default = .Freely
    case Default
    /// Set maximum number of items that user can scroll
    /// If you pass 0, it will be set to .None.
    case Max(UInt)
    /// Don't allow scrolling.
    case None
    /// Doesn't limit the scroll at all. You can scroll how far you want.
    case Freely
    /// TODO:
    // Set exact amount of items per scroll.
    // case Amount(UInt)
}
