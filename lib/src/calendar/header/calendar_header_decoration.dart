// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

const CupertinoDynamicColor calendarMonthDateColor = CupertinoColors.label;
const TextStyle calendarMonthDateStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  color: calendarMonthDateColor,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  letterSpacing: -0.5,
);

const CupertinoDynamicColor calendarForwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;
const CupertinoDynamicColor calendarBackwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;

/// A decoration class for the calendar's header.
@immutable
class CalendarHeaderDecoration {
  /// Creates a calendar's header decoration class with default values
  /// for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  ///
  /// [CupertinoDynamicColor]s are resolved against the ambient brightness
  /// when the header is built.
  factory CalendarHeaderDecoration({
    Color? mainColor,
    TextStyle? monthDateStyle,
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
  }) {
    final Color color = mainColor ?? calendarDefaultMainColor;
    return CalendarHeaderDecoration._(
      monthDateStyle: monthDateStyle ?? calendarMonthDateStyle,
      monthDateArrowColor: monthDateArrowColor ?? color,
      forwardButtonColor: forwardButtonColor ?? color,
      backwardButtonColor: backwardButtonColor ?? color,
      backwardDisabledButtonColor:
          backwardDisabledButtonColor ?? calendarBackwardDisabledButtonColor,
      forwardDisabledButtonColor:
          forwardDisabledButtonColor ?? calendarForwardDisabledButtonColor,
    );
  }

  const CalendarHeaderDecoration._({
    required this.monthDateStyle,
    required this.monthDateArrowColor,
    required this.forwardButtonColor,
    required this.backwardButtonColor,
    required this.backwardDisabledButtonColor,
    required this.forwardDisabledButtonColor,
  });

  /// Creates a calendar's header decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
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
    final Color color = mainColor ?? calendarDefaultMainColor;
    final TextStyle style = monthDateStyle ?? calendarMonthDateStyle;
    return CalendarHeaderDecoration(
      monthDateStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? calendarMonthDateColor,
          context,
        ),
      ),
      monthDateArrowColor: CupertinoDynamicColor.resolve(
        monthDateArrowColor ?? color,
        context,
      ),
      forwardButtonColor: CupertinoDynamicColor.resolve(
        forwardButtonColor ?? color,
        context,
      ),
      backwardButtonColor: CupertinoDynamicColor.resolve(
        backwardButtonColor ?? color,
        context,
      ),
      forwardDisabledButtonColor: CupertinoDynamicColor.resolve(
        forwardDisabledButtonColor ?? calendarForwardDisabledButtonColor,
        context,
      ),
      backwardDisabledButtonColor: CupertinoDynamicColor.resolve(
        backwardDisabledButtonColor ?? calendarBackwardDisabledButtonColor,
        context,
      ),
    );
  }

  /// The [TextStyle] of the calendar's month date at the top left.
  final TextStyle monthDateStyle;

  /// The [Color] of the calendar's month date arrow
  /// on the right of the month date.
  final Color monthDateArrowColor;

  /// The [Color] of the calendar's forward arrow at the top right.
  final Color forwardButtonColor;

  /// The [Color] of the calendar's backward arrow at the top right.
  final Color backwardButtonColor;

  /// The [Color] of the calendar's disabled backward arrow at the top right.
  final Color backwardDisabledButtonColor;

  /// The [Color] of the calendar's disabled forward arrow at the top right.
  final Color forwardDisabledButtonColor;

  /// Creates a copy of the class with the provided parameters.
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarHeaderDecoration &&
        other.monthDateStyle == monthDateStyle &&
        other.monthDateArrowColor == monthDateArrowColor &&
        other.forwardButtonColor == forwardButtonColor &&
        other.backwardButtonColor == backwardButtonColor &&
        other.backwardDisabledButtonColor == backwardDisabledButtonColor &&
        other.forwardDisabledButtonColor == forwardDisabledButtonColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      monthDateStyle,
      monthDateArrowColor,
      forwardButtonColor,
      backwardButtonColor,
      backwardDisabledButtonColor,
      forwardDisabledButtonColor,
    );
  }
}
