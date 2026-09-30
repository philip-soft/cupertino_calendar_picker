// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

const CupertinoDynamicColor calendarActionPressedColor =
    CupertinoColors.tertiarySystemFill;
const CupertinoDynamicColor calendarActionTextColor = CupertinoColors.label;
const TextStyle calendarActionLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  color: calendarActionTextColor,
);

/// A decoration class for the calendar's action.
@immutable
class CalendarActionDecoration {
  /// Creates a calendar's action decoration class with default values
  /// for non-provided parameters.
  ///
  /// [CupertinoDynamicColor]s are resolved against the ambient brightness
  /// when the action is built.
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
      pressedColor: CupertinoDynamicColor.resolve(
        pressedColor ?? calendarActionPressedColor,
        context,
      ),
    );
  }

  const CalendarActionDecoration._({
    required this.labelStyle,
    required this.pressedColor,
  });

  /// The [TextStyle] of the action's label.
  final TextStyle labelStyle;

  /// The background color of the action while it is pressed.
  final Color pressedColor;

  /// Creates a copy of this class with the given fields replaced with the new values.
  CalendarActionDecoration copyWith({
    TextStyle? labelStyle,
    Color? pressedColor,
  }) {
    return CalendarActionDecoration(
      labelStyle: labelStyle ?? this.labelStyle,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarActionDecoration &&
        other.labelStyle == labelStyle &&
        other.pressedColor == pressedColor;
  }

  @override
  int get hashCode => Object.hash(labelStyle, pressedColor);
}
