import 'package:flutter/cupertino.dart';

class CalendarWeekdayDecoration {
  const CalendarWeekdayDecoration({
    required this.textStyle,
  });

  factory CalendarWeekdayDecoration.defaultDecoration(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration(
      textStyle: textStyle ??
          TextStyle(
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.tertiaryLabel,
                darkColor: CupertinoColors.tertiaryLabel.darkColor,
              ),
              context,
            ),
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
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
