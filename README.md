The package provides a sleek and stylish cupertino calendar designed to mimic the aesthetics of iOS. With smooth animations and intuitive user interactions, it seamlessly integrates into your Flutter app to deliver a delightful user experience.

<p>
   <img src="https://github.com/philip-soft/cupertino_calendar/blob/master/doc/calendar_months_switches.gif?raw=true"
    alt="Calendar months switches" width="320"/>
  &nbsp; &nbsp;
   <img src="https://github.com/philip-soft/cupertino_calendar/blob/master/doc/calendar_year_picker.gif?raw=true"
    alt="Calendar year picker" width="320"/>
</p>

## Features

* **iOS Style**: The cupertino calendar follows the design principles of iOS, ensuring consistency and familiarity for iOS users.
* **Smooth Animations**: Enjoy fluid animations that enhance the overall look and feel of the calendar, providing a polished user experience.
* **Customizable**: Easily customize the appearance of the calendar to match your app's theme and branding.
* **Intuitive Interactions**: Users can effortlessly navigate through years, months and interact with the calendar thanks to its intuitive design.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:
```yaml
dependencies:
  cupertino_calendar: ^1.0.0
```

Import it:

```dart
import 'package:cupertino_calendar/cupertino_calendar.dart';
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

## Usage Example

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
          return _YourWidget(
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
There are 3 simple ways of how you can get the widget's render box to pass it to the `showCupertinoCalendarPicker` function.

You can choose **any** of these.

1. Wrap your widget with `Builder` widget.

```dart
Builder(
  builder: (context) {
    return _YourWidget(
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
      child: _YourWidget(
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
class _YourWidget extends StatelessWidget {
  const _YourWidget({
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
