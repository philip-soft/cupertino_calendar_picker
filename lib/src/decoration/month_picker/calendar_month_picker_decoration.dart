import 'package:cupertino_calendar/lib.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CalendarMonthPickerDecoration extends Equatable {
  const CalendarMonthPickerDecoration({
    this.dayStyle,
    this.todayStyle,
    this.selectedDayStyle,
    this.selectedTodayStyle,
    this.disabledDayStyle,
  });

  final CalendarMonthPickerDayStyle? dayStyle;
  final CalendarMonthPickerDayStyle? todayStyle;
  final CalendarMonthPickerDayStyle? selectedDayStyle;
  final CalendarMonthPickerDayStyle? selectedTodayStyle;
  final CalendarMonthPickerDayStyle? disabledDayStyle;

  factory CalendarMonthPickerDecoration.defaultDecoration(
    BuildContext context,
  ) {
    return CalendarMonthPickerDecoration(
      dayStyle: CalendarMonthPickerDefaultDayStyle.defaultDecoration(context),
      todayStyle: CalendarMonthPickerTodayStyle.defaultDecoration(context),
      disabledDayStyle: CalendarMonthPickerDisabledDayStyle.defaultDecoration(
        context,
      ),
      selectedDayStyle: CalendarMonthPickerSelectedDayStyle.defaultDecoration(
        context,
      ),
      selectedTodayStyle:
          CalendarMonthPickerSelectedTodayStyle.defaultDecoration(
        context,
      ),
    );
  }

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

  @override
  List<Object?> get props => <Object?>[
        dayStyle,
        todayStyle,
        selectedDayStyle,
        selectedTodayStyle,
        disabledDayStyle,
      ];
}
