import 'package:cupertino_calendar/src/src.dart';
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

  factory CalendarMonthPickerDisabledDayStyle.withDynamicColor(
    BuildContext context, {
    CupertinoDynamicColor? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerDisabledDayStyle.copyWith(
            color: calendarMonthPickerDisabledDayColor.resolveFrom(context),
          ),
      backgroundColor: backgroundColor?.resolveFrom(context),
    );
  }
}

class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerDefaultDayStyle({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDefaultDayStyle,
      backgroundColor: backgroundColor,
    );
  }

  const CalendarMonthPickerDefaultDayStyle._({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerDefaultDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundColor,
  }) {
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerDefaultDayStyle.copyWith(
            color: calendarMonthPickerDefaultDayColor.resolveFrom(context),
          ),
      backgroundColor: backgroundColor?.resolveFrom(context),
    );
  }
}

class CalendarMonthPickerSelectedDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerSelectedDayStyle({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerSelectedDayStyle,
      backgroundColor: backgroundColor ?? calendarMonthPickerSelectedDayColor,
    );
  }

  const CalendarMonthPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      textStyle: textStyle ?? calendarMonthPickerSelectedDayStyle,
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ?? calendarMonthPickerSelectedDayBackgroundColor,
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentAndSelectedDayStyle
    extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentAndSelectedDayStyle({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundColor:
          backgroundColor ?? calendarMonthPickerCurrentAndSelectedDayColor,
    );
  }

  const CalendarMonthPickerCurrentAndSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerCurrentAndSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundColor,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle(
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ?? calendarMonthPickerCurrentAndSelectedDayColor,
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentDayStyle({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentDayStyle,
      backgroundColor: backgroundColor,
    );
  }

  const CalendarMonthPickerCurrentDayStyle._({
    required super.textStyle,
    required super.backgroundColor,
  });

  factory CalendarMonthPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundColor,
  }) {
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerCurrentDayStyle.copyWith(
            color: calendarMonthPickerCurrentDayColor.resolveFrom(context),
          ),
      backgroundColor: backgroundColor?.resolveFrom(context),
    );
  }
}
