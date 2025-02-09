## 2.1.7

* Added `firstDayOfWeekIndex` parameter to calendar widgets, allowing customization of the starting day of the week. If not specified, the locale's default value is used.

## 2.1.6

* Added `onCompleted` callback to `CupertinoCalendarPickerButton` and `CupertinoTimePickerButton`. (Thanks to [@MrLightful](https://github.com/philip-soft/cupertino_calendar_picker/pull/29))
* The minimum required Flutter SDK is set to `v3.24.0`.
* The minimum required Dart SDK is set to `v3.2.0`.

## 2.1.5

* Updated the `scaleAlignment` calculation for the X-axis.

## 2.1.4

* Thanks to [@desarrolladorits2](https://github.com/philip-soft/cupertino_calendar_picker/pull/26) for the following changes:
  * Fixed a bug that caused an exception during time parsing in certain localizations.
  * `dayPeriodTextStyle` property has been added to the `CalendarFooterDecoration` class.

## 2.1.3

* Fixed scrolling behavior in Date/Time pickers when using a mouse on Desktop and Web platforms. (Thanks to [@klondikedragon](https://github.com/philip-soft/cupertino_calendar_picker/pull/22))

## 2.1.2

* Removed redundant assertions for `currentDateTime`. (Thanks to [@danielshuk](https://github.com/philip-soft/cupertino_calendar_picker/issues/19))

## 2.1.1

* `CustomCupertinoDatePicker` was updated to use the version introduced in Flutter `3.27.0`
* `a` getter was replaced by `alpha` to maintain compatibility with the current minimum SDK version.

## 2.1.0

* `intl` package is now being used for date and time formatting.
* `withOpacity` method was replaced by `withAlpha` due to deprecation.

## 2.0.1

* `use24hFormat` param has been added to all widgets. (Thanks to [@sargntpi](https://github.com/philip-soft/cupertino_calendar_picker/pull/12))
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
* Fixed an issue where the calendar closed without animation when the Android back button was tapped. (Thanks to [@JCKodel](https://github.com/philip-soft/cupertino_calendar_picker/issues/3))

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
