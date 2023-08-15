import 'package:flutter/cupertino.dart';

class CalendarWeekdayDecoration {
  const CalendarWeekdayDecoration._({
    required this.textStyle,
  });

  factory CalendarWeekdayDecoration({
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration._(
      textStyle: textStyle ??
          const TextStyle(
            color: CupertinoColors.tertiaryLabel,
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.08,
          ),
    );
  }

  factory CalendarWeekdayDecoration.defaultDecoration(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final CalendarWeekdayDecoration decoration = CalendarWeekdayDecoration();
    return decoration.copyWith(
      textStyle: textStyle ??
          decoration.textStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.tertiaryLabel,
                darkColor: CupertinoColors.tertiaryLabel.darkColor,
              ),
              context,
            ),
          ),
    );
  }

  final TextStyle textStyle;

  CalendarWeekdayDecoration copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarWeekdayDecoration._(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
