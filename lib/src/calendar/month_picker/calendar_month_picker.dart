// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class CalendarMonthPicker extends StatelessWidget {
  /// Creates a day picker.
  CalendarMonthPicker({
    required this.monthPageController,
    required this.onMonthPageChanged,
    required DateTime displayedMonth,
    required DateTime currentDate,
    required DateTime minimumDate,
    required DateTime maximumDate,
    required DateTime selectedDate,
    required this.onChanged,
    required this.decoration,
    required this.mainColor,
    required this.firstDayOfWeekIndex,
    required this.selectableDayPredicate,
    super.key,
  }) : minimumDate = DateUtils.dateOnly(minimumDate),
       maximumDate = DateUtils.dateOnly(maximumDate),
       currentDate = DateUtils.dateOnly(currentDate),
       selectedDate = DateUtils.dateOnly(selectedDate),
       displayedMonth = DateUtils.dateOnly(displayedMonth);

  final PageController monthPageController;
  final ValueChanged<int> onMonthPageChanged;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// A predicate that determines whether a day is selectable.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maximumDate].
  final DateTime minimumDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minimumDate].
  final DateTime maximumDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// The decoration class for each day type.
  final CalendarMonthPickerDecoration decoration;

  /// The main color of the month picker.
  final Color mainColor;

  /// The index of the first day of the week, where 0 represents Sunday.
  ///
  /// The default value is based on the locale.
  final int? firstDayOfWeekIndex;

  /// The number of months between [minimumDate] and [maximumDate], inclusive.
  int get monthCount => DateUtils.monthDelta(minimumDate, maximumDate) + 1;

  int _dayOffset(BuildContext context, DateTime monthDate) {
    return PackageDateUtils.firstDayOffset(
      monthDate.year,
      monthDate.month,
      firstDayOfWeekIndex ?? context.materialLocalization.firstDayOfWeekIndex,
    );
  }

  bool _isDisabled(DateTime date) {
    return date.isAfter(maximumDate) ||
        date.isBefore(minimumDate) ||
        selectableDayPredicate?.call(date) == false;
  }

  CalendarMonthPickerDayStyle _dayStyle(
    BuildContext context, {
    required bool isDisabled,
    required bool isToday,
    required bool isSelected,
  }) {
    if (isDisabled) {
      return decoration.disabledDayStyle ??
          CalendarMonthPickerDisabledDayStyle.withDynamicColor(context);
    }
    if (isToday && isSelected) {
      return decoration.selectedCurrentDayStyle ??
          CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          );
    }
    if (isToday) {
      return decoration.currentDayStyle ??
          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          );
    }
    if (isSelected) {
      return decoration.selectedDayStyle ??
          CalendarMonthPickerSelectedDayStyle.withDynamicColor(
            context,
            mainColor: mainColor,
          );
    }
    return decoration.defaultDayStyle ??
        CalendarMonthPickerDefaultDayStyle.withDynamicColor(context);
  }

  List<Widget> _days(
    BuildContext context, {
    required DateTime monthDate,
    required int dayOffset,
    required double backgroundCircleSize,
  }) {
    final int daysInMonth = DateUtils.getDaysInMonth(
      monthDate.year,
      monthDate.month,
    );

    return <Widget>[
      for (int i = 0; i < dayOffset; i++) const SizedBox(),
      for (int day = 1; day <= daysInMonth; day++)
        _day(
          context,
          date: DateTime(monthDate.year, monthDate.month, day),
          backgroundCircleSize: backgroundCircleSize,
        ),
    ];
  }

  Widget _day(
    BuildContext context, {
    required DateTime date,
    required double backgroundCircleSize,
  }) {
    final bool isDisabled = _isDisabled(date);
    final bool isToday = DateUtils.isSameDay(currentDate, date);
    final bool isSelected = DateUtils.isSameDay(selectedDate, date);

    return CalendarMonthPickerDay(
      dayDate: date,
      isSelected: isSelected,
      isToday: isToday,
      onDaySelected: isDisabled ? null : onChanged,
      style: _dayStyle(
        context,
        isDisabled: isDisabled,
        isToday: isToday,
        isSelected: isSelected,
      ),
      backgroundCircleSize: backgroundCircleSize,
    );
  }

  /// Returns the number of week rows needed to display [cellCount] cells.
  ///
  /// For example, a 31-day month starting on the last day of the week needs
  /// 6 rows, while a 28-day month starting on the first day needs 4.
  static int rowCount(int cellCount) {
    return (cellCount / DateTime.daysPerWeek).ceil();
  }

  static double _rowSize(int rowCount) {
    return rowCount > 5
        ? calendarMonthPickerSixRowsSize
        : calendarMonthPickerOtherRowsSize;
  }

  Widget _buildMonth(BuildContext context, int index) {
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(
      minimumDate,
      index,
    );
    final int dayOffset = _dayOffset(context, monthDate);
    final int cellCount =
        dayOffset + DateUtils.getDaysInMonth(monthDate.year, monthDate.month);
    final double rowSize = _rowSize(rowCount(cellCount));

    return GridView.custom(
      padding: const EdgeInsets.symmetric(
        horizontal: calendarMonthPickerHorizontalPadding,
      ),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: CalendarMonthPickerGridDelegate(rowSize: rowSize),
      childrenDelegate: SliverChildListDelegate(
        _days(
          context,
          monthDate: monthDate,
          dayOffset: dayOffset,
          backgroundCircleSize: rowSize > calendarMonthPickerDayMaxSize
              ? calendarMonthPickerDayMaxSize
              : rowSize,
        ),
        addRepaintBoundaries: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        // The page index depends on the range, so a changed range needs
        // a fresh scroll position.
        key: ValueKey<(int, int)>((
          DateUtils.monthDelta(DateTime(0), minimumDate),
          monthCount,
        )),
        controller: monthPageController,
        itemBuilder: _buildMonth,
        itemCount: monthCount,
        onPageChanged: onMonthPageChanged,
      ),
    );
  }
}
