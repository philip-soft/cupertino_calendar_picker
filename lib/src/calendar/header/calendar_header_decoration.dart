// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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

/// A decoration class for the calendar's header.
class CalendarHeaderDecoration {
  /// Creates a calendar's header decoration class with default values
  /// for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarHeaderDecoration({
    Color? mainColor,
    TextStyle? monthDateStyle,
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
    double monthSwitcherIconSize = calendarMonthSwitcherIconSize,
    double monthPickerIconSize = calendarMonthPickerIconSize,
    bool showMonthPickerIcon = true,
    DateFormat? monthDateFormat,
    CalendarHeaderMode headerMode = CalendarHeaderMode.leadingMonthYear,
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
      monthSwitcherIconSize: monthSwitcherIconSize,
      monthPickerIconSize: monthPickerIconSize,
      showMonthPickerIcon: showMonthPickerIcon,
      monthDateFormat: monthDateFormat,
      headerMode: headerMode,
    );
  }

  const CalendarHeaderDecoration._({
    this.monthDateStyle,
    this.monthDateArrowColor,
    this.forwardButtonColor,
    this.backwardButtonColor,
    this.backwardDisabledButtonColor,
    this.forwardDisabledButtonColor,
    this.monthSwitcherIconSize = calendarMonthSwitcherIconSize,
    this.monthPickerIconSize = calendarMonthPickerIconSize,
    this.showMonthPickerIcon = true,
    this.monthDateFormat,
    this.headerMode = CalendarHeaderMode.leadingMonthYear,
  });

  /// Creates a calendar's header decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarHeaderDecoration.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? monthDateStyle,
    CupertinoDynamicColor? monthDateArrowColor,
    CupertinoDynamicColor? forwardButtonColor,
    CupertinoDynamicColor? backwardButtonColor,
    CupertinoDynamicColor? backwardDisabledButtonColor,
    CupertinoDynamicColor? forwardDisabledButtonColor,
    double monthSwitcherIconSize = calendarMonthSwitcherIconSize,
    double monthPickerIconSize = calendarMonthPickerIconSize,
    bool showMonthPickerIcon = true,
    DateFormat? monthDateFormat,
    CalendarHeaderMode headerMode = CalendarHeaderMode.leadingMonthYear,
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
      monthSwitcherIconSize: monthSwitcherIconSize,
      monthPickerIconSize: monthPickerIconSize,
      showMonthPickerIcon: showMonthPickerIcon,
      monthDateFormat: monthDateFormat,
      headerMode: headerMode,
    );
  }

  /// The [TextStyle] of the calendar's month date at the top left.
  final TextStyle? monthDateStyle;

  /// The [Color] of the calendar's month date arrow
  /// on the right of the month date.
  final Color? monthDateArrowColor;

  /// The [Color] of the calendar's forward arrow at the top right.
  final Color? forwardButtonColor;

  /// The [Color] of the calendar's backward arrow at the top right.
  final Color? backwardButtonColor;

  /// The [Color] of the calendar's disabled backward arrow at the top right.
  final Color? backwardDisabledButtonColor;

  /// The [Color] of the calendar's disabled forward arrow at the top right.
  final Color? forwardDisabledButtonColor;

  /// The [double] size of the calendar's month switcher icons.
  final double monthSwitcherIconSize;

  /// The [double] size of the calendar's month picker icons.
  final double monthPickerIconSize;

  /// Whether to show the calendar's month picker icons.
  final bool showMonthPickerIcon;

  /// The [DateFormat] of the calendar's month date.
  final DateFormat? monthDateFormat;

  /// The [CalendarHeaderMode] of the calendar's header.
  final CalendarHeaderMode headerMode;

  /// Creates a copy of the class with the provided parameters.
  CalendarHeaderDecoration copyWith({
    TextStyle? monthDateStyle,
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
    double monthSwitcherIconSize = calendarMonthSwitcherIconSize,
    double monthPickerIconSize = calendarMonthPickerIconSize,
    bool showMonthPickerIcon = true,
    DateFormat? monthDateFormat,
    CalendarHeaderMode? headerMode,
  }) {
    return CalendarHeaderDecoration(
      monthDateStyle: monthDateStyle ?? this.monthDateStyle,
      monthDateArrowColor: monthDateArrowColor ?? this.monthDateArrowColor,
      forwardButtonColor: forwardButtonColor ?? this.forwardButtonColor,
      backwardButtonColor: backwardButtonColor ?? this.backwardButtonColor,
      backwardDisabledButtonColor:
          backwardDisabledButtonColor ?? this.backwardDisabledButtonColor,
      forwardDisabledButtonColor:
          forwardDisabledButtonColor ?? this.forwardDisabledButtonColor,
      monthSwitcherIconSize: monthSwitcherIconSize,
      monthPickerIconSize: monthPickerIconSize,
      showMonthPickerIcon: showMonthPickerIcon,
      monthDateFormat: monthDateFormat ?? this.monthDateFormat,
      headerMode: headerMode ?? this.headerMode,
    );
  }
}
