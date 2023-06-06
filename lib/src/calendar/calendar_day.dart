import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';

enum CalendarDayStyle { today, selected, defaultDay }

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    required this.day,
    required this.decoration,
    required this.todayDecoration,
    required this.style,
    super.key,
  });

  final String day;
  final CalendarDayDecoration decoration;
  final CalendarDayDecoration todayDecoration;
  final CalendarDayStyle style;

  Color? get _backgroundColor {
    switch (style) {
      case CalendarDayStyle.today:
        return todayDecoration.backgroundColor;
      case CalendarDayStyle.selected:
        return decoration.backgroundColor;
      case CalendarDayStyle.defaultDay:
        return decoration.backgroundColor;
    }
  }

  BoxShape get _shape {
    switch (style) {
      case CalendarDayStyle.today:
        return todayDecoration.shape;
      case CalendarDayStyle.selected:
        return decoration.shape;
      case CalendarDayStyle.defaultDay:
        return decoration.shape;
    }
  }

  TextStyle get _textStyle {
    switch (style) {
      case CalendarDayStyle.today:
        return todayDecoration.textStyle;
      case CalendarDayStyle.selected:
        return decoration.textStyle;
      case CalendarDayStyle.defaultDay:
        return decoration.textStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: _shape,
        color: _backgroundColor,
      ),
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: _textStyle,
        ),
      ),
    );
  }
}
