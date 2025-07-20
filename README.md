The package provides a sleek and stylish cupertino calendar widgets designed to mimic the aesthetics of iOS. With smooth animations and intuitive user interactions, it seamlessly integrates into your Flutter app to deliver a delightful user experience.

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
  cupertino_calendar_picker: ^2.2.6
```

Import it:

```dart
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
```

In your `CupertinoApp` or `MaterialApp` add the `localizationsDelegates`

```dart
CupertinoApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
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
    alt="Cupertino Time Picker Button Light" width="320"/>
  &nbsp; &nbsp;
  <img src="https://github.com/philip-soft/cupertino_calendar_picker/blob/master/doc/cupertino_calendar_picker_button_dark.png?raw=true"
    alt="Cupertino Time Picker Button Dark" width="320"/>
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

The `CupertinoTimePickerButton` widget lets users select a time via the calendar time picker that appears when the button is pressed.

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

### Actions

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
    timeLabel: 'Ends',
    actions: [
      CancelCupertinoCalendarAction(
        label: 'Cancel',
        onPressed: () {},
      ),
      ConfirmCupertinoCalendarAction(
        label: 'Done',
        isDefaultAction: true,
        onPressed: (dateTime) {},
      ),
    ],
  );
}
```

> [!NOTE]
> Works only when the calendar is in the `CupertinoCalendarType.compact` mode.

### `showCupertinoTimePicker` function.

The `showCupertinoTimePicker` function shows a time picker around your widget.

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

## Functions Usage Example

Call the `showCupertinoCalendarPicker` passing date constrains and widget's `RenderBox` of the widget above/below which you wish to display the calendar.

```dart
@override
Widget build(BuildContext context) {
  return CupertinoApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: CupertinoPageScaffold(
      child: Builder(
        builder: (context) {
          /// Passing exactly this `BuildContext` is mandatory here to 
          /// get the `RenderBox` of the appropriate widget.
          return YourWidget(
            onTap: () => onTap(context),
          );
        },
      ),
    ),
  );
}

/// The `BuildContext` comes from the `Builder` above the widget tree.
Future<void> onTap(BuildContext context) {
  final renderBox = context.findRenderObject() as RenderBox?;
  final nowDate = DateTime.now();

  return showCupertinoCalendarPicker(
    context,
    widgetRenderBox: renderBox,
    minimumDate: nowDate.subtract(const Duration(days: 15)),
    initialDate: nowDate,
    maximumDate: nowDate.add(const Duration(days: 360)),
  );
}
```

## How to get a `RenderBox`?
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
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: CupertinoPageScaffold(
      child: YourWidget(
        key: globalKey,
        onTap: onTap,
      ),
    ),
  );
}

Future<void> onTap(BuildContext context) {
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
