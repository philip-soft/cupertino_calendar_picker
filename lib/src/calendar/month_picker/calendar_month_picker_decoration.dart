import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CalendarMonthPickerDecoration {
  factory CalendarMonthPickerDecoration({
    CalendarMonthPickerDefaultDayStyle? defaultDayStyle,
    CalendarMonthPickerCurrentDayStyle? currentDayStyle,
    CalendarMonthPickerSelectedDayStyle? selectedDayStyle,
    CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarMonthPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration._(
      defaultDayStyle: defaultDayStyle,
      currentDayStyle: currentDayStyle,
      selectedDayStyle: selectedDayStyle,
      selectedCurrentDayStyle: selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle,
    );
  }

  const CalendarMonthPickerDecoration._({
    this.defaultDayStyle,
    this.currentDayStyle,
    this.selectedDayStyle,
    this.selectedCurrentDayStyle,
    this.disabledDayStyle,
  });

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
      defaultDayStyle: defaultDayStyle ??
          CalendarMonthPickerDefaultDayStyle.withDynamicColor(context),
      currentDayStyle: currentDayStyle ??
          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      disabledDayStyle: disabledDayStyle ??
          CalendarMonthPickerDisabledDayStyle.withDynamicColor(
            context,
          ),
      selectedDayStyle: selectedDayStyle ??
          CalendarMonthPickerSelectedDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
      selectedCurrentDayStyle: selectedCurrentDayStyle ??
          CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          ),
    );
  }

  final CalendarMonthPickerDefaultDayStyle? defaultDayStyle;
  final CalendarMonthPickerCurrentDayStyle? currentDayStyle;
  final CalendarMonthPickerSelectedDayStyle? selectedDayStyle;
  final CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle;
  final CalendarMonthPickerDisabledDayStyle? disabledDayStyle;

  CalendarMonthPickerDecoration copyWith({
    CalendarMonthPickerDefaultDayStyle? defaultDayStyle,
    CalendarMonthPickerCurrentDayStyle? currentDayStyle,
    CalendarMonthPickerSelectedDayStyle? selectedDayStyle,
    CalendarMonthPickerSelectedCurrentDayStyle? selectedCurrentDayStyle,
    CalendarMonthPickerDisabledDayStyle? disabledDayStyle,
  }) {
    return CalendarMonthPickerDecoration(
      defaultDayStyle: defaultDayStyle ?? defaultDayStyle,
      currentDayStyle: currentDayStyle ?? currentDayStyle,
      selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
      selectedCurrentDayStyle:
          selectedCurrentDayStyle ?? selectedCurrentDayStyle,
      disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    );
  }
}
