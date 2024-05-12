import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CalendarPickerButton extends StatefulWidget {
  const CalendarPickerButton({
    required this.dateTime,
    this.activeTextColor = CupertinoColors.systemRed,
    super.key,
  });

  final DateTime dateTime;
  final Color activeTextColor;

  @override
  State<CalendarPickerButton> createState() => _CalendarPickerButtonState();
}

class _CalendarPickerButtonState extends State<CalendarPickerButton> {
  DateTime? _selectedDate;
  bool _isCalendarOpened = false;

  Future<void> onTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime nowDate = DateTime.now();

    _isCalendarOpened = true;
    await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDate: nowDate.subtract(const Duration(days: 15)),
      initialDate: _selectedDate,
      maximumDate: nowDate.add(const Duration(days: 360)),
      onDateChanged: _onDateChanged,
    );
    _isCalendarOpened = false;
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final int day = widget.dateTime.day;
    final int month = widget.dateTime.month;
    final int year = widget.dateTime.year;
    final String fullMonthString = localization.datePickerMonth(month);
    final String dayString = localization.datePickerDayOfMonth(day);
    final String monthString = fullMonthString.substring(0, 3);
    final String yearString = localization.datePickerYear(year);

    return GestureDetector(
      onTap: () => onTap(context),
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(6.0),
        ),
        alignment: Alignment.center,
        height: 34.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 11.0,
        ),
        child: Text(
          '$monthString $dayString, $yearString',
          style: TextStyle(
            color: CupertinoDynamicColor.maybeResolve(
              _isCalendarOpened ? widget.activeTextColor : null,
              context,
            ),
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}
