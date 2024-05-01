import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/cupertino.dart';

class CalendarWeekday extends StatelessWidget {
  const CalendarWeekday({
    required this.weekday,
    this.decoration,
    super.key,
  });

  final String weekday;
  final CalendarWeekdayDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      child: Text(
        weekday,
        textAlign: TextAlign.center,
        style: decoration?.textStyle,
      ),
    );
  }
}
