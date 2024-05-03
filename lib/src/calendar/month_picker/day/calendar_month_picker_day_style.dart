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

final TextStyle calendarMonthPickerSelectedCurrentDayStyle = TextStyle(
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

abstract class CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDayStyle({
    required this.textStyle,
  });

  final TextStyle textStyle;
}

class CalendarMonthPickerBackgroundCircledDayStyle
    extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerBackgroundCircledDayStyle({
    required super.textStyle,
    required this.backgroundCircleColor,
  });

  final Color? backgroundCircleColor;
}

class CalendarMonthPickerDisabledDayStyle extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDisabledDayStyle({
    required super.textStyle,
  });

  factory CalendarMonthPickerDisabledDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerDisabledDayStyle;
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? calendarMonthPickerDisabledDayColor,
          context,
        ),
      ),
    );
  }
}

class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerDefaultDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDefaultDayStyle,
    );
  }

  const CalendarMonthPickerDefaultDayStyle._({
    required super.textStyle,
  });

  factory CalendarMonthPickerDefaultDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerDefaultDayStyle;
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
    );
  }
}

class CalendarMonthPickerSelectedDayStyle
    extends CalendarMonthPickerBackgroundCircledDayStyle {
  factory CalendarMonthPickerSelectedDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(color: mainColor),
      backgroundCircleColor:
          backgroundCircleColor ?? mainColor?.withOpacity(0.12),
    );
  }

  const CalendarMonthPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      mainColor: mainColor,
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(
            color: CupertinoDynamicColor.maybeResolve(mainColor, context),
          ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor?.withOpacity(0.12),
        context,
      ),
    );
  }
}

class CalendarMonthPickerSelectedCurrentDayStyle
    extends CalendarMonthPickerBackgroundCircledDayStyle {
  factory CalendarMonthPickerSelectedCurrentDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerSelectedCurrentDayStyle,
      backgroundCircleColor: backgroundCircleColor ?? mainColor,
    );
  }

  const CalendarMonthPickerSelectedCurrentDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  factory CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    final TextStyle style =
        textStyle ?? calendarMonthPickerSelectedCurrentDayStyle;
    return CalendarMonthPickerSelectedCurrentDayStyle(
      mainColor: mainColor,
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor,
        context,
      ),
    );
  }
}

class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  factory CalendarMonthPickerCurrentDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentDayStyle,
    );
  }

  const CalendarMonthPickerCurrentDayStyle._({
    required super.textStyle,
  });

  factory CalendarMonthPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerCurrentDayStyle;
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(
          style.color ?? mainColor,
          context,
        ),
      ),
    );
  }
}
