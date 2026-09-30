[![pub package](https://img.shields.io/pub/v/cupertino_calendar_picker.svg)](https://pub.dev/packages/cupertino_calendar_picker)
[![CI](https://github.com/philip-soft/cupertino_calendar_picker/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/philip-soft/cupertino_calendar_picker/actions/workflows/ci.yml)

Date and time pickers for Flutter that look and behave like the ones in iOS. Use them as an inline calendar, as a button that opens a picker, or open a picker next to any widget.

<p>
   <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker.gif?raw=true"
    alt="Cupertino Calendar Picker" width="320"/>
  &nbsp; &nbsp;
   <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_time_picker.gif?raw=true"
    alt="Cupertino Time Picker" width="320"/>
</p>

## Features

* **iOS Style**: The cupertino calendar picker follows the design principles of iOS, ensuring consistency and familiarity for iOS users.
* **Smooth Animations**: Enjoy fluid animations that enhance the overall look and feel of the calendar, providing a polished user experience.
* **Customizable**: Easily customize the appearance of the calendar to match your app's theme and branding.
* **Intuitive Interactions**: Users can effortlessly navigate through years, months and interact with the calendar thanks to its intuitive design.
* **Accessible**: Works with screen readers, keyboards and large text sizes.
* **Localized**: Dates, times and button labels follow the app's language, including right-to-left languages.

## Getting started

Add the package to the `pubspec.yaml` of your Flutter project:

```yaml
dependencies:
  cupertino_calendar_picker: ^3.0.0
```

Then import it:

```dart
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
```

The package requires Flutter 3.47 or newer and is built on the standalone [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) and [`material_ui`](https://pub.dev/packages/material_ui) packages. Your app should use these packages too, instead of `package:flutter/cupertino.dart` and `package:flutter/material.dart`. See the [migration guide](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui) for details.

The pickers use Flutter's localizations for month names, weekdays and button labels. Add them to your `CupertinoApp` or `MaterialApp` (`GlobalMaterialLocalizations` comes from `package:material_ui/material_ui.dart`):

```dart
CupertinoApp(
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
);
```

## Migrating from 2.x

Version 3.0.0 has breaking changes. Here is what you will most likely need to update:

| In 2.x | In 3.0.0 |
| --- | --- |
| `import 'package:flutter/cupertino.dart';` | `import 'package:cupertino_ui/cupertino_ui.dart';` |
| `import 'package:flutter/material.dart';` | `import 'package:material_ui/material_ui.dart';` |
| `GlobalMaterialLocalizations.delegates` from `flutter_localizations` | The same delegates, imported from `material_ui` |
| `CalendarDismissBehavior.onOusideTapOrDateSelect` | `CalendarDismissBehavior.onOutsideTapOrDateSelect` (typo fixed) |
| `CalendarDismissBehavior.hasOusideTapDismiss` | `CalendarDismissBehavior.hasOutsideTapDismiss` (typo fixed) |
| `PickerBackgroundType.transparentAndBlured` | `PickerBackgroundType.transparentAndBlurred` (typo fixed) |
| `CancelCupertinoCalendarAction(onPressed: ...)` accepted any function | `onPressed: () {}` — takes no arguments |
| `ConfirmCupertinoCalendarAction(onPressed: ...)` accepted any function | `onPressed: (dateTime) {}` — receives the selected date |
| Actions were labeled "Cancel" and "Done" by default | They are labeled "Cancel" and "OK" in the app's language. Pass `label: 'Done'` to keep the old text |
| `widgetRenderBox` was required | `widgetRenderBox` is optional. Without it, the picker opens in the center of the screen |

Pressing the confirm action now returns the selected date from `showCupertinoCalendarPicker`, and pressing the cancel action returns `null`. See the [changelog](https://pub.dev/packages/cupertino_calendar_picker/changelog) for the full list of changes.

## Widgets

The package has three widgets that you can put directly into your layout.

### `CupertinoCalendar`

A calendar that is shown directly on your screen, without opening a popup.

<p>
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_inline_calendar_light.png?raw=true"
    alt="Cupertino Inline Calendar Light" width="320"/>
  &nbsp; &nbsp;
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_inline_calendar_dark.png?raw=true"
    alt="Cupertino Inline Calendar Dark" width="320"/>
</p>

#### Usage Example

```dart
SizedBox(
  width: 350,
  child: CupertinoCalendar(
    minimumDateTime: DateTime(2024, 7, 10),
    maximumDateTime: DateTime(2025, 7, 10),
    initialDateTime: DateTime(2024, 8, 15, 9, 41),
    currentDateTime: DateTime(2024, 8, 15),
    timeLabel: 'Ends',
    mode: CupertinoCalendarMode.dateTime,
  ),
),
```

### `CupertinoCalendarPickerButton`

A button that shows the selected date and opens a calendar picker when pressed.

<p>
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker_button_light.png?raw=true"
    alt="Cupertino Calendar Picker Button Light" width="320"/>
  &nbsp; &nbsp;
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker_button_dark.png?raw=true"
    alt="Cupertino Calendar Picker Button Dark" width="320"/>
</p>

#### Usage Example

```dart
CupertinoCalendarPickerButton(
  minimumDateTime: DateTime(2024, 7, 10),
  maximumDateTime: DateTime(2025, 7, 10),
  initialDateTime: DateTime(2024, 8, 15, 9, 41),
  currentDateTime: DateTime(2024, 8, 15),
  mode: CupertinoCalendarMode.dateTime,
  timeLabel: 'Ends',
  onDateTimeChanged: (date) {},
),
```

Use `formatter` to change how the date is written on the button, and `buttonDecoration` to change its colors and text style. `onCompleted` is called when the picker closes, with the selected date or `null` if nothing was selected.

```dart
CupertinoCalendarPickerButton(
  minimumDateTime: DateTime(2024, 7, 10),
  maximumDateTime: DateTime(2025, 7, 10),
  formatter: (dateTime) => DateFormat.yMMMMd().format(dateTime), // package:intl
  buttonDecoration: PickerButtonDecoration(
    backgroundColor: CupertinoColors.systemGrey5,
  ),
  onCompleted: (dateTime) {},
),
```

### `CupertinoTimePickerButton`

A button that shows the selected time and opens a time picker when pressed.

<p>
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_time_picker_button_light.png?raw=true"
    alt="Cupertino Time Picker Button Light" width="320"/>
  &nbsp; &nbsp;
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_time_picker_button_dark.png?raw=true"
    alt="Cupertino Time Picker Button Dark" width="320"/>
</p>

#### Usage Example

```dart
CupertinoTimePickerButton(
  initialTime: const TimeOfDay(hour: 9, minute: 41),
  onTimeChanged: (time) {},
),
```

## Functions

If you want to use your own button, open a picker with one of these functions.

### `showCupertinoCalendarPicker`

Opens a calendar picker next to your widget. Use `CupertinoCalendarMode.dateTime` to select both a date and a time.

The function returns the date the user picked, or `null` if they closed the picker without changing the date. If you add a `ConfirmCupertinoCalendarAction`, the date is returned only when the user presses it; closing the picker any other way returns `null` (see [Actions](#actions)).

#### Usage Example

```dart
Future<DateTime?> onCalendarWidgetTap(BuildContext context) async {
  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
  final nowDate = DateTime.now();

  return showCupertinoCalendarPicker(
    context,
    widgetRenderBox: renderBox,
    minimumDateTime: nowDate.subtract(const Duration(days: 15)),
    initialDateTime: nowDate,
    maximumDateTime: nowDate.add(const Duration(days: 360)),
    mode: CupertinoCalendarMode.dateTime,
    timeLabel: 'Ends',
    onDateTimeChanged: (dateTime) {},
  );
}
```

### `showCupertinoTimePicker`

Opens a time picker next to your widget. The function returns the time the user picked, or `null` if they closed the picker without changing the time.

#### Usage Example

```dart
Future<TimeOfDay?> onTimeWidgetTap(BuildContext context) async {
  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

  return showCupertinoTimePicker(
    context,
    widgetRenderBox: renderBox,
    onTimeChanged: (time) {},
  );
}
```

## Actions

You can add Cancel and Confirm buttons to the bottom of the calendar picker by passing `CancelCupertinoCalendarAction` and `ConfirmCupertinoCalendarAction` in `actions`.

<p>
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker_with_actions_light.png?raw=true"
    alt="Cupertino Calendar Picker With Actions Light" width="320"/>
  &nbsp; &nbsp;
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker_with_actions_dark.png?raw=true"
    alt="Cupertino Calendar Picker With Actions Dark" width="320"/>
</p>

#### Usage Example

```dart
Future<DateTime?> onCalendarWidgetTap(BuildContext context) async {
  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
  final nowDate = DateTime.now();

  return showCupertinoCalendarPicker(
    context,
    widgetRenderBox: renderBox,
    minimumDateTime: nowDate.subtract(const Duration(days: 15)),
    initialDateTime: nowDate,
    maximumDateTime: nowDate.add(const Duration(days: 360)),
    actions: [
      CancelCupertinoCalendarAction(
        onPressed: () {},
      ),
      ConfirmCupertinoCalendarAction(
        label: 'Done',
        onPressed: (dateTime) {},
      ),
    ],
  );
}
```

Pressing either button closes the picker. Confirm returns the selected date and Cancel returns `null`. If there is a Confirm button, closing the picker in any other way, by tapping outside of it or with the back gesture, also returns `null`.

Without a `label`, the buttons are labeled "Cancel" and "OK" in the app's language.

> [!NOTE]
> `showCupertinoCalendarPicker` and `CupertinoCalendarPickerButton` always show the actions. The `CupertinoCalendar` widget shows them only with `type: CupertinoCalendarType.compact`.

## Dismiss behavior

Use `dismissBehavior` of `showCupertinoCalendarPicker` and `CupertinoCalendarPickerButton` to choose when the calendar picker closes:

* `CalendarDismissBehavior.onOutsideTap` (default) — when the user taps outside of the picker.
* `CalendarDismissBehavior.onDateSelect` — when the user selects a date.
* `CalendarDismissBehavior.onOutsideTapOrDateSelect` — in both of these cases.
* `CalendarDismissBehavior.onActionTap` — only when the user presses an action. You must add at least one action.

The action buttons and the system back gesture always close the picker.

## Customization

* `selectableDayPredicate` makes some days unselectable, e.g. weekends.
* `firstDayOfWeekIndex` sets the first day of the week, where `0` is Sunday. By default, it depends on the app's language.
* `minuteInterval` sets the step of the minute wheel, e.g. `5` or `15`. It must divide `60` evenly.
* `use24hFormat` switches between the 12- and 24-hour time format.
* `mainColor` sets the accent color, e.g. of the selected day.
* Decoration classes change the look of each part of the picker: `PickerContainerDecoration`, `CalendarHeaderDecoration`, `CalendarWeekdayDecoration`, `CalendarMonthPickerDecoration`, `CalendarFooterDecoration`, `CalendarActionDecoration` and `PickerButtonDecoration`. Colors like `CupertinoColors.systemBlue` switch between the light and the dark mode automatically.

```dart
CupertinoCalendarPickerButton(
  minimumDateTime: DateTime(2024, 7, 10),
  maximumDateTime: DateTime(2025, 7, 10),
  selectableDayPredicate: (day) =>
      day.weekday != DateTime.saturday && day.weekday != DateTime.sunday,
  firstDayOfWeekIndex: 1,
  mainColor: CupertinoColors.systemBlue,
  containerDecoration: PickerContainerDecoration(
    backgroundType: PickerBackgroundType.plainColor,
  ),
),
```

## Positioning

The picker opens next to the widget it was opened from: below it or above it, wherever there is more room. If the picker does not fit, it is shrunk. If it would have to shrink to less than half of its size, for example for a button in the middle of a landscape screen, it opens in the center of the screen instead. Without a `widgetRenderBox`, the picker always opens in the center.

You can adjust the position with these parameters of the functions and the buttons:

* `offset` — the gap between the widget and the picker. Default: `Offset(0, 10)`.
* `horizontalSpacing` and `verticalSpacing` — the minimum gap between the picker and the edges of the screen, not counting the notch and system bars. Default: `15.0`.
* `barrierColor` — the color of the screen behind the picker. Default: transparent.
* `useRootNavigator` — by default, the picker is shown on top of the whole app. Set it to `false` to show it inside the nearest nested `Navigator`, e.g. inside a tab.

### How to get a `RenderBox`?

To open the picker next to a widget, pass that widget's `RenderBox` as `widgetRenderBox`. The simplest way to get it is to wrap the widget in a `Builder` and use the `Builder`'s `context`:

```dart
Builder(
  builder: (context) {
    return YourWidget(
      onTap: () => showCupertinoCalendarPicker(
        context,
        widgetRenderBox: context.findRenderObject() as RenderBox?,
        minimumDateTime: DateTime(2024, 7, 10),
        maximumDateTime: DateTime(2025, 7, 10),
      ),
    );
  },
);
```

Or give the widget a `GlobalKey` and get the `RenderBox` from it:

```dart
final GlobalKey buttonKey = GlobalKey();

// In build():
YourWidget(key: buttonKey, onTap: openPicker);

// When opening the picker:
Future<void> openPicker() async {
  await showCupertinoCalendarPicker(
    context,
    widgetRenderBox:
        buttonKey.currentContext?.findRenderObject() as RenderBox?,
    minimumDateTime: DateTime(2024, 7, 10),
    maximumDateTime: DateTime(2025, 7, 10),
  );
}
```

## Accessibility and localization

* Screen readers (VoiceOver and TalkBack) can read every part of the picker: days, the month switcher, the time, the buttons, and the area outside the picker that closes it. When the user switches months, the new month is read out.
* All buttons can be pressed with a keyboard.
* The text grows with the system text size setting.
* Weekday and month names, button labels and times are shown in the app's language, as set up by `GlobalMaterialLocalizations.delegates`. The week starts on the day that is usual for that language; use `firstDayOfWeekIndex` to change it.
* Times use the 12- or 24-hour format from the device settings; use `use24hFormat` to change it.
* Right-to-left languages, such as Arabic and Hebrew, are supported.

## Additional information

* A complete example app is available in the [`example`](https://github.com/philip-soft/cupertino_calendar_picker/tree/master/example) folder.
* All parameters are described in the [API reference](https://pub.dev/documentation/cupertino_calendar_picker/latest/).
* Bug reports and feature requests are welcome in the [issue tracker](https://github.com/philip-soft/cupertino_calendar_picker/issues). Pull requests are appreciated too.

## Maintainers

[Philip Dmitruk](https://github.com/philip-soft)
