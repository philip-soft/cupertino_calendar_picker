import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPickerButton extends StatefulWidget {
  const CalendarPickerButton({
    required this.selectedDate,
    required this.minimumDate,
    required this.maximumDate,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onDateChanged,
    this.currentDate,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.onDateSelected,
  });

  /// The minimum selectable [DateTime].
  final DateTime minimumDate;

  /// The maximum selectable [DateTime].
  final DateTime maximumDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime>? onDateChanged;

  /// The selected [DateTime] that the calendar should display.
  final DateTime selectedDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime? currentDate;

  /// Called when the user navigates to a new month in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The spacing from left and right side of the screen.
  final double horizontalSpacing = 15.0;

  /// The spacing from top and bottom side of the screen.
  final double verticalSpacing = 15.0;

  /// The offset from top/bottom of the [widgetRenderBox] location.
  final Offset offset;
  final Color barrierColor;
  final Color mainColor;
  final CalendarContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? headerDecoration;
  final ValueChanged<DateTime?>? onDateSelected;

  @override
  State<CalendarPickerButton> createState() => _CalendarPickerButtonState();
}

class _CalendarPickerButtonState extends State<CalendarPickerButton> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(CalendarPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDate != _selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      widget.onDateChanged?.call(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final int day = _selectedDate.day;
    final int month = _selectedDate.month;
    final int year = _selectedDate.year;
    final String fullMonthString = localization.datePickerMonth(month);
    final String dayString = localization.datePickerDayOfMonth(day);
    final String monthString = fullMonthString.substring(0, 3);
    final String yearString = localization.datePickerYear(year);

    return CupertinoPickerButton<DateTime?>(
      title: '$monthString $dayString, $yearString',
      mainColor: widget.mainColor,
      showPickerFunction: (RenderBox? renderBox) => showCupertinoCalendarPicker(
        context,
        widgetRenderBox: renderBox,
        minimumDate: widget.minimumDate,
        initialDate: _selectedDate,
        currentDate: widget.currentDate,
        mainColor: widget.mainColor,
        headerDecoration: widget.headerDecoration,
        containerDecoration: widget.containerDecoration,
        monthPickerDecoration: widget.monthPickerDecoration,
        weekdayDecoration: widget.weekdayDecoration,
        offset: widget.offset,
        maximumDate: widget.maximumDate,
        barrierColor: widget.barrierColor,
        verticalSpacing: widget.verticalSpacing,
        horizontalSpacing: widget.horizontalSpacing,
        onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
        onDateChanged: _onDateChanged,
      ),
    );
  }
}
