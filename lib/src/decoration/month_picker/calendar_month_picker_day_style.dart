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
                color: CupertinoColors.tertiaryLabel,
                darkColor: CupertinoColors.tertiaryLabel.darkColor,
              ),
              context,
            ),
            fontWeight: FontWeight.w400,
            letterSpacing: -0.4,
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
          TextStyle(
            fontSize: 20.0,
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.label,
                darkColor: CupertinoColors.label.darkColor,
              ),
              context,
            ),
            fontWeight: FontWeight.w400,
            letterSpacing: -0.4,
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
            fontSize: 24.0,
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
            fontWeight: FontWeight.w500,
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

class CalendarMonthPickerCurrentAndSelectedStyle
    extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerCurrentAndSelectedStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerCurrentAndSelectedStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentAndSelectedStyle(
      textStyle: textStyle ??
          TextStyle(
            fontSize: 24.0,
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.label.darkColor,
                darkColor: CupertinoColors.label.darkColor,
              ),
              context,
            ),
            fontWeight: FontWeight.w500,
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

class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerCurrentDayStyle({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerCurrentDayStyle.defaultDecoration(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentDayStyle(
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
            letterSpacing: -0.4,
          ),
      backgroundColor: null,
    );
  }
}
