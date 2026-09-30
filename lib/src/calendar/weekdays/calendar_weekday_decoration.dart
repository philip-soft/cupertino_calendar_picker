// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

const CupertinoDynamicColor calendarWeekdayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarWeekdayStyle = TextStyle(
  color: calendarWeekdayColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

/// A decoration class for the calendar's weekday.
@immutable
class CalendarWeekdayDecoration {
  /// Creates a calendar's weekday decoration class with default values
  /// for non-provided parameters.
  ///
  /// [CupertinoDynamicColor]s are resolved against the ambient brightness
  /// when the weekday is built.
  factory CalendarWeekdayDecoration({TextStyle? textStyle}) {
    return CalendarWeekdayDecoration._(
      textStyle: textStyle ?? calendarWeekdayStyle,
    );
  }

  const CalendarWeekdayDecoration._({required this.textStyle});

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

  /// Creates a copy of the class with the provided parameters.
  CalendarWeekdayDecoration copyWith({TextStyle? textStyle}) {
    return CalendarWeekdayDecoration(textStyle: textStyle ?? this.textStyle);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarWeekdayDecoration && other.textStyle == textStyle;
  }

  @override
  int get hashCode => textStyle.hashCode;
}
