import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

// /// Displays the days of a given month and allows choosing a day.
// ///
// /// The days are arranged in a rectangular grid with one column for each day of
// /// the week.
class CalendarMonthPicker extends StatefulWidget {
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
    super.key,
  })  : minimumDate = DateUtils.dateOnly(minimumDate),
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

  @override
  State<CalendarMonthPicker> createState() => CalendarMonthPickerState();
}

class CalendarMonthPickerState extends State<CalendarMonthPicker> {
  int _daysCount(BuildContext context, int index) {
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(
      widget.minimumDate,
      index,
    );
    final int year = monthDate.year;
    final int month = monthDate.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = _dayOffset(context, monthDate: monthDate);
    return daysInMonth + dayOffset;
  }

  int _dayOffset(
    BuildContext context, {
    required DateTime monthDate,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));

    final int year = monthDate.year;
    final int month = monthDate.month;
    final int dayOffset = DateUtils.firstDayOffset(
      year,
      month,
      MaterialLocalizations.of(context),
    );
    return dayOffset;
  }

  Iterable<Widget> _days(
    BuildContext context, {
    required int index,
    required double backgroundCircleSize,
  }) sync* {
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(
      widget.minimumDate,
      index,
    );
    final int year = monthDate.year;
    final int month = monthDate.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = _dayOffset(context, monthDate: monthDate);

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        yield const SizedBox();
      } else {
        late CalendarMonthPickerDayStyle style;

        final DateTime date = DateTime(year, month, day);
        final bool isCurrentDay = DateUtils.isSameDay(widget.currentDate, date);
        final bool isSelectedDay = DateUtils.isSameDay(
          widget.selectedDate,
          date,
        );
        final bool isDisabledDay = date.isAfter(widget.maximumDate) ||
            date.isBefore(widget.minimumDate);

        final CalendarMonthPickerDecoration decoration = widget.decoration;

        if (isDisabledDay) {
          style = decoration.disabledDayStyle ??
              CalendarMonthPickerDisabledDayStyle.withDynamicColor(context);
        } else if (isCurrentDay) {
          style = decoration.currentDayStyle ??
              CalendarMonthPickerCurrentDayStyle.withDynamicColor(
                context,
                mainColor: widget.mainColor,
              );

          if (isSelectedDay) {
            style = decoration.selectedCurrentDayStyle ??
                CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
                  context,
                  mainColor: widget.mainColor,
                );
          }
        } else if (isSelectedDay) {
          style = decoration.selectedDayStyle ??
              CalendarMonthPickerSelectedDayStyle.withDynamicColor(
                context,
                mainColor: widget.mainColor,
              );
        } else {
          style = decoration.defaultDayStyle ??
              CalendarMonthPickerDefaultDayStyle.withDynamicColor(context);
        }

        final Widget dayWidget = CalendarMonthPickerDay(
          dayDate: date,
          onDaySelected: isDisabledDay ? null : widget.onChanged,
          style: style,
          backgroundCircleSize: backgroundCircleSize,
        );
        yield dayWidget;
      }
    }
  }

  int _rowCount(int daysLength) {
    /// If a month has such a week structure or similar, then [daysLength] will more then [35]
    /// and therefore [_rowCount] will be [6]
    /// Su Mo Tu We Th Fr St
    /// __ __ __ __ __ __ 01
    /// 02 03 04 05 06 07 08
    /// 09 10 11 12 13 14 15
    /// 16 17 18 19 20 21 22
    /// 23 24 25 26 27 28 29
    /// 30 31
    if (daysLength > 35) {
      return 6;

      /// If a month has such a week structure, then [daysLength] will be less then [29]
      /// and therefore [_rowCount] will be [4]
      /// Su Mo Tu We Th Fr St
      /// 01 02 03 04 05 06 07
      /// 08 09 10 11 12 13 14
      /// 15 16 17 18 19 20 21
      /// 22 23 24 25 26 27 28
    } else if (daysLength < 29) {
      return 4;
    } else {
      /// In other cases [rowCount] will be [5]
      return 5;
    }
  }

  double _rowSize(int rowCount) {
    if (rowCount == 6) {
      return calendarMonthPickerSixRowsSize;
    } else {
      return calendarMonthPickerOtherRowsSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// [+ 1] to include the last month
    final int itemCount = DateUtils.monthDelta(
          widget.minimumDate,
          widget.maximumDate,
        ) +
        1;

    return Expanded(
      child: PageView.builder(
        controller: widget.monthPageController,
        itemBuilder: (BuildContext context, int index) {
          final int daysCount = _daysCount(context, index);
          final int rowCount = _rowCount(daysCount);
          final double rowSize = _rowSize(rowCount);
          final Iterable<Widget> days = _days(
            context,
            index: index,
            backgroundCircleSize: rowSize > calendarMonthPickerDayMaxSize
                ? calendarMonthPickerDayMaxSize
                : rowSize,
          );

          return GridView.custom(
            padding: const EdgeInsets.symmetric(
              horizontal: calendarMonthPickerHorizontalPadding,
            ),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: CalendarMonthPickerGridDelegate(rowSize: rowSize),
            childrenDelegate: SliverChildListDelegate(
              days.toList(),
              addRepaintBoundaries: false,
            ),
          );
        },
        itemCount: itemCount,
        onPageChanged: widget.onMonthPageChanged,
      ),
    );
  }
}
