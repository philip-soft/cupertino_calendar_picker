import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late DateTime _selectedDate;
  late DateTime _now;
  late DateTime _minimumDateTime;
  late DateTime _maximumDateTime;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _selectedDate = _now;
    _minimumDateTime = _now.subtract(const Duration(days: 15));
    _maximumDateTime = _now.add(const Duration(days: 365));
  }

  /// The context comes from the `Builder` above the widget tree.
  Future<DateTime?> onTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: _minimumDateTime,
      maximumDateTime: _maximumDateTime,
      initialDateTime: _selectedDate,
      timeLabel: 'Ends',
      onDateSelected: _onDateChanged,
    );
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Cupertino Calendar Example',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CupertinoPageScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            CupertinoCalendar(
              minimumDateTime: _minimumDateTime,
              maximumDateTime: _maximumDateTime,
              timeLabel: 'Ends',
              type: CupertinoCalendarType.inline,
              mode: CupertinoCalendarMode.dateTime,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoCalendarPickerButton(
                  minimumDateTime: _minimumDateTime,
                  maximumDateTime: _maximumDateTime,
                  initialDateTime: _selectedDate,
                  mode: CupertinoCalendarMode.dateTime,
                  timeLabel: 'Ends',
                  onDateSelected: _onDateChanged,
                ),
                const SizedBox(width: 5),
                const CupertinoTimePickerButton(
                  initialTime: TimeOfDay(hour: 16, minute: 30),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Builder(
              builder: (context) {
                return GestureDetector(
                  /// Passing exactly this `BuildContext` is mandatory to get
                  /// the `RenderBox` of the appropriate widget.
                  onTap: () => onTap(context),
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill
                          .resolveFrom(context),
                    ),
                    alignment: Alignment.center,
                    child: const Text('My widget'),
                  ),
                );
              },
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
