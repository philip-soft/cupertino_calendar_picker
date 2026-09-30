// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

/// A decoration class for the calendar's month picker.
///
/// A `null` style falls back to the default style of that day type.
@immutable
class CalendarMonthPickerDecoration {
  /// Creates a calendar's month picker decoration class with default values
  /// for non-provided parameters.
  const CalendarMonthPickerDecoration({
    this.defaultDayStyle,
    this.currentDayStyle,
    this.selectedDayStyle,
    this.selectedCurrentDayStyle,
    this.disabledDayStyle,
  });

  /// Creates a calendar's month picker decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  ///
  /// [mainColor] is used only if any other color is not provided.
  factory CalendarMonthPickerDecoration.withDynamicColor(
    BuildContext context, {
    Color? mainColor,
    CalendarMonthPickerDefaultDayStyle? defaultDayStyle,
    CalendarMonthPickerCurrentDayStyle? currentDayStyle,
    CalendarMonthPickerSelectedDayStyle? selectedDayStyle,
    CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarMonthPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      defaultDayStyle:
          defaultDayStyle ??
          CalendarMonthPickerDefaultDayStyle.withDynamicColor(context),
      currentDayStyle:
          currentDayStyle ??
          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      disabledDayStyle:
          disabledDayStyle ??
          CalendarMonthPickerDisabledDayStyle.withDynamicColor(context),
      selectedDayStyle:
          selectedDayStyle ??
          CalendarMonthPickerSelectedDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      selectedCurrentDayStyle:
          selectedCurrentDayStyle ??
          CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
    );
  }

  /// The [CalendarMonthPickerDefaultDayStyle] of the
  /// calendar's month picker default day.
  final CalendarMonthPickerDefaultDayStyle? defaultDayStyle;

  /// The [CalendarMonthPickerCurrentDayStyle] of the
  /// calendar's month picker current day.
  final CalendarMonthPickerCurrentDayStyle? currentDayStyle;

  /// The [CalendarMonthPickerSelectedDayStyle] of the
  /// calendar's month picker selected day.
  final CalendarMonthPickerSelectedDayStyle? selectedDayStyle;

  /// The [CalendarMonthPickerSelectedCurrentDayStyle] of the
  /// calendar's month picker selected current day.
  final CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle;

  /// The [CalendarMonthPickerDisabledDayStyle] of the
  /// calendar's month picker disabled day.
  final CalendarMonthPickerDisabledDayStyle? disabledDayStyle;

  /// Creates a copy of the class with the provided parameters.
  CalendarMonthPickerDecoration copyWith({
    CalendarMonthPickerDefaultDayStyle? defaultDayStyle,
    CalendarMonthPickerCurrentDayStyle? currentDayStyle,
    CalendarMonthPickerSelectedDayStyle? selectedDayStyle,
    CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarMonthPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      defaultDayStyle: defaultDayStyle ?? this.defaultDayStyle,
      currentDayStyle: currentDayStyle ?? this.currentDayStyle,
      selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
      selectedCurrentDayStyle:
          selectedCurrentDayStyle ?? this.selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarMonthPickerDecoration &&
        other.defaultDayStyle == defaultDayStyle &&
        other.currentDayStyle == currentDayStyle &&
        other.selectedDayStyle == selectedDayStyle &&
        other.selectedCurrentDayStyle == selectedCurrentDayStyle &&
        other.disabledDayStyle == disabledDayStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      defaultDayStyle,
      currentDayStyle,
      selectedDayStyle,
      selectedCurrentDayStyle,
      disabledDayStyle,
    );
  }
}
