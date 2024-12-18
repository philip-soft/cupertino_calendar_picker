## 2.1.0

* `intl` package is now being used for date and time formatting.
* `withOpacity` method was replaced by `withAlpha` due to deprecation.

## 2.0.1

* `use24hFormat` param has been added to all widgets. (Thanks to @sargntpi)
* `dismissBehavior` param has been added to the `CupertinoCalendarPickerButton` widget.

## 2.0.0+1

* `README` update.

## 2.0.0

**Major Updates**:
  * New `showCupertinoTimePicker` function which can be used for time selection.
  * New `CupertinoCalendarPickerButton` widget.
  * New `CupertinoTimePickerButton` widget.
  * New `CupertinoCalendar` widget. Which is now can be used as `inline` calendar.
  * New `CupertinoCalendarMode` parameter with `date` and `dateTime` options, enabling the calendar to select both date and time within the picker.

**Minor Updates**:
  * The `CupertinoCalendarPicker` updates:
  * * The `monthDateStyle` is now animated when switching between the month/year picker and month picker modes.
  * * Weekdays are now aligned more accurately.
  * * The month/year picker mode switching animation has been updated. 

**Breaking Changes**:
  * `CalendarContainerDecoration` has been renamed to `PickerContainerDecoration`.
  * `CalendarBackgroundType` has been renamed to `PickerBackgroundType`.
  * `dismissBehaviour` has been renamed to `dismissBehavior`.
  * `minimumDate` has been renamed to `minimumDateTime`.
  * `maximumDate` has been renamed to `maximumDateTime`.
  * `initialDate` has been renamed to `initialDateTime`.
  * `currentDate` has been renamed to `currentDateTime`.
  * `onDateChanged` has been renamed to `onDateTimeChanged`.

## 1.1.2

* The `CalendarDismissBehavior` enum was added to specify different dismiss behaviors.
* The `onDateSelected` parameter was added.
* The `showCupertinoCalendarPicker` function now returns a `DateTime`.
* Fixed an issue where the calendar closed without animation when the Android back button was tapped. (Thanks to @JCKodel)

## 1.1.1

* Fixed an issue where `safeArea` top wasn't considered in the position calculation.
* Fixed an issue where `CalendarContainerDecoration` wasn't applied to the calendar.

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

* `README` fix
* `pubspec` update

## 1.0.0

* The cupertino calendar package release.
