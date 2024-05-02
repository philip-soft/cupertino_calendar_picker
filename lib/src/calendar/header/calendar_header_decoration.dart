import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarMontDateColor = CupertinoColors.label;
const TextStyle calendarMonthDateStyle = TextStyle(
  color: calendarMontDateColor,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  letterSpacing: -0.5,
);

const CupertinoDynamicColor calendarForwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;
const CupertinoDynamicColor calendarBackwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;

class CalendarHeaderDecoration {
  factory CalendarHeaderDecoration({
    required Color mainColor,
    TextStyle? monthDateStyle,
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
  }) {
    return CalendarHeaderDecoration._(
      monthDateStyle: monthDateStyle ?? calendarMonthDateStyle,
      monthDateArrowColor: monthDateArrowColor ?? mainColor,
      forwardButtonColor: forwardButtonColor ?? mainColor,
      backwardButtonColor: backwardButtonColor ?? mainColor,
      backwardDisabledButtonColor:
          backwardDisabledButtonColor ?? calendarForwardDisabledButtonColor,
      forwardDisabledButtonColor:
          forwardDisabledButtonColor ?? calendarForwardDisabledButtonColor,
    );
  }

  const CalendarHeaderDecoration._({
    this.monthDateStyle,
    this.monthDateArrowColor,
    this.forwardButtonColor,
    this.backwardButtonColor,
    this.backwardDisabledButtonColor,
    this.forwardDisabledButtonColor,
  });

  factory CalendarHeaderDecoration.withDynamicColor(
    BuildContext context, {
    required Color mainColor,
    TextStyle? monthDateStyle,
    CupertinoDynamicColor? monthDateArrowColor,
    CupertinoDynamicColor? forwardButtonColor,
    CupertinoDynamicColor? backwardButtonColor,
    CupertinoDynamicColor? backwardDisabledButtonColor,
    CupertinoDynamicColor? forwardDisabledButtonColor,
  }) {
    return CalendarHeaderDecoration(
      mainColor: mainColor,
      monthDateStyle: monthDateStyle ??
          calendarMonthDateStyle.copyWith(
            color: calendarMontDateColor.resolveFrom(context),
          ),
      monthDateArrowColor: monthDateArrowColor ?? mainColor,
      forwardButtonColor: forwardButtonColor ?? mainColor,
      backwardButtonColor: backwardButtonColor ?? mainColor,
      forwardDisabledButtonColor:
          (forwardDisabledButtonColor ?? calendarForwardDisabledButtonColor)
              .resolveFrom(context),
      backwardDisabledButtonColor:
          (backwardDisabledButtonColor ?? calendarBackwardDisabledButtonColor)
              .resolveFrom(context),
    );
  }

  final TextStyle? monthDateStyle;
  final Color? monthDateArrowColor;
  final Color? forwardButtonColor;
  final Color? backwardButtonColor;
  final Color? backwardDisabledButtonColor;
  final Color? forwardDisabledButtonColor;

  CalendarHeaderDecoration copyWith({
    TextStyle? monthDateStyle,
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
  }) {
    return CalendarHeaderDecoration._(
      monthDateStyle: monthDateStyle ?? this.monthDateStyle,
      monthDateArrowColor: monthDateArrowColor ?? this.monthDateArrowColor,
      forwardButtonColor: forwardButtonColor ?? this.forwardButtonColor,
      backwardButtonColor: backwardButtonColor ?? this.backwardButtonColor,
      backwardDisabledButtonColor:
          backwardDisabledButtonColor ?? this.backwardDisabledButtonColor,
      forwardDisabledButtonColor:
          forwardDisabledButtonColor ?? this.forwardDisabledButtonColor,
    );
  }
}
