import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class CalendarPicker extends StatefulWidget {
  /// Creates a calendar picker.
  CalendarPicker({
    required this.initialMonth,
    required this.currentDate,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    required this.onDatePickerChanged,
    this.weekdayDecoration,
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
  final CalendarWeekdaysDecoration? weekdayDecoration;

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  late PageController _pageController;
  late AnimationController _animationController;
  late bool _isYearPickerShowed;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;

    final monthDelta = DateUtils.monthDelta(widget.minimumDate, _currentMonth);
    _pageController = PageController(initialPage: monthDelta);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _isYearPickerShowed = _animationController.isCompleted;
  }

  @override
  void didUpdateWidget(CalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final initialMonth = widget.initialMonth;
    final oldInitialMonth = oldWidget.initialMonth;
    if (initialMonth != oldInitialMonth && initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDateSelection(DateTime selectedDate) {
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final minimumDate = widget.minimumDate;
      final monthDate = DateUtils.addMonthsToMonthDate(minimumDate, monthPage);
      final isCurrentMonth = DateUtils.isSameMonth(_currentMonth, monthDate);
      if (!isCurrentMonth) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
      }
    });
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _showMonth(DateTime month, {bool jump = false}) {
    final monthPage = DateUtils.monthDelta(widget.minimumDate, month);
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

  /// Earliest allowable month.
  bool get _isDisplayingFirstMonth {
    final minimumDate = widget.minimumDate;
    return !_currentMonth.isAfter(
      DateTime(minimumDate.year, minimumDate.month),
    );
  }

  /// Latest allowable month.
  bool get _isDisplayingLastMonth {
    final maximumDate = widget.maximumDate;
    return !_currentMonth.isBefore(
      DateTime(maximumDate.year, maximumDate.month),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    final month = DateUtils.addMonthsToMonthDate(widget.minimumDate, index);
    return CalendarDaysGrid(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelection,
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
      return CalendarWeekday(
        weekday: weekday.toUpperCase(),
        decoration: widget.weekdayDecoration,
      );
    });
  }

  void _showYearPicker() {
    setState(() {
      _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward();
      _isYearPickerShowed = !_isYearPickerShowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    final dateFormat = intl.DateFormat('MMMM yyyy');
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
                onTap: _showYearPicker,
                child: SizedBox(
                  height: 44.0,
                  child: Row(
                    children: [
                      Text(
                        dateFormat.format(_currentMonth),
                        style: TextStyle(
                          color: CupertinoDynamicColor.resolve(
                            _isYearPickerShowed
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
                        turns: _isYearPickerShowed ? 1.25 : 1.0,
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
                child: _isYearPickerShowed
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
            crossFadeState: _isYearPickerShowed
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
