import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarWeekdayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarWeekdayStyle = TextStyle(
  color: calendarWeekdayColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

class CalendarWeekdayDecoration {
  factory CalendarWeekdayDecoration({
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration._(
      textStyle: textStyle ?? calendarWeekdayStyle,
    );
  }

  const CalendarWeekdayDecoration._({
    required this.textStyle,
  });

  factory CalendarWeekdayDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration(
      textStyle: textStyle ??
          calendarWeekdayStyle.copyWith(
            color: calendarWeekdayColor.resolveFrom(context),
          ),
    );
  }

  final TextStyle textStyle;

  CalendarWeekdayDecoration copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
