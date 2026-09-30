[![pub package](https://img.shields.io/pub/v/cupertino_calendar_picker.svg)](https://pub.dev/packages/cupertino_calendar_picker)
[![CI](https://github.com/philip-soft/cupertino_calendar_picker/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/philip-soft/cupertino_calendar_picker/actions/workflows/ci.yml)

The package provides sleek and stylish Cupertino calendar widgets designed to mimic the aesthetics of iOS. With smooth animations and intuitive user interactions, it seamlessly integrates into your Flutter app to deliver a delightful user experience.

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
* **Accessible**: Screen reader semantics, keyboard activation and text scaling support.
* **Localized**: Weekdays, months, action labels and times follow the app's locale, including right-to-left layouts.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:
```yaml
dependencies:
  cupertino_calendar_picker: ^3.0.0
```

Import it:

```dart
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
```

This package is built on the standalone [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) and [`material_ui`](https://pub.dev/packages/material_ui) packages and requires Flutter 3.47 or newer. Your app should import them instead of `package:flutter/cupertino.dart` and `package:flutter/material.dart` (see the [migration guide](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui)).

In your `CupertinoApp` or `MaterialApp` add the `localizationsDelegates` (exported by `package:material_ui/material_ui.dart`)

```dart
CupertinoApp(
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
);
```

## Migrating from 2.x

Version 3.0.0 contains breaking changes. The most common updates are:

| 2.x | 3.0.0 |
| --- | --- |
| `import 'package:flutter/cupertino.dart'` / `material.dart` | `import 'package:cupertino_ui/cupertino_ui.dart'` / `package:material_ui/material_ui.dart` |
| `GlobalMaterialLocalizations.delegates` from `flutter_localizations` | `GlobalMaterialLocalizations.delegates` from `material_ui` |
| `CalendarDismissBehavior.onOusideTapOrDateSelect` | `CalendarDismissBehavior.onOutsideTapOrDateSelect` |
| `CalendarDismissBehavior.hasOusideTapDismiss` | `CalendarDismissBehavior.hasOutsideTapDismiss` |
| `PickerBackgroundType.transparentAndBlured` | `PickerBackgroundType.transparentAndBlurred` |
| `CancelCupertinoCalendarAction(onPressed: ...)` with an untyped `Function` | `onPressed` is a `VoidCallback` |
| `ConfirmCupertinoCalendarAction(onPressed: ...)` with an untyped `Function` | `onPressed` is a `ValueChanged<DateTime>` that receives the selected date |
| Default action labels `'Cancel'` and `'Done'` | Localized "Cancel" and "OK"; pass `label` to keep the old text |
| `widgetRenderBox` is required | `widgetRenderBox` is optional; without it the picker is centered |

The confirm and cancel actions now complete `showCupertinoCalendarPicker` with the selected date and `null` respectively. See the [changelog](https://pub.dev/packages/cupertino_calendar_picker/changelog) for the full list of changes.

## Widgets

This package offers three convenient widgets for integrating pickers directly into your app.

### `CupertinoCalendar`

The `CupertinoCalendar` widget provides an inline calendar that can be displayed directly within your screen.

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

The `CupertinoCalendarPickerButton` widget allows users to open a cupertino calendar picker when the button is pressed.

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

The button text can be changed with `formatter` and its look with `buttonDecoration`. `onCompleted` receives the result of the picker when it closes.

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

The `CupertinoTimePickerButton` widget lets users select a time in a time picker that appears when the button is pressed.

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

This package also includes two functions for displaying pickers from your widgets.

### `showCupertinoCalendarPicker`

The `showCupertinoCalendarPicker` function displays a calendar picker around your widget. Use `CupertinoCalendarMode.dateTime` to select both a date and a time.

The returned `Future` completes with the last changed date, or with `null` if the date was not changed. With a `ConfirmCupertinoCalendarAction`, it completes with the selected date only when the action is pressed (see [Actions](#actions)).

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

The `showCupertinoTimePicker` function shows a time picker around your widget. The returned `Future` completes with the last changed time, or with `null` if the time was not changed.

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

You can add actions to the calendar picker by passing a list of `CupertinoCalendarAction` objects.
The package provides two built-in actions: `CancelCupertinoCalendarAction` and `ConfirmCupertinoCalendarAction`.

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

Pressing an action closes the picker. The returned `Future` completes with the selected date when `ConfirmCupertinoCalendarAction` is pressed and with `null` when `CancelCupertinoCalendarAction` is pressed. When a `ConfirmCupertinoCalendarAction` is present, dismissing the picker by an outside tap or the back gesture also completes with `null`.

When no `label` is provided, the actions use the localized "Cancel" and "OK" labels.

> [!NOTE]
> `showCupertinoCalendarPicker` and `CupertinoCalendarPickerButton` display actions as is. The `CupertinoCalendar` widget displays them only with `type: CupertinoCalendarType.compact`.

## Dismiss behavior

`dismissBehavior` of `showCupertinoCalendarPicker` and `CupertinoCalendarPickerButton` controls how the calendar picker closes:

* `CalendarDismissBehavior.onOutsideTap` (default) — on a tap outside of the picker.
* `CalendarDismissBehavior.onDateSelect` — when a date is selected.
* `CalendarDismissBehavior.onOutsideTapOrDateSelect` — on either of the above.
* `CalendarDismissBehavior.onActionTap` — on an action tap only; requires at least one action.

Actions and the system back gesture always close the picker.

## Customization

* `selectableDayPredicate` disables individual days, e.g. weekends.
* `firstDayOfWeekIndex` overrides the locale's first day of the week, where `0` is Sunday.
* `minuteInterval` (a factor of `60`) and `use24hFormat` configure the time picker.
* `mainColor` and the decoration classes (`PickerContainerDecoration`, `CalendarHeaderDecoration`, `CalendarWeekdayDecoration`, `CalendarMonthPickerDecoration`, `CalendarFooterDecoration`, `CalendarActionDecoration`, `PickerButtonDecoration`) change the appearance. Each decoration has a `withDynamicColor` factory, and `CupertinoDynamicColor`s passed to the default constructors adapt to dark mode as well.

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

The picker opens below or above its anchor, on the side with more space, and is scaled down when it does not fit. If the space next to the anchor fits it only below half of its size, e.g. for a button in the middle of a landscape screen, the picker is centered on the screen instead. Without a `widgetRenderBox`, the picker is always centered.

The functions and the buttons share these parameters:

* `offset` — the distance between the anchor and the picker, `Offset(0, 10)` by default.
* `horizontalSpacing` and `verticalSpacing` — the minimum distance to the screen edges and the safe area, `15.0` by default.
* `barrierColor` — the color of the area around the picker, transparent by default.
* `useRootNavigator` — set to `false` to show the picker in the nearest nested navigator.

### How to get a `RenderBox`?

Pass the `RenderBox` of the widget the picker should open next to as `widgetRenderBox`. You can get it from a `BuildContext` below that widget, e.g. with a `Builder`:

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

or with a `GlobalKey` assigned to that widget:

```dart
final GlobalKey anchorKey = GlobalKey();

// YourWidget(key: anchorKey, ...)

final RenderBox? renderBox =
    anchorKey.currentContext?.findRenderObject() as RenderBox?;
```

## Accessibility and localization

* Days, the header, the time footer, actions, picker buttons and the dismiss barrier have screen reader semantics, and the newly displayed month is announced when switching months.
* Clickable elements can be activated with the keyboard.
* The picker adapts to the system text scale.
* Weekdays, month names, action labels and times use the ambient locale, provided by `GlobalMaterialLocalizations.delegates`. The first day of the week comes from the locale unless `firstDayOfWeekIndex` is set.
* The 12- or 24-hour format follows the system setting unless `use24hFormat` is set.
* Right-to-left layouts are supported.

## Additional information

* A complete example app is available in the [`example`](https://github.com/philip-soft/cupertino_calendar_picker/tree/master/example) folder.
* See the [API reference](https://pub.dev/documentation/cupertino_calendar_picker/latest/) for all parameters.
* Bug reports and feature requests are welcome in the [issue tracker](https://github.com/philip-soft/cupertino_calendar_picker/issues). Pull requests are appreciated too.

## Maintainers

[Philip Dmitruk](https://github.com/philip-soft)
