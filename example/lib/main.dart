import 'package:cupertino_calendar/cupertino_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _onTap(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDate: nowDate.subtract(const Duration(days: 15)),
      initialDate: _selectedDate,
      currentDate: nowDate,
      maximumDate: DateTime(2030, 5, 25),
      onDateChanged: _onDateChanged,
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CupertinoPageScaffold(
        child: Align(
          // TODO: FIX THIS CASE AND CASE WHEN WIDGET IS IN THE CENTER
          alignment: const Alignment(-0.8, 0.2),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => _onTap(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ExampleWidget(selectedDate: _selectedDate),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ExampleWidget extends StatelessWidget {
  const _ExampleWidget({
    super.key,
    required this.selectedDate,
  });

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final localization = CupertinoLocalizations.of(context);
    final day = selectedDate.day;
    final month = selectedDate.month;
    final year = selectedDate.year;
    final fullMonthString = localization.datePickerMonth(month);
    final dayString = localization.datePickerDayOfMonth(day);
    final monthString = fullMonthString.substring(0, 3);
    final yearString = localization.datePickerYear(year);

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.tertiaryLabel
            .resolveFrom(context)
            .withOpacity(0.12),
        borderRadius: BorderRadius.circular(6.0),
      ),
      alignment: Alignment.center,
      height: 34,
      width: 99,
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Text(
        '$monthString $dayString, $yearString',
        style: TextStyle(
          color: CupertinoColors.systemBlue.resolveFrom(context),
          fontSize: 17.0,
        ),
      ),
    );
  }
}
