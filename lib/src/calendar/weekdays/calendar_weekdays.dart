import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({required this.decoration, super.key});

  final CalendarWeekdayDecoration decoration;

  List<Widget> _weekdays(BuildContext context) {
    assert(debugCheckHasCupertinoLocalizations(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      MaterialLocalizations.of(context),
    );
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final DateTime firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    return List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final DateTime date = firstDayOfWeekDate.addDays(index);
      final String mediumDateString = localization.datePickerMediumDate(date);
      final String weekday = mediumDateString.substring(0, 3);
      return CalendarWeekday(
        weekday: weekday.toUpperCase(),
        decoration: decoration,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: calendarWeekdaysHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: calendarWeekdaysHorizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weekdays(context),
      ),
    );
  }
}
