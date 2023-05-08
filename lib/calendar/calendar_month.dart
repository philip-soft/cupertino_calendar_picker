import 'package:cupertino_calendar/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class CalendarMonth extends StatefulWidget {
  /// Creates a calendar month picker.
  CalendarMonth({
    required this.initialMonth,
    required this.currentDate,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    required this.onDatePickerChanged,
    super.key,
  })  : assert(!minimumDate.isAfter(maximumDate)),
        assert(!selectedDate.isBefore(minimumDate)),
        assert(!selectedDate.isAfter(maximumDate));

  /// The initial month to display.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maximumDate].
  final DateTime minimumDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minimumDate].
  final DateTime maximumDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final ValueChanged<DateTime> onDatePickerChanged;

  @override
  CalendarMonthState createState() => CalendarMonthState();
}

class CalendarMonthState extends State<CalendarMonth>
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
      initialPage: DateUtils.monthDelta(widget.minimumDate, _currentMonth),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(CalendarMonth oldWidget) {
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
          DateUtils.addMonthsToMonthDate(widget.minimumDate, monthPage);
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
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.minimumDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.minimumDate.year, widget.minimumDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.maximumDate.year, widget.maximumDate.month),
    );
  }

  bool _isSelectable(DateTime date) {
    return false;
  }

  Widget _buildItems(BuildContext context, int index) {
    final month = DateUtils.addMonthsToMonthDate(widget.minimumDate, index);
    return CalendarDaysGrid(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      minimumDate: widget.minimumDate,
      maximumDate: widget.maximumDate,
      displayedMonth: month,
    );
  }

  List<Widget> _dayHeaders(MaterialLocalizations localizations) {
    final nowDate = DateTime.now();
    final year = nowDate.year;
    final month = nowDate.month;
    final firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      localizations,
    );
    final weekdayFormat = intl.DateFormat.E();
    final firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    return List.generate(7, (index) {
      final weekday = weekdayFormat.format(
        firstDayOfWeekDate.add(Duration(days: index)),
      );
      return CalendarWeekday(weekday: weekday.toUpperCase());
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
                child: SizedBox(
                  height: 44.0,
                  child: Row(
                    children: [
                      Text(
                        intl.DateFormat('MMMM yyyy').format(_currentMonth),
                        style: TextStyle(
                          color: CupertinoDynamicColor.resolve(
                            _isPickerShowed
                                ? CupertinoDynamicColor.withBrightness(
                                    color: CupertinoColors.systemRed,
                                    darkColor:
                                        CupertinoColors.systemRed.darkColor,
                                  )
                                : CupertinoDynamicColor.withBrightness(
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
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        turns: _isPickerShowed ? 1.25 : 1.0,
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          color: enabledColor,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _isPickerShowed
                    ? const SizedBox()
                    : Row(
                        children: [
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
                          widget.minimumDate,
                          widget.maximumDate,
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
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                onDidDateStopScrolling: print,
                onDateTimeChanged: widget.onDatePickerChanged,
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
