# Next

# 0.5
- Add `itemsFactory(itemsCount:factory:)` method which can be used instead of items variable to set the carousel views.
- **Breaking change** Replace convenience init `init(frame:choices:)` to `init(frame:items:)`.
- Change Example2 to use `itemsFactory(itemsCount:factory:)` instead of `items`.
- Improve `UIView().copyView()` (it will copy also constraints now for view & subviews).

# 0.4.1
- Quickfix to bug that was created by 0.4, when you scrolled one on the left or right, the scroll would freak out.
- Fix to default selecting, now it behaves correctly.

# 0.4
- 🚀Fixed bug when you spinned the carousel while it was spinning. When you did this, the carousel would mess up the destination target and wouldn’t really select the item in the middle, but slightly off.

# 0.3
- Clicking (or tapping) on item now by default selects the item in carousel.

# 0.2.2
- Fixed `selectItem(_:animated)`.

# 0.2
- Moved from scroll delegates to KVO observing as the core of carousel.
- Added `.FloatWithSpacing()` and `.WithoutResizing()` implementations.

# 0.1
- Initial release.🎉
