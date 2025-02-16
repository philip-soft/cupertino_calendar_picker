// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarActionPressedColor =
    CupertinoColors.tertiarySystemFill;
const CupertinoDynamicColor calendarActionTextColor = CupertinoColors.label;
const TextStyle calendarActionLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  color: calendarActionTextColor,
);

/// A decoration class for the calendar's action.
class CalendarActionDecoration {
  /// Creates a calendar's action decoration class with default values
  /// for non-provided parameters.
  factory CalendarActionDecoration({
    TextStyle? labelStyle,
    Color? pressedColor,
  }) {
    return CalendarActionDecoration._(
      labelStyle: labelStyle ?? calendarActionLabelStyle,
      pressedColor: pressedColor ?? calendarActionPressedColor,
    );
  }

  /// Creates a calendar's action decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarActionDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? labelStyle,
    Color? pressedColor,
  }) {
    final TextStyle textStyle = labelStyle ?? calendarActionLabelStyle;

    return CalendarActionDecoration(
      labelStyle: textStyle.copyWith(
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
    required this.labelStyle,
    required this.pressedColor,
  });

  /// The `TextStyle` of the calendar's action label.
  final TextStyle? labelStyle;

  /// The `Color` of the calendar's action when pressed.
  final Color pressedColor;

  /// Creates a copy of the class with the provided parameters.
  CalendarActionDecoration copyWith({
    TextStyle? labelStyle,
    Color? pressedColor,
  }) {
    return CalendarActionDecoration(
      labelStyle: labelStyle ?? this.labelStyle,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }
}
