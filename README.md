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

## Widgets

This package offers three convenient widgets for integrating pickers directly into your app.

### `CupertinoCalendar` Widget.

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

### `CupertinoCalendarPickerButton` Widget.

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

### `CupertinoTimePickerButton` Widget.

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

### `showCupertinoCalendarPicker` function.

The `showCupertinoCalendarPicker` function displays a calendar picker around your widget.
- From version 2.0.0, you can specify the `CupertinoCalendarMode` to allow selection of both date and time.

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

### `showCupertinoTimePicker` function.

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

## How to get a `RenderBox`?
The picker is displayed above or below the widget whose `RenderBox` is passed as `widgetRenderBox`. Without it, the picker is centered on the screen.

There are 3 simple ways of how you can get the widget's render box to pass it to the `showCupertinoCalendarPicker` or `showCupertinoTimePicker` function.

You can choose **any** of these.

1. Wrap your widget with `Builder` widget.

```dart
Builder(
  builder: (context) {
    return YourWidget(
      onTap: () => onTap(context),
    );
  },
);

Future<void> onTap(BuildContext context) {
  /// And here you can get the `RenderBox` of your widget 
  /// using the `Builder`s `BuildContext`
  final renderBox = context.findRenderObject() as RenderBox?;
  return showCupertinoCalendarPicker(...);
}

```

2. Use a `GlobalKey`.

```dart
final globalKey = GlobalKey();

@override
Widget build(BuildContext context) {
  return CupertinoApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: CupertinoPageScaffold(
      child: YourWidget(
        key: globalKey,
        onTap: onTap,
      ),
    ),
  );
}

Future<void> onTap() {
  /// And here you can get the `RenderBox` of your widget using the `GlobalKey`.
  final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
  return showCupertinoCalendarPicker(...);
}

```

3. Pass a `BuildContext` directly from your widget's `build` method.

```dart
class YourWidget extends StatelessWidget {
  const YourWidget({
    required this.onTap,
  });

  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: ...,
    );
  }
}

Future<void> onTap(BuildContext context) {
  /// And here you can get the `RenderBox` of your widget's `build` method.
  final renderBox = context.findRenderObject() as RenderBox?;
  return showCupertinoCalendarPicker(...);
}

```

## Maintainers

[Philip Dmitruk](https://github.com/philip-soft)
