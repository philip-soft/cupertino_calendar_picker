import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({required this.weekdayDecoration, super.key});

  final CalendarWeekdayDecoration weekdayDecoration;

  Iterable<Widget> _weekdays(BuildContext context) sync* {
    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      MaterialLocalizations.of(context),
    );
    final DateFormat weekdayFormat = DateFormat.E();
    final DateTime firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    yield* List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final String weekday = weekdayFormat.format(
        firstDayOfWeekDate.add(Duration(days: index)),
      );
      return CalendarWeekday(
        weekday: weekday.toUpperCase(),
        decoration: weekdayDecoration,
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
        children: _weekdays(context).toList(),
      ),
    );
  }
}
