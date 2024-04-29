import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';

class CalendarMonthPickerDecoration {
  const CalendarMonthPickerDecoration({
    this.dayStyle,
    this.todayStyle,
    this.selectedDayStyle,
    this.selectedTodayStyle,
    this.disabledDayStyle,
  });

  factory CalendarMonthPickerDecoration.defaultDecoration(
    BuildContext context,
  ) {
    return CalendarMonthPickerDecoration(
      dayStyle: CalendarMonthPickerDefaultDayStyle.defaultDecoration(context),
      todayStyle: CalendarMonthPickerCurrentDayStyle.defaultDecoration(context),
      disabledDayStyle: CalendarMonthPickerDisabledDayStyle.defaultDecoration(
        context,
      ),
      selectedDayStyle: CalendarMonthPickerSelectedDayStyle.defaultDecoration(
        context,
      ),
      selectedTodayStyle:
          CalendarMonthPickerCurrentAndSelectedStyle.defaultDecoration(
        context,
      ),
    );
  }

  final CalendarMonthPickerDayStyle? dayStyle;
  final CalendarMonthPickerDayStyle? todayStyle;
  final CalendarMonthPickerDayStyle? selectedDayStyle;
  final CalendarMonthPickerDayStyle? selectedTodayStyle;
  final CalendarMonthPickerDayStyle? disabledDayStyle;

  CalendarMonthPickerDecoration copyWith({
    CalendarMonthPickerDayStyle? dayStyle,
    CalendarMonthPickerDayStyle? todayStyle,
    CalendarMonthPickerDayStyle? selectedDayStyle,
    CalendarMonthPickerDayStyle? selectedTodayStyle,
    CalendarMonthPickerDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      dayStyle: dayStyle ?? this.dayStyle,
      todayStyle: todayStyle ?? this.todayStyle,
      selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
      selectedTodayStyle: selectedTodayStyle ?? this.selectedTodayStyle,
      disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    );
  }
}
