## 1.1.0

* The `CupertinoCalendarPicker` position calculation updates:
  * The calendar will be downscaled if it doesn't fit on a screen.
  * `safeArea` is now considered in the calculation.
  * `verticalSpacing` is now considered in the calculation.
  * Available space calculation fixes.
* New params are added to the `showCupertinoCalendarPicker`
  * `verticalSpacing` to set the minimum space between the end of the screen and the calendar.
  * `barrierColor` for the overlay background color.
* `CalendarContainerDecoration` class updates:
    * Default `boxShadow` updated.
    * `CalendarBackgroundType` enum added with `plainColor` and `transparentAndBlured` values.
* Other improvements:
  * `innerAlignment` of the calendar is always `topCenter` now.
 
## 1.0.3

* `cupertino_icons` dependency added
* `widgetRenderBox` is required now
* `pubspec` screenshots update

## 1.0.2

* Decoration classes updated (copyWith, documentation)
* `pubspec` update

## 1.0.1

* README fix
* `pubspec` update

## 1.0.0

* The cupertino calendar package release.
