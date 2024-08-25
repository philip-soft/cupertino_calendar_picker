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
  late DateTime _selectedDateTime;
  late TimeOfDay _selectedTime;
  late DateTime _now;
  late DateTime _minimumDateTime;
  late DateTime _maximumDateTime;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _selectedDateTime = _now;
    _selectedTime = TimeOfDay.fromDateTime(_now);
    _minimumDateTime = _now.subtract(const Duration(days: 40));
    _maximumDateTime = _now.add(const Duration(days: 365));
  }

  /// The context comes from the `Builder` above the widget tree.
  Future<DateTime?> onCalendarWidgetTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: _minimumDateTime,
      initialDateTime: _selectedDateTime,
      maximumDateTime: _maximumDateTime,
      mode: CupertinoCalendarMode.dateTime,
      timeLabel: 'Ends',
      onDateTimeChanged: _onDateTimeChanged,
    );
  }

  /// The context comes from the `Builder` above the widget tree.
  Future<TimeOfDay?> onTimeWidgetTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    return showCupertinoTimePicker(
      context,
      widgetRenderBox: renderBox,
      initialTime: _selectedTime,
      onTimeChanged: _onTimeChanged,
    );
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _onDateTimeChanged(DateTime newDate) {
    setState(() {
      _selectedDateTime = newDate;
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
            const Spacer(flex: 3),
            SizedBox(
              width: 350,
              child: CupertinoCalendar(
                minimumDateTime: _minimumDateTime,
                maximumDateTime: _maximumDateTime,
                initialDateTime: _selectedDateTime,
                timeLabel: 'Ends',
                mode: CupertinoCalendarMode.dateTime,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoCalendarPickerButton(
                  minimumDateTime: _minimumDateTime,
                  maximumDateTime: _maximumDateTime,
                  initialDateTime: _selectedDateTime,
                  mode: CupertinoCalendarMode.dateTime,
                  timeLabel: 'Ends',
                  onDateTimeChanged: _onDateTimeChanged,
                ),
                const SizedBox(width: 5),
                CupertinoTimePickerButton(
                  initialTime: const TimeOfDay(hour: 9, minute: 41),
                  onTimeChanged: _onTimeChanged,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MyWidget(
                  /// Passing exactly this `BuildContext` is mandatory to get
                  /// the `RenderBox` of the appropriate widget.
                  onTap: (context) => onCalendarWidgetTap(context),
                  title: 'My calendar widget',
                ),
                const SizedBox(width: 10),
                _MyWidget(
                  /// Passing exactly this `BuildContext` is mandatory to get
                  /// the `RenderBox` of the appropriate widget.
                  onTap: (context) => onTimeWidgetTap(context),
                  title: 'My time widget',
                ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _MyWidget extends StatelessWidget {
  const _MyWidget({
    required this.title,
    required this.onTap,
  });

  final String title;
  final void Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// Passing exactly this `BuildContext` is mandatory to get
      /// the `RenderBox` of the appropriate widget.
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
