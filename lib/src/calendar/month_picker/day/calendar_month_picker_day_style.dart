import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarMonthPickerDisabledDayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarMonthPickerDisabledDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDisabledDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerDefaultDayColor =
    CupertinoColors.label;
const TextStyle calendarMonthPickerDefaultDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDefaultDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerSelectedDayColor =
    CupertinoColors.systemRed;

final Color calendarMonthPickerSelectedDayBackgroundCircleColor =
    CupertinoColors.systemRed.withOpacity(0.12);

const TextStyle calendarMonthPickerSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  color: calendarMonthPickerSelectedDayColor,
  fontWeight: FontWeight.w500,
);
const CupertinoDynamicColor calendarMonthPickerCurrentAndSelectedDayColor =
    CupertinoColors.systemRed;
final TextStyle calendarMonthPickerCurrentAndSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);
const CupertinoDynamicColor calendarMonthPickerCurrentDayColor =
    CupertinoColors.systemRed;

const TextStyle calendarMonthPickerCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerCurrentDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

sealed class CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDayStyle({
    required this.textStyle,
    required this.backgroundCircleColor,
  });

  final TextStyle textStyle;
  final Color? backgroundCircleColor;
}

class CalendarMonthPickerDisabledDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDisabledDayStyle({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerDisabledDayStyle.withDynamicColor(
    BuildContext context, {
    CupertinoDynamicColor? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerDisabledDayStyle.copyWith(
            color: calendarMonthPickerDisabledDayColor.resolveFrom(context),
          ),
      backgroundCircleColor: backgroundCircleColor?.resolveFrom(context),
    );
  }
}

class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerDefaultDayStyle({
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDefaultDayStyle,
      backgroundCircleColor: backgroundCircleColor,
    );
  }

  const CalendarMonthPickerDefaultDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerDefaultDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerDefaultDayStyle.copyWith(
            color: calendarMonthPickerDefaultDayColor.resolveFrom(context),
          ),
      backgroundCircleColor: backgroundCircleColor?.resolveFrom(context),
    );
  }
}

class CalendarMonthPickerSelectedDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerSelectedDayStyle({
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerSelectedDayStyle,
      backgroundCircleColor:
          backgroundCircleColor ?? calendarMonthPickerSelectedDayColor,
    );
  }

  const CalendarMonthPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(
            color: calendarMonthPickerSelectedDayColor.resolveFrom(context),
          ),
      backgroundCircleColor: CupertinoDynamicColor.resolve(
        backgroundCircleColor ??
            calendarMonthPickerSelectedDayBackgroundCircleColor,
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentAndSelectedDayStyle
    extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentAndSelectedDayStyle({
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundCircleColor: backgroundCircleColor ??
          calendarMonthPickerCurrentAndSelectedDayColor,
    );
  }

  const CalendarMonthPickerCurrentAndSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerCurrentAndSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle(
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundCircleColor: CupertinoDynamicColor.resolve(
        backgroundCircleColor ?? calendarMonthPickerCurrentAndSelectedDayColor,
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentDayStyle({
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentDayStyle,
      backgroundCircleColor: backgroundCircleColor,
    );
  }

  const CalendarMonthPickerCurrentDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerCurrentDayStyle.copyWith(
            color: calendarMonthPickerCurrentDayColor.resolveFrom(context),
          ),
      backgroundCircleColor: backgroundCircleColor?.resolveFrom(context),
    );
  }
}
