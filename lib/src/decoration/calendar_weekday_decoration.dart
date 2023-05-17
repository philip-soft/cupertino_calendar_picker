import 'package:flutter/cupertino.dart';

class CalendarWeekdaysDecoration {
  const CalendarWeekdaysDecoration._({
    this.textStyle,
  });

  factory CalendarWeekdaysDecoration.defaultDecoration({TextStyle? textStyle}) {
    return CalendarWeekdaysDecoration._(
      textStyle: textStyle ??
          const TextStyle(
            color: CupertinoColors.tertiaryLabel,
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.08,
          ),
    );
  }

  factory CalendarWeekdaysDecoration.defaultWithDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final defaultDecoration = CalendarWeekdaysDecoration.defaultDecoration();
    return defaultDecoration.copyWith(
      textStyle: textStyle ??
          defaultDecoration.textStyle?.copyWith(
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

  final TextStyle? textStyle;

  CalendarWeekdaysDecoration copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarWeekdaysDecoration._(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
