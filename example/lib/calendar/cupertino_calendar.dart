import 'dart:math';

import 'package:cupertino_kit_example/calendar/date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as intl;

enum CupertinoCalendarPickerMode {
  date,
  dateTime;
}

const double _calendarDayRowHeight = 44.0;
const Duration _monthScrollDuration = Duration(milliseconds: 400);

class CupertinoCalendar extends StatefulWidget {
  /// Creates a cupertino calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// [lastDate] must be after or equal to [firstDate].
  ///
  /// [initialDate] must be between [firstDate] and [lastDate] or equal to
  /// one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  CupertinoCalendar({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required this.onDateChanged,
    this.mode = CupertinoCalendarPickerMode.dateTime,
    DateTime? currentDate,
    this.onDisplayedMonthChanged,
    super.key,
  })  : initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
  }

  /// The initially selected [DateTime] that the calendar should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  final CupertinoCalendarPickerMode mode;

  @override
  State<CupertinoCalendar> createState() => _CupertinoCalendarState();
}

class _CupertinoCalendarState extends State<CupertinoCalendar> {
  final GlobalKey _monthPickerKey = GlobalKey();
  late CupertinoCalendarPickerMode _mode;
  late DateTime _currentDisplayedMonthDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    _currentDisplayedMonthDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(CupertinoCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode) {
      _mode = widget.mode;
    }
    if (!DateUtils.isSameDay(widget.initialDate, oldWidget.initialDate)) {
      _currentDisplayedMonthDate = DateTime(
        widget.initialDate.year,
        widget.initialDate.month,
      );
      _selectedDate = widget.initialDate;
    }
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    DateTime? newValue;
    if (value.isBefore(widget.firstDate)) {
      newValue = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      newValue = widget.lastDate;
    }

    setState(() {
      _handleMonthChanged(newValue ?? value);
    });
  }

  void _handleDayChanged(DateTime value) {
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate);
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case CupertinoCalendarPickerMode.dateTime:
        return _MonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: widget.currentDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
        );
      case CupertinoCalendarPickerMode.date:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.0,
      child: AspectRatio(
        aspectRatio: 1.02,
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.systemBackground,
                darkColor: CupertinoColors.systemBackground.darkElevatedColor,
              ),
              context,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoDynamicColor.resolve(
                  CupertinoDynamicColor.withBrightness(
                    color: CupertinoColors.systemBackground,
                    darkColor:
                        CupertinoColors.systemBackground.darkElevatedColor,
                  ),
                  context,
                ),
                offset: const Offset(0, 10),
                blurRadius: 60.0,
              ),
            ],
          ),
          child: _buildPicker(),
        ),
      ),
    );
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    super.key,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

  /// The initial month to display.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker>
    with SingleTickerProviderStateMixin {
  late GlobalKey _pageViewKey;
  late DateTime _currentMonth;
  late PageController _pageController;
  late AnimationController _controller;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _pageViewKey = GlobalKey();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.firstDate, _currentMonth),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  bool _isSelectable(DateTime date) {
    return false;
  }

  Widget _buildItems(BuildContext context, int index) {
    final month = DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return _DayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
    );
  }

  List<Widget> _dayHeaders(MaterialLocalizations localizations) {
    final nowDate = DateTime.now();
    final firstDayOffset = DateUtils.firstDayOffset(
      nowDate.year,
      nowDate.month,
      localizations,
    );
    final weekdayFormat = intl.DateFormat.E();
    final firstDayOfWeekDate = nowDate.subtract(
      Duration(days: firstDayOffset),
    );
    return List.generate(7, (index) {
      final weekday = weekdayFormat.format(
        firstDayOfWeekDate.add(Duration(days: index)),
      );
      return _DayOfTheWeek(weekday: weekday.toUpperCase());
    });
  }

  void _showPicker() {
    setState(() {
      _controller.isCompleted ? _controller.reverse() : _controller.forward();
      _isPickerShowed = !_isPickerShowed;
    });
  }

  bool _isPickerShowed = false;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    final localizations = MaterialLocalizations.of(context);
    final enabledColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemRed,
        darkColor: CupertinoColors.systemRed.darkColor,
      ),
      context,
    );
    final disabledColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.opaqueSeparator,
        darkColor: CupertinoColors.opaqueSeparator.darkColor,
      ),
      context,
    );

    final forwardButtonColor =
        _isDisplayingLastMonth ? disabledColor : enabledColor;
    final backwardButtonColor =
        _isDisplayingFirstMonth ? disabledColor : enabledColor;

    return Column(
      children: [
        const SizedBox(height: 4.0),
        Container(
          margin: const EdgeInsets.only(left: 16.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _showPicker,
                child: Row(
                  children: [
                    Text(
                      intl.DateFormat('MMMM yyyy').format(_currentMonth),
                      style: TextStyle(
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.label,
                            darkColor: CupertinoColors.label.darkColor,
                          ),
                          context,
                        ),
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                        letterSpacing: -0.41,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: enabledColor,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handlePreviousMonth,
                child: SizedBox(
                  height: 44.0,
                  width: 44.0,
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: backwardButtonColor,
                    size: 26.0,
                  ),
                ),
              ),
              const SizedBox(width: 2.0),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handleNextMonth,
                child: SizedBox(
                  height: 44.0,
                  width: 44.0,
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    color: forwardButtonColor,
                    size: 26.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedCrossFade(
            crossFadeState: _isPickerShowed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            firstChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _dayHeaders(localizations),
                  ),
                ),
                const SizedBox(height: 3.0),
                Expanded(
                  child: PageView.builder(
                    key: _pageViewKey,
                    controller: _pageController,
                    itemBuilder: _buildItems,
                    itemCount: DateUtils.monthDelta(
                          widget.firstDate,
                          widget.lastDate,
                        ) +
                        1,
                    onPageChanged: _handleMonthPageChanged,
                  ),
                ),
              ],
            ),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: 7.0,
                right: 7.0,
                top: 10.0,
                bottom: 38.0,
              ),
              child: CupertinoCalendarDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: widget.firstDate,
                maximumDate: widget.lastDate,
                onDateTimeChanged: print,
              ),
            ),
            layoutBuilder:
                (topChild, topChildKey, bottomChild, bottomChildKey) {
              return Stack(
                children: <Widget>[
                  bottomChild,
                  topChild,
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// /// Displays the days of a given month and allows choosing a day.
// ///
// /// The days are arranged in a rectangular grid with one column for each day of
// /// the week.
class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  _DayPicker({
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    super.key,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

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
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  @override
  State<_DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
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
        final isDisabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate);
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
      gridDelegate: _DayPickerGridDelegate(
        maxCalendarRowCount: maxCalendarRowCount,
      ),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate({required this.maxCalendarRowCount});

  final int maxCalendarRowCount;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek;
    final tileWidth = constraints.crossAxisExtent / columnCount;
    final tileHeight = min(
      _calendarDayRowHeight,
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
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

class _DayOfTheWeek extends StatelessWidget {
  const _DayOfTheWeek({
    required this.weekday,
  });

  final String weekday;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        weekday,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.tertiaryLabel,
              darkColor: CupertinoColors.tertiaryLabel.darkColor,
            ),
            context,
          ),
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.08,
        ),
      ),
    );
  }
}
