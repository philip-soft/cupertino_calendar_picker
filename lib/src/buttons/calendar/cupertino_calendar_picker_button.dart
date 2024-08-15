import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef CupertinoCalendarFormatterCallback = String Function(DateTime dateTime);

/// A customizable Cupertino-style button that displays a calendar picker
/// when tapped.
class CupertinoCalendarPickerButton extends StatefulWidget {
  const CupertinoCalendarPickerButton({
    required this.minimumDateTime,
    required this.maximumDateTime,
    this.selectedDateTime,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onDateTimeChanged,
    this.currentDateTime,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.buttonDecoration,
    this.mode = CupertinoCalendarPickerMode.date,
    this.formatter,
  });

  /// Specifies the earliest date that can be selected by the user
  /// in the calendar picker.
  final DateTime minimumDateTime;

  /// Specifies the latest date that can be selected by the user in the
  /// calendar picker.
  final DateTime maximumDateTime;

  /// A callback function triggered when the user selects a date
  /// from the calendar picker.
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// The date currently selected and displayed by the calendar picker.
  final DateTime? selectedDateTime;

  /// The [DateTime] value representing today's date, which will be
  /// highlighted within the calendar.
  final DateTime? currentDateTime;

  /// A callback function triggered when the user navigates to a different
  /// month in the calendar picker. It provides the newly displayed [DateTime]
  /// for the first day of the month.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Defines the spacing on the left and right sides of the calendar widget.
  final double horizontalSpacing = 15.0;

  /// Defines the spacing on the top and bottom sides of the calendar widget.
  final double verticalSpacing = 15.0;

  /// The position offset applied to the widget from its top and bottom edges
  /// relative to its [widgetRenderBox] location. This is typically used to
  /// adjust the widget's placement on the screen.
  final Offset offset;

  /// The color of the modal barrier that appears behind the calendar when it
  /// is displayed. This provides a dimmed background to focus
  /// attention on the calendar.
  final Color barrierColor;

  /// The primary color used within the calendar widget.
  /// This color is applied to key elements such as selected dates, highlights,
  /// or the main theme of the calendar.
  final Color mainColor;

  /// The decoration for the main container of the calendar widget.
  final PickerContainerDecoration? containerDecoration;

  /// The decoration applied to the weekday headers (e.g., Mon, Tue, etc.)
  /// in the calendar.
  final CalendarWeekdayDecoration? weekdayDecoration;

  /// The decoration used for the month picker component of the calendar.
  final CalendarMonthPickerDecoration? monthPickerDecoration;

  /// The decoration for the header of the calendar.
  final CalendarHeaderDecoration? headerDecoration;

  /// The decoration for the button.
  final PickerButtonDecoration? buttonDecoration;

  /// The mode of the calendar picker, determining whether it operates in [date]
  /// or [dateTime] selection mode.
  final CupertinoCalendarPickerMode mode;

  /// The custom formatter of the calendar picker button.
  final CupertinoCalendarFormatterCallback? formatter;

  @override
  State<CupertinoCalendarPickerButton> createState() =>
      _CupertinoCalendarPickerButtonState();
}

class _CupertinoCalendarPickerButtonState
    extends State<CupertinoCalendarPickerButton> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDateTime ?? DateTime.now();
  }

  @override
  void didUpdateWidget(CupertinoCalendarPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDateTime != _selectedDateTime) {
      _selectedDateTime = widget.selectedDateTime ?? DateTime.now();
    }
  }

  void _onDateChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
      widget.onDateTimeChanged?.call(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    late String formattedString;

    final CupertinoCalendarFormatterCallback? formatter = widget.formatter;

    if (formatter != null) {
      formattedString = formatter(_selectedDateTime);
    } else {
      final int day = _selectedDateTime.day;
      final int month = _selectedDateTime.month;
      final int year = _selectedDateTime.year;
      final TimeOfDay time = TimeOfDay(
        hour: _selectedDateTime.hour,
        minute: _selectedDateTime.minute,
      );

      String timeString = '';
      if (widget.mode == CupertinoCalendarPickerMode.dateTime) {
        timeString = ' ';
        timeString += time.format(context);
      }

      final CupertinoLocalizations localization =
          CupertinoLocalizations.of(context);
      final String fullMonthString = localization.datePickerMonth(month);
      final String dayString = localization.datePickerDayOfMonth(day);
      final String monthString = fullMonthString.substring(0, 3);
      final String yearString = localization.datePickerYear(year);

      formattedString = '$monthString $dayString, $yearString$timeString';
    }

    return CupertinoPickerButton<DateTime?>(
      title: formattedString,
      mainColor: widget.mainColor,
      showPickerFunction: (RenderBox? renderBox) => showCupertinoCalendarPicker(
        context,
        widgetRenderBox: renderBox,
        minimumDate: widget.minimumDateTime,
        initialDate: _selectedDateTime,
        currentDate: widget.currentDateTime,
        mainColor: widget.mainColor,
        headerDecoration: widget.headerDecoration,
        containerDecoration: widget.containerDecoration,
        monthPickerDecoration: widget.monthPickerDecoration,
        weekdayDecoration: widget.weekdayDecoration,
        offset: widget.offset,
        maximumDate: widget.maximumDateTime,
        barrierColor: widget.barrierColor,
        verticalSpacing: widget.verticalSpacing,
        horizontalSpacing: widget.horizontalSpacing,
        onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
        mode: widget.mode,
        onDateChanged: _onDateChanged,
      ),
    );
  }
}
