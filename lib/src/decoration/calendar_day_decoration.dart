import 'package:flutter/cupertino.dart';

class CalendarDayDecoration {
  final BoxShape shape;
  final TextStyle textStyle;
  final Color? backgroundColor;

  const CalendarDayDecoration._({
    required this.shape,
    required this.textStyle,
    this.backgroundColor,
  });

  factory CalendarDayDecoration({
    BoxShape? shape,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarDayDecoration._(
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

  factory CalendarDayDecoration.withDynamicColor(
    BuildContext context, {
    BoxShape? shape,
    CupertinoDynamicColor? backgroundColor,
    TextStyle? textStyle,
  }) {
    final CalendarDayDecoration decoration = CalendarDayDecoration();
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

  CalendarDayDecoration copyWith({
    BoxShape? shape,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    return CalendarDayDecoration(
      shape: shape ?? this.shape,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
