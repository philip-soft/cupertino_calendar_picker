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

const TextStyle calendarMonthPickerSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
);

final TextStyle calendarMonthPickerCurrentAndSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);

const TextStyle calendarMonthPickerCurrentDayStyle = TextStyle(
  fontSize: 20.0,
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
    required Color mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(color: mainColor),
      backgroundCircleColor: backgroundCircleColor ?? mainColor,
    );
  }

  const CalendarMonthPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    required Color mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      mainColor: mainColor,
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(
            color: CupertinoDynamicColor.resolve(mainColor, context),
          ),
      backgroundCircleColor: CupertinoDynamicColor.resolve(
        backgroundCircleColor ?? mainColor.withOpacity(0.12),
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentAndSelectedDayStyle
    extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentAndSelectedDayStyle({
    required Color mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundCircleColor: backgroundCircleColor ?? mainColor,
    );
  }

  const CalendarMonthPickerCurrentAndSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerCurrentAndSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    required Color mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerCurrentAndSelectedDayStyle(
      mainColor: mainColor,
      textStyle: textStyle ?? calendarMonthPickerCurrentAndSelectedDayStyle,
      backgroundCircleColor: CupertinoDynamicColor.resolve(
        backgroundCircleColor ?? mainColor,
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
    required Color mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: textStyle ??
          calendarMonthPickerCurrentDayStyle.copyWith(
            color: CupertinoDynamicColor.resolve(mainColor, context),
          ),
      backgroundCircleColor: backgroundCircleColor?.resolveFrom(context),
    );
  }
}
