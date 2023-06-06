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
    required this.weekdayDecoration,
    required this.dayDecoration,
    required this.todayDecoration,
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

  final ValueChanged<DateTime> onDatePickerChanged;
  final CalendarWeekdayDecoration weekdayDecoration;
  final CalendarDayDecoration dayDecoration;
  final CalendarDayDecoration todayDecoration;

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  late PageController _monthPageController;
  late AnimationController _animationController;
  late bool _isYearPickerShowed;

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
      duration: const Duration(milliseconds: 500),
    );
    _isYearPickerShowed = _animationController.isCompleted;
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

  @override
  void dispose() {
    _monthPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDateSelection(DateTime selectedDate) {
    widget.onChanged(selectedDate);
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

  List<Widget> _weekdays(MaterialLocalizations localizations) {
    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      localizations,
    );
    final intl.DateFormat weekdayFormat = intl.DateFormat.E();
    final DateTime firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    return List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final String weekday = weekdayFormat.format(
        firstDayOfWeekDate.add(Duration(days: index)),
      );
      return CalendarWeekday(
        weekday: weekday.toUpperCase(),
        decoration: widget.weekdayDecoration,
      );
    });
  }

  void _toggleYearPicker(bool shouldShowYearPicker) {
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

    final intl.DateFormat dateFormat = intl.DateFormat('MMMM yyyy');
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Color enabledColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemRed,
        darkColor: CupertinoColors.systemRed.darkColor,
      ),
      context,
    );
    final Color disabledColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.opaqueSeparator,
        darkColor: CupertinoColors.opaqueSeparator.darkColor,
      ),
      context,
    );

    final Color forwardButtonColor =
        _isDisplayingLastMonth ? disabledColor : enabledColor;
    final Color backwardButtonColor =
        _isDisplayingFirstMonth ? disabledColor : enabledColor;

    return Column(
      children: <Widget>[
        const SizedBox(height: 4.0),
        CalendarHeader(
          currentMonth: _currentMonth,
          onNextMonthIconTapped: _handleNextMonth,
          onPreviousMonthIconTapped: _handlePreviousMonth,
          onYearPickerStateChanged: _toggleYearPicker,
        ),
        Expanded(
          child: AnimatedCrossFade(
            crossFadeState: _isYearPickerShowed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            firstChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _weekdays(localizations),
                  ),
                ),
                const SizedBox(height: 3.0),
                CalendarMonthPicker(
                  monthPageController: _monthPageController,
                  onMonthPageChanged: _handleMonthPageChanged,
                  currentDate: widget.currentDate,
                  displayedMonth: _currentMonth,
                  minimumDate: widget.minimumDate,
                  maximumDate: widget.maximumDate,
                  selectedDate: widget.selectedDate,
                  onChanged: widget.onChanged,
                  dayDecoration: widget.dayDecoration,
                  todayDecoration: widget.todayDecoration,
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
            layoutBuilder: (Widget topChild, Key topChildKey,
                Widget bottomChild, Key bottomChildKey) {
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
