## 1.1.0

* Updates to the `CupertinoCalendarPicker` position calculation:
  * The calendar will be downscaled if it doesn't fit on a screen.
  * `safeArea` is now considered in the calculation.
  * `verticalSpacing` is now considered in the calculation.
  * Available space calculation fixes.
* New parameters added to the `showCupertinoCalendarPicker`:
  * `verticalSpacing` to set the minimum space between the edge of the screen and the calendar.
  * `barrierColor` for the overlay background color.
* Updates to the `CalendarContainerDecoration` class:
    * Default `boxShadow` has been updated.
    * `CalendarBackgroundType` enum added with `plainColor` and `transparentAndBlured` values.
* Other improvements:
  * The `innerAlignment` of the calendar is always `topCenter` now.
  * The selected day will remain after the month/year wheel value change. 
 
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
