import 'dart:math';

import 'package:cupertino_calendar/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// /// Displays the days of a given month and allows choosing a day.
// ///
// /// The days are arranged in a rectangular grid with one column for each day of
// /// the week.
class CalendarDaysGrid extends StatefulWidget {
  /// Creates a day picker.
  CalendarDaysGrid({
    required this.currentDate,
    required this.displayedMonth,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onChanged,
    super.key,
  })  : assert(!minimumDate.isAfter(maximumDate)),
        assert(!selectedDate.isBefore(minimumDate)),
        assert(!selectedDate.isAfter(maximumDate));

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

  @override
  State<CalendarDaysGrid> createState() => CalendarDaysGridState();
}

class CalendarDaysGridState extends State<CalendarDaysGrid> {
  int _firstDayOffset(int year, int month) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    // 0-based start of week depending on the locale, with 0 representing Sunday.
    int firstDayOfWeekIndex = 0;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  @override
  Widget build(BuildContext context) {
    const dayStyle = TextStyle(fontSize: 20.0, letterSpacing: 0.38);
    final enabledDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.label,
        darkColor: CupertinoColors.label.darkColor,
      ),
      context,
    );
    final disabledDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.opaqueSeparator,
        darkColor: CupertinoColors.opaqueSeparator.darkColor,
      ),
      context,
    );
    final selectedDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemRed,
        darkColor: CupertinoColors.systemRed.darkColor,
      ),
      context,
    );
    final selectedDayBackground = selectedDayColor.withOpacity(0.12);
    final todayColor = selectedDayColor;

    final year = widget.displayedMonth.year;
    final month = widget.displayedMonth.month;

    final dayItems = <Widget>[];
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final dayOffset = _firstDayOffset(year, month);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;

    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox());
      } else {
        final dayToBuild = DateTime(year, month, day);
        final isDisabled = dayToBuild.isAfter(widget.maximumDate) ||
            dayToBuild.isBefore(widget.minimumDate);
        final isSelectedDay = DateUtils.isSameDay(
          widget.selectedDate,
          dayToBuild,
        );
        final isToday = DateUtils.isSameDay(widget.currentDate, dayToBuild);

        BoxDecoration? decoration;
        Color dayColor = enabledDayColor;
        Color? backgroundColor;
        FontWeight dayFontWeight = FontWeight.w400;

        if (isSelectedDay) {
          dayFontWeight = FontWeight.w600;
          dayColor = selectedDayColor;
          backgroundColor = selectedDayBackground;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        }

        if (isToday) {
          if (isSelectedDay) {
            backgroundColor = selectedDayColor;
            dayColor = CupertinoColors.white;
          } else {
            dayColor = todayColor;
          }
          decoration = BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          );
        }

        if (isDisabled) {
          dayColor = disabledDayColor;
        }

        Widget dayWidget = DecoratedBox(
          decoration: decoration ?? const BoxDecoration(),
          child: Center(
            child: Text(
              '$day',
              style: dayStyle
                  .copyWith(fontWeight: dayFontWeight)
                  .apply(color: dayColor),
            ),
          ),
        );

        if (!isDisabled) {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => widget.onChanged(dayToBuild),
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    final maxCalendarRowCount = dayItems.length > 35 ? 6 : 5;
    return GridView.custom(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: CalendarDaysGridGridDelegate(
        maxCalendarRowCount: maxCalendarRowCount,
      ),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}

class CalendarDaysGridGridDelegate extends SliverGridDelegate {
  const CalendarDaysGridGridDelegate({required this.maxCalendarRowCount});

  final int maxCalendarRowCount;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek;
    final tileWidth = constraints.crossAxisExtent / columnCount;
    final tileHeight = min(
      calendarDayRowHeight,
      constraints.viewportMainAxisExtent / (maxCalendarRowCount + 1),
    );
    final factor = maxCalendarRowCount > 5 ? 1.5 : 0;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: (tileHeight * 1.135) - factor,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(CalendarDaysGridGridDelegate oldDelegate) => false;
}
