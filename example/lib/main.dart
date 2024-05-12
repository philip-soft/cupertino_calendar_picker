import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
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
  DateTime _selectedDate = DateTime.now();

  /// The context comes from the `Builder` above the widget tree.
  Future<void> onTap(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDate: nowDate.subtract(const Duration(days: 15)),
      initialDate: _selectedDate,
      maximumDate: nowDate.add(const Duration(days: 360)),
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
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CupertinoPageScaffold(
        child: Align(
          alignment: const Alignment(0.0, 0.2),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                /// Passing exactly this `BuildContext` is mandatory to get
                /// the `RenderBox` of the appropriate widget.
                onTap: () => onTap(context),
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
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(6.0),
      ),
      alignment: Alignment.center,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Text(
        '$monthString $dayString, $yearString',
        style: TextStyle(
          color: CupertinoColors.systemRed.resolveFrom(context),
          fontSize: 17.0,
        ),
      ),
    );
  }
}
