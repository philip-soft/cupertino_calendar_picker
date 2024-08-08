import 'package:cupertino_calendar_picker/src/extensions/time_of_day_extension.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPicker extends StatefulWidget {
  /// Creates a calendar's picker.
  CalendarPicker({
    required this.initialMonth,
    required this.currentDate,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    required this.onYearPickerChanged,
    required this.weekdayDecoration,
    required this.monthPickerDecoration,
    required this.headerDecoration,
    required this.mainColor,
    required this.mode,
    super.key,
  })  : assert(!minimumDate.isAfter(maximumDate)),
        assert(!currentDate.isBefore(minimumDate)),
        assert(!currentDate.isAfter(maximumDate));

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

  final ValueChanged<DateTime> onYearPickerChanged;
  final CalendarWeekdayDecoration weekdayDecoration;
  final CalendarMonthPickerDecoration monthPickerDecoration;
  final CalendarHeaderDecoration headerDecoration;
  final Color mainColor;
  final CalendarPickerMode mode;

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  late PageController _monthPageController;
  late AnimationController _animationController;
  late CalendarViewMode _previousViewMode;
  late CalendarViewMode _viewMode;
  late TimeOfDay _timeOfDay;
  late GlobalKey<CustomCupertinoDatePickerDateTimeState> _timePickerKey;

  CalendarViewMode get viewMode => _viewMode;
  set viewMode(CalendarViewMode mode) {
    _previousViewMode = viewMode;
    _viewMode = mode;
  }

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    final int monthDelta = DateUtils.monthDelta(
      widget.minimumDate,
      _currentMonth,
    );
    _monthPageController = PageController(initialPage: monthDelta);
    _animationController = AnimationController(
      vsync: this,
      duration: calendarYearPickerDuration,
    );
    _previousViewMode = CalendarViewMode.monthPicker;
    _viewMode = CalendarViewMode.monthPicker;
    _timeOfDay = TimeOfDay.now();
    _timePickerKey = GlobalKey();
  }

  @override
  void didUpdateWidget(CalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final DateTime initialMonth = widget.initialMonth;
    final DateTime oldInitialMonth = oldWidget.initialMonth;
    if (initialMonth != oldInitialMonth && initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  /// Earliest allowable month.
  bool get _isDisplayingFirstMonth {
    final DateTime minimumDate = widget.minimumDate;
    return !_currentMonth.isAfter(
      DateTime(minimumDate.year, minimumDate.month),
    );
  }

  /// Latest allowable month.
  bool get _isDisplayingLastMonth {
    final DateTime maximumDate = widget.maximumDate;
    return !_currentMonth.isBefore(
      DateTime(maximumDate.year, maximumDate.month),
    );
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime minimumDate = widget.minimumDate;
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(minimumDate, monthPage);
      final bool isCurrentMonth =
          DateUtils.isSameMonth(_currentMonth, monthDate);
      if (!isCurrentMonth) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
      }
    });
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _monthPageController.nextPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _monthPageController.previousPage(
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.minimumDate, month);
    if (jump) {
      _monthPageController.jumpToPage(monthPage);
    } else {
      _monthPageController.animateToPage(
        monthPage,
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _toggleYearPicker(bool shouldShowYearPicker) {
    setState(() {
      _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward();
      viewMode = shouldShowYearPicker
          ? CalendarViewMode.yearPicker
          : _previousViewMode;
    });
  }

  void _toggleTimePicker(bool shouldShowTimePicker) {
    setState(() {
      _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward();
      viewMode = shouldShowTimePicker
          ? CalendarViewMode.timePicker
          : _previousViewMode;
    });
  }

  void _onTimeChanged(DateTime dateTime) {
    setState(() {
      _timeOfDay = TimeOfDay.fromDateTime(dateTime);
    });
  }

  void _onDayPeriodChanged(DayPeriod dayPeriod) {
    setState(() {
      final int newHour = dayPeriod == DayPeriod.pm ? 12 : -12;
      final TimeOfDay newTimeOfDay = TimeOfDay(
        hour: _timeOfDay.hour + newHour,
        minute: _timeOfDay.minute,
      );
      _timePickerKey.currentState?.scrollToDate(
        newTimeOfDay.toDateTime(),
        _timeOfDay.toDateTime(),
        false,
      );
      _timeOfDay = newTimeOfDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 13.0),
        PickerAnimatedCrossFade(
          firstChild: CalendarHeader(
            currentMonth: _currentMonth,
            onNextMonthIconTapped:
                _isDisplayingLastMonth ? null : _handleNextMonth,
            onPreviousMonthIconTapped:
                _isDisplayingFirstMonth ? null : _handlePreviousMonth,
            onYearPickerStateChanged: _toggleYearPicker,
            decoration: widget.headerDecoration,
          ),
          crossFadeState: viewMode == CalendarViewMode.timePicker
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        Expanded(
          child: PickerAnimatedCrossFade(
            crossFadeState: viewMode == CalendarViewMode.yearPicker ||
                    viewMode == CalendarViewMode.timePicker
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Column(
              children: <Widget>[
                const SizedBox(height: 11.0),
                CalendarWeekdays(decoration: widget.weekdayDecoration),
                CalendarMonthPicker(
                  monthPageController: _monthPageController,
                  onMonthPageChanged: _handleMonthPageChanged,
                  currentDate: widget.currentDate,
                  displayedMonth: _currentMonth,
                  minimumDate: widget.minimumDate,
                  maximumDate: widget.maximumDate,
                  selectedDate: widget.selectedDate,
                  onChanged: widget.onChanged,
                  decoration: widget.monthPickerDecoration,
                  mainColor: widget.mainColor,
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
              child: switch (viewMode) {
                CalendarViewMode.yearPicker => CupertinoDatePicker(
                    minimumDate: DateTime(
                      widget.minimumDate.year,
                      widget.minimumDate.month,
                    ),
                    maximumDate: DateTime(
                      widget.maximumDate.year,
                      widget.maximumDate.month,
                    ),
                    mode: CupertinoDatePickerMode.monthYear,
                    onDateTimeChanged: widget.onYearPickerChanged,
                    initialDateTime: _currentMonth,
                  ),
                CalendarViewMode.timePicker => CustomCupertinoDatePicker(
                    key: _timePickerKey,
                    onDateTimeChanged: _onTimeChanged,
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _timeOfDay.toDateTime(),
                    use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
                  ),
                _ => const SizedBox(),
              },
            ),
          ),
        ),
        if (widget.mode == CalendarPickerMode.dateTime)
          PickerAnimatedCrossFade(
            firstChild: CalendarTimeFooter(
              time: _timeOfDay,
              onTimePickerStateChanged: _toggleTimePicker,
              onDayPeriodChanged: _onDayPeriodChanged,
            ),
            crossFadeState: viewMode == CalendarViewMode.yearPicker
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _monthPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
