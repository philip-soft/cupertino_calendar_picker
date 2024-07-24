import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendar extends StatefulWidget {
  CupertinoCalendar({
    required DateTime minimumDate,
    required DateTime maximumDate,
    required this.mainColor,
    this.onDateChanged,
    this.onDateSelected,
    DateTime? initialDate,
    DateTime? currentDate,
    this.onDisplayedMonthChanged,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
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

  final DateTime initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime currentDate;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? headerDecoration;
  final Color mainColor;

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
    _selectedDate = initialDate;
  }

  void _handleCalendarDateChange(DateTime date) {
    final int year = date.year;
    final int month = date.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    int selectedDay = _selectedDate.day;

    if (daysInMonth < selectedDay) {
      selectedDay = daysInMonth;
    }
    DateTime newDate = date.copyWith(day: selectedDay);

    final bool exceedMinimumDate = newDate.isBefore(widget.minimumDate);
    final bool exceedMaximumDate = newDate.isAfter(widget.maximumDate);
    if (exceedMinimumDate) {
      newDate = widget.minimumDate;
    } else if (exceedMaximumDate) {
      newDate = widget.maximumDate;
    }
    _handleCalendarMonthChange(newDate);
    _handleCalendarDayChange(newDate);
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

  void _onChanged(DateTime date) {
    _handleCalendarDayChange(date);
    widget.onDateSelected?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarPicker(
      initialMonth: _currentlyDisplayedMonthDate,
      currentDate: widget.currentDate,
      minimumDate: widget.minimumDate,
      maximumDate: widget.maximumDate,
      selectedDate: _selectedDate,
      onChanged: _onChanged,
      onDisplayedMonthChanged: _handleCalendarMonthChange,
      onYearPickerChanged: _handleCalendarDateChange,
      mainColor: widget.mainColor,
      weekdayDecoration: widget.weekdayDecoration ??
          CalendarWeekdayDecoration.withDynamicColor(context),
      monthPickerDecoration: widget.monthPickerDecoration ??
          CalendarMonthPickerDecoration.withDynamicColor(
            context,
            mainColor: widget.mainColor,
          ),
      headerDecoration: widget.headerDecoration ??
          CalendarHeaderDecoration.withDynamicColor(
            context,
            mainColor: widget.mainColor,
          ),
    );
  }
}
