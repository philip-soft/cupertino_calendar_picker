import 'package:flutter/cupertino.dart';

sealed class CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDayStyle({
    required this.textStyle,
    required this.backgroundColor,
  });

  final TextStyle textStyle;
  final Color? backgroundColor;
}

class CalendarMonthPickerDisabledDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDisabledDayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerDisabledDayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 20.0,
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.opaqueSeparator,
                darkColor: CupertinoColors.opaqueSeparator.darkColor,
              ),
              context,
            ),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
          ),
      backgroundColor: null,
    );
  }
}

class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDefaultDayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerDefaultDayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: textStyle ??
          const TextStyle(
            fontSize: 20.0,
            color: CupertinoColors.label,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
          ),
      backgroundColor: null,
    );
  }
}

class CalendarMonthPickerSelectedDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerSelectedDayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerSelectedDayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 20.0,
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.38,
          ),
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ??
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ).withOpacity(0.12),
        context,
      ),
    );
  }
}

class CalendarMonthPickerSelectedTodayStyle
    extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerSelectedTodayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerSelectedTodayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedTodayStyle(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 20.0,
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.label.darkColor,
              darkColor: CupertinoColors.label,
            ),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.38,
          ),
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ??
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
        context,
      ),
    );
  }
}

class CalendarMonthPickerTodayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerTodayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerTodayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerTodayStyle(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 20.0,
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.systemRed,
                darkColor: CupertinoColors.systemRed.darkColor,
              ),
              context,
            ),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
          ),
      backgroundColor: null,
    );
  }
}
