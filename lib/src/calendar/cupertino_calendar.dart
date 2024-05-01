import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendar extends StatefulWidget {
  /// Creates a cupertino calendar picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// [maximumDate] must be after or equal to [minimumDate].
  ///
  /// [initialDate] must be between [minimumDate] and [maximumDate] or equal to
  /// one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  CupertinoCalendar({
    required DateTime minimumDate,
    required DateTime maximumDate,
    required this.scaleAlignment,
    required this.onInitialized,
    this.onDateChanged,
    DateTime? initialDate,
    DateTime? currentDate,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.calendarHeaderDecoration,
    super.key,
  })  : initialDate = DateUtils.dateOnly(initialDate ?? DateTime.now()),
        minimumDate = DateUtils.dateOnly(minimumDate),
        maximumDate = DateUtils.dateOnly(maximumDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.maximumDate.isBefore(this.minimumDate),
      'maximumDate ${this.maximumDate} must be on or after minimumDate ${this.minimumDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.minimumDate),
      'initialDate ${this.initialDate} must be on or after minimumDate ${this.minimumDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.maximumDate),
      'initialDate ${this.initialDate} must be on or before maximumDate ${this.maximumDate}.',
    );
  }

  /// The initially selected [DateTime] that the calendar should display.
  final DateTime initialDate;

  /// The minimum selectable [DateTime].
  final DateTime minimumDate;

  /// The maximum selectable [DateTime].
  final DateTime maximumDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime>? onDateChanged;

  /// Called when the user navigates to a new month in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  final CalendarContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? calendarHeaderDecoration;
  final Alignment scaleAlignment;
  final void Function(AnimationController controller) onInitialized;

  @override
  State<CupertinoCalendar> createState() => _CupertinoCalendarState();
}

class _CupertinoCalendarState extends State<CupertinoCalendar> {
  late DateTime _currentlyDisplayedMonthDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeInitialDate();
  }

  @override
  void didUpdateWidget(CupertinoCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      _initializeInitialDate();
    }
  }

  void _initializeInitialDate() {
    final DateTime initialDate = widget.initialDate;
    _currentlyDisplayedMonthDate = PackageDateUtils.monthDateOnly(initialDate);
    _selectedDate = DateUtils.dateOnly(initialDate);
  }

  void _handleCalendarDateChange(DateTime date) {
    DateTime newDate = date;

    final bool exceedMinimumDate = newDate.isBefore(widget.minimumDate);
    final bool exceedMaximumDate = newDate.isAfter(widget.maximumDate);
    if (exceedMinimumDate) {
      newDate = widget.minimumDate;
    } else if (exceedMaximumDate) {
      newDate = widget.maximumDate;
    }
    _handleCalendarMonthChange(newDate);
  }

  void _handleCalendarMonthChange(DateTime newMonthDate) {
    setState(() {
      final DateTime displayedMonth = PackageDateUtils.monthDateOnly(
        _currentlyDisplayedMonthDate,
      );
      final bool monthChanged = !DateUtils.isSameMonth(
        displayedMonth,
        newMonthDate,
      );
      if (monthChanged) {
        _currentlyDisplayedMonthDate = PackageDateUtils.monthDateOnly(
          newMonthDate,
        );
        widget.onDisplayedMonthChanged?.call(_currentlyDisplayedMonthDate);
      }
    });
  }

  void _handleCalendarDayChange(DateTime date) {
    setState(() {
      _selectedDate = date;
      widget.onDateChanged?.call(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarContainer(
      onInitialized: widget.onInitialized,
      scaleAlignment: widget.scaleAlignment,
      decoration: widget.containerDecoration ??
          CalendarContainerDecoration.withDynamicColor(context),
      child: CalendarPicker(
        initialMonth: _currentlyDisplayedMonthDate,
        currentDate: widget.currentDate,
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
        selectedDate: _selectedDate,
        onChanged: _handleCalendarDayChange,
        onDisplayedMonthChanged: _handleCalendarMonthChange,
        onYearPickerChanged: _handleCalendarDateChange,
        weekdayDecoration: widget.weekdayDecoration ??
            CalendarWeekdayDecoration.withDynamicColor(context),
        monthPickerDecoration: widget.monthPickerDecoration ??
            CalendarMonthPickerDecoration.withDynamicColor(context),
        calendarHeaderDecoration: widget.calendarHeaderDecoration ??
            CalendarHeaderDecoration.withDynamicColor(context),
      ),
    );
  }
}
