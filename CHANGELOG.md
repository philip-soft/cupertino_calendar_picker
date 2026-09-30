## 3.0.0

* **Breaking:** Migrated from the in-SDK `package:flutter/material.dart` and `package:flutter/cupertino.dart` libraries to the standalone [`material_ui`](https://pub.dev/packages/material_ui) and [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) packages. Apps using this package must migrate as well, see the [migration guide](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui).
* **Breaking:** Minimum supported versions raised to Flutter `3.47.0` and Dart `3.13.0`.
* Removed the `flutter_localizations` dependency; use `GlobalMaterialLocalizations.delegates` from `package:material_ui` instead.
* Add accessibility support for screen readers (WCAG/BITV compliance) (Thanks to [@mikailsyr](https://github.com/philip-soft/cupertino_calendar_picker/pull/60))
* **Breaking:** Fixed the misspelled `CalendarDismissBehavior.onOusideTapOrDateSelect`, `CalendarDismissBehavior.hasOusideTapDismiss` and `PickerBackgroundType.transparentAndBlured`, renamed to `onOutsideTapOrDateSelect`, `hasOutsideTapDismiss` and `transparentAndBlurred`.
* **Breaking:** `CancelCupertinoCalendarAction.onPressed` is now a `VoidCallback` and `ConfirmCupertinoCalendarAction.onPressed` is a `ValueChanged<DateTime>`, instead of an untyped `Function`.
* **Breaking:** Action labels default to the localized "Cancel" and "OK" labels. `CupertinoCalendarAction.label` is nullable; use `effectiveLabel` to get the displayed label.
* **Breaking:** Decoration fields are non-nullable where a default always exists, and `copyWith` of the selected day styles keeps `backgroundCircleColor`. `CalendarHeaderDecoration`, `CalendarMonthPickerSelectedDayStyle`, `CalendarMonthPickerSelectedCurrentDayStyle` and `CalendarMonthPickerCurrentDayStyle` default to `CupertinoColors.systemRed` when no `mainColor` is given.
* **Breaking:** `widgetRenderBox` of `showCupertinoCalendarPicker` and `showCupertinoTimePicker` is optional; without it the picker is centered.
* **Breaking:** Cross-type equality of actions was removed: a `CancelCupertinoCalendarAction` never equals a `ConfirmCupertinoCalendarAction`.
* Fixed `CancelCupertinoCalendarAction` completing `showCupertinoCalendarPicker` with the changed date, and `ConfirmCupertinoCalendarAction` completing it with `null` when the date was not changed. With a confirm action, dismissing by an outside tap or the back gesture now completes with `null`.
* Fixed `CupertinoCalendarPickerButton` not displaying the confirmed date when a `ConfirmCupertinoCalendarAction` is used.
* Fixed actions of a compact `CupertinoCalendar` placed outside of an overlay popping the hosting route.
* Fixed an assertion and a broken month page when today is outside of the `minimumDateTime`...`maximumDateTime` range and no initial date is given. The default date and time are now limited to the range in all widgets.
* Fixed the AM/PM switcher producing a time outside of the allowed range.
* Fixed the displayed month shifting when `minimumDateTime` changes, and the selection staying outside of a range that shrank.
* Fixed `CupertinoCalendar` jumping back to the month of the selected date, without reporting it through `onDisplayedMonthChanged`, when the range changes after navigating to another month.
* Fixed an assertion when the time picker opens with a time that is not a multiple of `minuteInterval`, e.g. the default current time. The time wheel rounds the time down to the interval.
* Fixed the horizontal `offset` moving the picker past `horizontalSpacing` when it is pinned to a screen edge.
* Fixed `CupertinoCalendarPickerButton` and `CupertinoTimePickerButton` filling the whole width of a `Center`, `Align` or `Column`. The buttons hug their title unless the parent forces a width.
* Fixed the picker staying at its old position when the screen rotates while it is open.
* Fixed the picker crossing `horizontalSpacing` on screens narrower than the picker.
* Fixed the picker being displayed partially off the screen or under the safe area when its anchor is partially outside of the screen.
* Fixed the picker opened above its anchor being placed closer to it than `offset`.
* The picker is centered on the screen when the space next to its anchor fits it only below half of its size, e.g. for a button in the middle of a landscape screen. Previously it was shrunk, down to being invisible for an anchor covering the screen.
* Fixed the day overflowing into the next month when switching to a shorter month in the year picker.
* Fixed the picker being misplaced in a nested navigator (`useRootNavigator: false`) and the right safe area being ignored when the picker is pinned to the right edge.
* Fixed `PickerContainerDecoration.copyWith` resetting `backgroundType`.
* Fixed dynamic colors of decorations created without a `BuildContext` not adapting to dark mode.
* Fixed a leak of `CurvedAnimation`s in the picker container.
* Fixed `PickerContainerDecoration` turning a `CupertinoDynamicColor` into a light-only color when limiting its opacity, e.g. `PickerContainerDecoration()` stayed white in dark mode. `PickerContainerDecoration.withDynamicColor` now only limits the opacity of a custom color instead of raising it.
* Fixed the one-letter weekdays at large text scales repeating the same letter in some locales, e.g. Chinese and Arabic.
* Fixed the month switcher and the year picker chevrons not being mirrored in right-to-left layouts.
* Fixed the picker closing a route pushed on top of it from a callback, e.g. `onDateSelected`.
* Fixed `setState` being called by `CupertinoCalendarPickerButton` and `CupertinoTimePickerButton` when they are disposed while their picker is open.
* `CupertinoCalendar`, `CupertinoCalendarPickerButton` and `CupertinoTimePickerButton` report the selection through `onDateTimeChanged`/`onTimeChanged` when a changed range limits it.
* The 12-hour time is formatted with the day period placed as the locale expects, e.g. `下午 3:07`.
* The newly displayed month is announced to screen readers when switching months.
* Times are formatted with the ambient locale.
* Exported `CupertinoCalendarAction` and `CalendarButtonFormatter`.
* Added `horizontalSpacing` and `verticalSpacing` to `CupertinoCalendarPickerButton` and `CupertinoTimePickerButton`.
* Added semantics to the days, header, footer, actions, picker buttons and the dismiss barrier, and keyboard activation to the buttons.
* Added value equality to decoration classes.
* `CupertinoCalendar` has a `const` constructor.

## 2.2.6

* Added `selectableDayPredicate` callback parameter to the calendar, allowing certain dates to be disabled. (Thanks to [@Menelphor](https://github.com/philip-soft/cupertino_calendar_picker/pull/54))

## 2.2.5

* Added `useRootNavigator` parameter to dialog functions and buttons, allowing to disable the root navigator for displaying the picker. (Thanks to [@pablodekeyzer](https://github.com/philip-soft/cupertino_calendar_picker/issues/52))

## 2.2.4

* Fixed an issue with wrong weekday generation caused by daylight saving time differences. (Thanks to [@vixez](https://github.com/philip-soft/cupertino_calendar_picker/issues/49))

## 2.2.3

* Fixed an issue where `xAlignment` was calculated incorrectly when the `CupertinoCalendarPicker` downscaled because of the lack of space. (Thanks to [@maxfrees](https://github.com/philip-soft/cupertino_calendar_picker/issues/45))
* Added accessibility text scaling to the `CupertinoCalendarPicker` and `CupertinoPickerButton` widgets. (Thanks to [@ervindobri](https://github.com/philip-soft/cupertino_calendar_picker/issues/44))
* Default `fontSize` for `CalendarMonthPickerSelectedDay` and `CalendarMonthPickerSelectedCurrentDay` has been decreased from `22.0` to `20.0`.

## 2.2.2

* Fixed an issue when `setState` was called after the `CupertinoPickerButton` was disposed. (Thanks to [@nightmre789](https://github.com/philip-soft/cupertino_calendar_picker/pull/40))

## 2.2.1

* The `intl` package version constraint has been updated to the range `>=0.19.0 <0.21.0`. (Thanks to [@KoheiKanagu](https://github.com/philip-soft/cupertino_calendar_picker/pull/37))

## 2.2.0

* Added `CupertinoCalendarAction` list to the `CupertinoCalendar` widget, allowing to display actions at the bottom of the calendar.
* Added `CalendarDismissBehavior.onActionTap` allowing to dismiss the calendar only when an action is tapped.

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
