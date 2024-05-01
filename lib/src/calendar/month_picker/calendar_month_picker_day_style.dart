import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/cupertino.dart';

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
