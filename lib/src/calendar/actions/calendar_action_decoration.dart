// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarActionPressedColor =
    CupertinoColors.tertiarySystemFill;
const CupertinoDynamicColor calendarActionTextColor = CupertinoColors.label;
const TextStyle calendarActionTextStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  color: calendarActionTextColor,
);

/// A decoration class for the calendar's action.
class CalendarActionDecoration {
  /// Creates a calendar's action decoration class with default values
  /// for non-provided parameters.
  factory CalendarActionDecoration({
    TextStyle? style,
    Color? pressedColor,
  }) {
    return CalendarActionDecoration._(
      style: style ?? calendarActionTextStyle,
      pressedColor: pressedColor ?? calendarActionPressedColor,
    );
  }

  /// Creates a calendar's action decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarActionDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? style,
    Color? pressedColor,
  }) {
    final TextStyle textStyle = style ?? calendarActionTextStyle;

    return CalendarActionDecoration(
      style: textStyle.copyWith(
        color: CupertinoDynamicColor.resolve(
          textStyle.color ?? calendarActionTextColor,
          context,
        ),
      ),
      pressedColor: pressedColor ??
          CupertinoDynamicColor.resolve(
            calendarActionPressedColor,
            context,
          ),
    );
  }

  const CalendarActionDecoration._({
    required this.style,
    required this.pressedColor,
  });

  /// The `TextStyle` of the calendar's action.
  final TextStyle? style;

  /// The `Color` of the calendar's action when pressed.
  final Color pressedColor;

  /// Creates a copy of the class with the provided parameters.
  CalendarActionDecoration copyWith({
    TextStyle? style,
    Color? pressedColor,
  }) {
    return CalendarActionDecoration(
      style: style ?? this.style,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }
}
