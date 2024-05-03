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
    Color? mainColor,
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
    Color? mainColor,
    TextStyle? monthDateStyle,
    CupertinoDynamicColor? monthDateArrowColor,
    CupertinoDynamicColor? forwardButtonColor,
    CupertinoDynamicColor? backwardButtonColor,
    CupertinoDynamicColor? backwardDisabledButtonColor,
    CupertinoDynamicColor? forwardDisabledButtonColor,
  }) {
    final TextStyle style = monthDateStyle ?? calendarMonthDateStyle;
    return CalendarHeaderDecoration(
      mainColor: mainColor,
      monthDateStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? calendarMontDateColor,
          context,
        ),
      ),
      monthDateArrowColor: CupertinoDynamicColor.maybeResolve(
        monthDateArrowColor ?? mainColor,
        context,
      ),
      forwardButtonColor: CupertinoDynamicColor.maybeResolve(
        forwardButtonColor ?? mainColor,
        context,
      ),
      backwardButtonColor: CupertinoDynamicColor.maybeResolve(
        backwardButtonColor ?? mainColor,
        context,
      ),
      forwardDisabledButtonColor: CupertinoDynamicColor.maybeResolve(
        forwardDisabledButtonColor ?? calendarForwardDisabledButtonColor,
        context,
      ),
      backwardDisabledButtonColor: CupertinoDynamicColor.maybeResolve(
        backwardDisabledButtonColor ?? calendarBackwardDisabledButtonColor,
        context,
      ),
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
