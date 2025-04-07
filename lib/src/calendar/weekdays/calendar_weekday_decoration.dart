// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarWeekdayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarWeekdayStyle = TextStyle(
  color: calendarWeekdayColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

/// A decoration class for the calendar's weekday.
class CalendarWeekdayDecoration {
  /// Creates a calendar's weekday decoration class with default values
  /// for non-provided parameters.
  factory CalendarWeekdayDecoration({
    TextStyle? textStyle,
    bool useUppercase = false,
  }) {
    return CalendarWeekdayDecoration._(
      textStyle: textStyle ?? calendarWeekdayStyle,
      useUppercase: useUppercase,
    );
  }

  const CalendarWeekdayDecoration._({
    required this.textStyle,
    this.useUppercase = false,
  });

  /// Creates a calendar's weekday decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarWeekdayDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarWeekdayStyle;
    return CalendarWeekdayDecoration(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
    );
  }

  /// The [TextStyle] of the calendar's weekday.
  final TextStyle textStyle;

  /// Whether to use uppercase for the weekday.
  final bool useUppercase;

  /// Creates a copy of the class with the provided parameters.
  CalendarWeekdayDecoration copyWith({
    TextStyle? textStyle,
    bool? useUppercase,
  }) {
    return CalendarWeekdayDecoration(
      textStyle: textStyle ?? this.textStyle,
      useUppercase: useUppercase ?? this.useUppercase,
    );
  }
}
