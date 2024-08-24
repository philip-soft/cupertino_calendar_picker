// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarFooterTitleColor = CupertinoColors.label;
const CupertinoDynamicColor calendarTimeColor = CupertinoColors.label;
const TextStyle calendarTimeStyle = TextStyle(
  color: calendarTimeColor,
  fontSize: 17.0,
);
const TextStyle calendarFooterTimeLabelStyle = TextStyle(
  color: calendarFooterTitleColor,
  fontSize: 17.0,
);

/// A decoration class for the calendar's footer.
class CalendarFooterDecoration {
  /// Creates a calendar's footer decoration class with default values
  /// for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarFooterDecoration({
    TextStyle? timeLabelStyle,
    TextStyle? timeStyle,
  }) {
    return CalendarFooterDecoration._(
      timeLabelStyle: timeLabelStyle ?? calendarFooterTimeLabelStyle,
      timeStyle: timeStyle ?? calendarTimeStyle,
    );
  }

  const CalendarFooterDecoration._({
    this.timeLabelStyle,
    this.timeStyle,
  });

  /// Creates a calendar's footer decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarFooterDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? timeLabelStyle,
    TextStyle? timeStyle,
  }) {
    final TextStyle timeTextStyle = timeStyle ?? calendarFooterTimeLabelStyle;
    final TextStyle titleTextStyle =
        timeLabelStyle ?? calendarFooterTimeLabelStyle;
    return CalendarFooterDecoration(
      timeLabelStyle: titleTextStyle.copyWith(
        color: CupertinoDynamicColor.resolve(
          titleTextStyle.color ?? calendarFooterTitleColor,
          context,
        ),
      ),
      timeStyle: timeTextStyle.copyWith(
        color: CupertinoDynamicColor.resolve(
          timeTextStyle.color ?? calendarTimeColor,
          context,
        ),
      ),
    );
  }

  /// The [TextStyle] of the calendar's time label.
  final TextStyle? timeLabelStyle;

  /// The [TextStyle] of the calendar's time.
  final TextStyle? timeStyle;

  /// Creates a copy of the class with the provided parameters.
  CalendarFooterDecoration copyWith({
    TextStyle? timeLabelStyle,
    TextStyle? timeStyle,
  }) {
    return CalendarFooterDecoration(
      timeLabelStyle: timeLabelStyle ?? this.timeLabelStyle,
      timeStyle: timeStyle ?? this.timeStyle,
    );
  }
}
