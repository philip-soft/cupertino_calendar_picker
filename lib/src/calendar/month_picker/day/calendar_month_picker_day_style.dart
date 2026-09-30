// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

const CupertinoDynamicColor calendarMonthPickerDisabledDayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarMonthPickerDisabledDayStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  fontSize: 20.0,
  color: calendarMonthPickerDisabledDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerDefaultDayColor =
    CupertinoColors.label;
const TextStyle calendarMonthPickerDefaultDayStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  fontSize: 20.0,
  color: calendarMonthPickerDefaultDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const TextStyle calendarMonthPickerSelectedDayStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

final TextStyle calendarMonthPickerSelectedCurrentDayStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  fontSize: 20.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);

const TextStyle calendarMonthPickerCurrentDayStyle = TextStyle(
  fontFamily: 'CupertinoSystemText',
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

/// A base decoration class for the calendar's month picker day.
@immutable
abstract class CalendarMonthPickerDayStyle {
  const CalendarMonthPickerDayStyle({required this.textStyle});

  /// The [TextStyle] of the calendar's month picker day.
  final TextStyle textStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other.runtimeType == runtimeType &&
        other is CalendarMonthPickerDayStyle &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(runtimeType, textStyle);
}

/// A base decoration class for the calendar's month picker background circled day.
abstract class CalendarMonthPickerBackgroundCircledDayStyle
    extends CalendarMonthPickerDayStyle {
  const CalendarMonthPickerBackgroundCircledDayStyle({
    required super.textStyle,
    required this.backgroundCircleColor,
  });

  /// The background circle [Color] of the calendar's month picker day.
  final Color backgroundCircleColor;

  @override
  bool operator ==(Object other) {
    return super == other &&
        other is CalendarMonthPickerBackgroundCircledDayStyle &&
        other.backgroundCircleColor == backgroundCircleColor;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, backgroundCircleColor);
}

/// A decoration class for the calendar's month picker disabled day.
class CalendarMonthPickerDisabledDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker disabled day decoration class
  /// with default values for non-provided parameters.
  factory CalendarMonthPickerDisabledDayStyle({TextStyle? textStyle}) {
    return CalendarMonthPickerDisabledDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDisabledDayStyle,
    );
  }

  const CalendarMonthPickerDisabledDayStyle._({required super.textStyle});

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
  CalendarMonthPickerDisabledDayStyle copyWith({TextStyle? textStyle}) {
    return CalendarMonthPickerDisabledDayStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// A decoration class for the calendar's month picker default day.
class CalendarMonthPickerDefaultDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker default day decoration class
  /// with default values for non-provided parameters.
  factory CalendarMonthPickerDefaultDayStyle({TextStyle? textStyle}) {
    return CalendarMonthPickerDefaultDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerDefaultDayStyle,
    );
  }

  const CalendarMonthPickerDefaultDayStyle._({required super.textStyle});

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
  CalendarMonthPickerDefaultDayStyle copyWith({TextStyle? textStyle}) {
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
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerSelectedDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    final Color color = mainColor ?? calendarDefaultMainColor;
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle:
          textStyle ??
          calendarMonthPickerSelectedDayStyle.copyWith(color: color),
      backgroundCircleColor:
          backgroundCircleColor ??
          color.withAlpha(calendarSelectedDayBackgroundAlpha),
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
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerSelectedDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    final Color color = CupertinoDynamicColor.resolve(
      mainColor ?? calendarDefaultMainColor,
      context,
    );
    return CalendarMonthPickerSelectedDayStyle(
      mainColor: color,
      textStyle: textStyle,
      backgroundCircleColor: CupertinoDynamicColor.maybeResolve(
        backgroundCircleColor,
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerSelectedDayStyle copyWith({
    TextStyle? textStyle,
    Color? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedDayStyle._(
      textStyle: textStyle ?? this.textStyle,
      backgroundCircleColor:
          backgroundCircleColor ?? this.backgroundCircleColor,
    );
  }
}

/// A decoration class for the calendar's month picker selected current day.
class CalendarMonthPickerSelectedCurrentDayStyle
    extends CalendarMonthPickerBackgroundCircledDayStyle {
  /// Creates a calendar's month picker selected current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerSelectedCurrentDayStyle({
    Color? mainColor,
    Color? backgroundCircleColor,
    TextStyle? textStyle,
  }) {
    return CalendarMonthPickerSelectedCurrentDayStyle._(
      textStyle: textStyle ?? calendarMonthPickerSelectedCurrentDayStyle,
      backgroundCircleColor:
          backgroundCircleColor ?? mainColor ?? calendarDefaultMainColor,
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
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundCircleColor,
  }) {
    final TextStyle style =
        textStyle ?? calendarMonthPickerSelectedCurrentDayStyle;
    return CalendarMonthPickerSelectedCurrentDayStyle(
      textStyle: style.resolveDynamic(context),
      backgroundCircleColor: CupertinoDynamicColor.resolve(
        backgroundCircleColor ?? mainColor ?? calendarDefaultMainColor,
        context,
      ),
    );
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerSelectedCurrentDayStyle copyWith({
    TextStyle? textStyle,
    Color? backgroundCircleColor,
  }) {
    return CalendarMonthPickerSelectedCurrentDayStyle._(
      textStyle: textStyle ?? this.textStyle,
      backgroundCircleColor:
          backgroundCircleColor ?? this.backgroundCircleColor,
    );
  }
}

/// A decoration class for the calendar's month picker current day.
class CalendarMonthPickerCurrentDayStyle extends CalendarMonthPickerDayStyle {
  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// [mainColor] is used only if [textStyle] has no color and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerCurrentDayStyle({
    Color? mainColor,
    TextStyle? textStyle,
  }) {
    final TextStyle style = textStyle ?? calendarMonthPickerCurrentDayStyle;
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: style.copyWith(
        color: style.color ?? mainColor ?? calendarDefaultMainColor,
      ),
    );
  }

  const CalendarMonthPickerCurrentDayStyle._({required super.textStyle});

  /// Creates a calendar's month picker current day decoration class
  /// with default values for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided and
  /// defaults to [CupertinoColors.systemRed].
  factory CalendarMonthPickerCurrentDayStyle.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    TextStyle? textStyle,
  }) {
    final CalendarMonthPickerCurrentDayStyle style =
        CalendarMonthPickerCurrentDayStyle(
          mainColor: mainColor,
          textStyle: textStyle,
        );
    return style.copyWith(textStyle: style.textStyle.resolveDynamic(context));
  }

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerCurrentDayStyle copyWith({TextStyle? textStyle}) {
    return CalendarMonthPickerCurrentDayStyle._(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
