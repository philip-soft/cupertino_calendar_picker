// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarMonthPickerDisabledDayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarMonthPickerDisabledDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDisabledDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerDefaultDayColor =
    CupertinoColors.label;
const TextStyle calendarMonthPickerDefaultDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDefaultDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const TextStyle calendarMonthPickerSelectedDayStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

final TextStyle calendarMonthPickerSelectedCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);

const TextStyle calendarMonthPickerCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

/// A base decoration class for the calendar's month picker day.
abstract class CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDayStyle({
    required this.textStyle,
  });

  /// The [TextStyle] of the calendar's month picker day.
  final TextStyle textStyle;
}

/// A base decoration class for the calendar's month picker background circled day.
abstract class CalendarMonthPickerBackgroundCircledDayStyle
    extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerBackgroundCircledDayStyle({
    required super.textStyle,
    required this.backgroundCircleColor,
  });

  /// The background circle [Color] of the calendar's month picker day.
  final Color? backgroundCircleColor;
}

/// A decoration class for the calendar's month picker disabled day.
class CalendarMonthPickerDisabledDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker disabled day decoration class
  /// with default values for non-provided parameters.
  factory CalendarMonthPickerDisabledDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDisabledDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDisabledDayStyle,
    );
  }

  const CalendarMonthPickerDisabledDayStyle._({
    required super.textStyle,
  });

  /// Creates a calendar's month picker disabled day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarMonthPickerDisabledDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerDisabledDayStyle;
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? calendarMonthPickerDisabledDayColor,
          context,
        ),
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerDisabledDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker default day.
class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker default day decoration class
  /// with default values for non-provided parameters.
  factory CalendarMonthPickerDefaultDayStyle({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDefaultDayStyle,
    );
  }

  const CalendarMonthPickerDefaultDayStyle._({
    required super.textStyle,
  });

  /// Creates a calendar's month picker default day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarMonthPickerDefaultDayStyle.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerDefaultDayStyle;
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerDefaultDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerDefaultDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker selected day.
class CalendarMonthPickerSelectedDayStyle
    extends CalendarMonthPickerBackgroundCircledDayStyle {
  /// Creates a calendar's month picker selected day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerSelectedDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(color: mainColor),
      backgroundCircleColor: backgroundCircleColor ?? mainColor?.withAlpha(30),
    );
  }

  const CalendarMonthPickerSelectedDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  /// Creates a calendar's month picker selected day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      mainColor: mainColor,
      textStyle: textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(
            color: CupertinoDynamicColor.maybeResolve(mainColor, context),
          ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor?.withAlpha(30),
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerSelectedDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker selected current day.
class CalendarMonthPickerSelectedCurrentDayStyle
    extends CalendarMonthPickerBackgroundCircledDayStyle {
  /// Creates a calendar's month picker selected current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerSelectedCurrentDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerSelectedCurrentDayStyle,
      backgroundCircleColor: backgroundCircleColor ?? mainColor,
    );
  }

  const CalendarMonthPickerSelectedCurrentDayStyle._({
    required super.textStyle,
    required super.backgroundCircleColor,
  });

  /// Creates a calendar's month picker selected current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    final TextStyle style =
        textStyle ?? calendarMonthPickerSelectedCurrentDayStyle;
    return CalendarMonthPickerSelectedCurrentDayStyle(
      mainColor: mainColor,
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(style.color, context),
      ),
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor ?? mainColor,
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerSelectedCurrentDayStyle? copyWith({
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedCurrentDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker current day.
class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  factory CalendarMonthPickerCurrentDayStyle({
    TextStyle? textStyle,
    Color? borderColor,
  }) {
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerCurrentDayStyle,
      borderColor: borderColor,
    );
  }

  const CalendarMonthPickerCurrentDayStyle._({
    required super.textStyle,
    required this.borderColor,
  });

  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    Color? borderColor,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerCurrentDayStyle;
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.maybeResolve(
          style.color ?? mainColor,
          context,
        ),
      ),
      borderColor: borderColor,
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerCurrentDayStyle? copyWith({
    TextStyle? textStyle,
    bool useBorder = false,
  }) {
    return CalendarMonthPickerCurrentDayStyle(
      textStyle: textStyle ?? this.textStyle,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  /// Whether to use a border for the calendar's month picker day.
  final Color? borderColor;
}
