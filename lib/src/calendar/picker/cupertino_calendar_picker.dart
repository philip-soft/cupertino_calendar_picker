import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarPicker extends StatefulWidget {
  /// Creates a calendar's picker.
  CupertinoCalendarPicker({
    required this.initialMonth,
    required this.currentDate,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onDateTimeChanged,
    required this.onDisplayedMonthChanged,
    required this.onYearPickerChanged,
    required this.weekdayDecoration,
    required this.monthPickerDecoration,
    required this.headerDecoration,
    required this.mainColor,
    required this.mode,
    required this.type,
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

  /// Called when the user picks a day or selects time.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final ValueChanged<DateTime> onYearPickerChanged;
  final CalendarWeekdayDecoration weekdayDecoration;
  final CalendarMonthPickerDecoration monthPickerDecoration;
  final CalendarHeaderDecoration headerDecoration;
  final Color mainColor;
  final CupertinoCalendarPickerMode mode;
  final CupertinoCalendarType type;

  @override
  CupertinoCalendarPickerState createState() => CupertinoCalendarPickerState();
}

class CupertinoCalendarPickerState extends State<CupertinoCalendarPicker>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  late DateTime _selectedDateTime;
  late PageController _monthPageController;
  late AnimationController _animationController;
  late CupertinoCalendarViewMode _previousViewMode;
  late CupertinoCalendarViewMode _viewMode;
  late GlobalKey<CustomCupertinoDatePickerDateTimeState> _timePickerKey;

  CupertinoCalendarViewMode get viewMode => _viewMode;
  set viewMode(CupertinoCalendarViewMode mode) {
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
    _previousViewMode = CupertinoCalendarViewMode.monthPicker;
    _viewMode = CupertinoCalendarViewMode.monthPicker;
    _selectedDateTime = widget.selectedDate;
    _timePickerKey = GlobalKey();
  }

  @override
  void didUpdateWidget(CupertinoCalendarPicker oldWidget) {
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
          ? CupertinoCalendarViewMode.yearPicker
          : _previousViewMode;
    });
  }

  void _toggleTimePicker(bool shouldShowTimePicker) {
    setState(() {
      _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward();
      viewMode = shouldShowTimePicker
          ? CupertinoCalendarViewMode.timePicker
          : _previousViewMode;
    });
  }

  void _onTimeChanged(DateTime dateTime) {
    _selectedDateTime = _selectedDateTime.copyWith(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
    widget.onDateTimeChanged(_selectedDateTime);
  }

  void _onDayPeriodChanged(TimeOfDay newTime) {
    final DateTime newDateTime = _selectedDateTime.copyWith(
      hour: newTime.hour,
      minute: _selectedDateTime.minute,
    );
    _timePickerKey.currentState?.scrollToDate(
      newDateTime,
      _selectedDateTime,
      false,
    );
    _selectedDateTime = newDateTime;
    widget.onDateTimeChanged(_selectedDateTime);
  }

  void _onDateChanged(DateTime dateTime) {
    _selectedDateTime = _selectedDateTime.copyWith(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
    );
    widget.onDateTimeChanged(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 13.0),
        CupertinoPickerAnimatedCrossFade(
          firstChild: CalendarHeader(
            currentMonth: _currentMonth,
            onNextMonthIconTapped:
                _isDisplayingLastMonth ? null : _handleNextMonth,
            onPreviousMonthIconTapped:
                _isDisplayingFirstMonth ? null : _handlePreviousMonth,
            onYearPickerStateChanged: _toggleYearPicker,
            decoration: widget.headerDecoration,
          ),
          crossFadeState: viewMode == CupertinoCalendarViewMode.timePicker
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        Expanded(
          child: CupertinoPickerAnimatedCrossFade(
            crossFadeState: viewMode == CupertinoCalendarViewMode.yearPicker ||
                    viewMode == CupertinoCalendarViewMode.timePicker
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
                  onChanged: _onDateChanged,
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
                CupertinoCalendarViewMode.yearPicker => CupertinoDatePicker(
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
                CupertinoCalendarViewMode.timePicker =>
                  CustomCupertinoDatePicker(
                    key: _timePickerKey,
                    onDateTimeChanged: _onTimeChanged,
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedDateTime,
                    use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
                  ),
                _ => const SizedBox(),
              },
            ),
          ),
        ),
        if (widget.mode == CupertinoCalendarPickerMode.dateTime)
          CupertinoPickerAnimatedCrossFade(
            firstChild: CalendarTimeFooter(
              type: widget.type,
              time: TimeOfDay.fromDateTime(_selectedDateTime),
              onTimePickerStateChanged: _toggleTimePicker,
              onTimeChanged: _onDayPeriodChanged,
            ),
            crossFadeState: viewMode == CupertinoCalendarViewMode.yearPicker
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