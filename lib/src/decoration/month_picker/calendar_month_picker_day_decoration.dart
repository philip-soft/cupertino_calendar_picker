import 'package:flutter/cupertino.dart';

class CalendarMonthPickerDayDecoration {
  final BoxShape shape;
  final TextStyle textStyle;
  final Color? backgroundColor;

  const CalendarMonthPickerDayDecoration._({
    required this.shape,
    required this.textStyle,
    this.backgroundColor,
  });

  factory CalendarMonthPickerDayDecoration({
    BoxShape? shape,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDayDecoration._(
      shape: shape ?? BoxShape.circle,
      backgroundColor: backgroundColor,
      textStyle: textStyle ??
          const TextStyle(
            fontSize: 20.0,
            color: CupertinoColors.label,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
          ),
    );
  }

  factory CalendarMonthPickerDayDecoration.withDynamicColor(
    BuildContext context, {
    BoxShape? shape,
    CupertinoDynamicColor? backgroundColor,
    TextStyle? textStyle,
  }) {
    final CalendarMonthPickerDayDecoration decoration =
        CalendarMonthPickerDayDecoration();
    return decoration.copyWith(
      shape: shape,
      textStyle: textStyle ??
          const TextStyle(
            fontSize: 20.0,
            color: CupertinoColors.label,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
          ),
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ??
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemBlue.darkColor,
            ),
        context,
      ),
    );
  }

  CalendarMonthPickerDayDecoration copyWith({
    BoxShape? shape,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    return CalendarMonthPickerDayDecoration(
      shape: shape ?? this.shape,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
