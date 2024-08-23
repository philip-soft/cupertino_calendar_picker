import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef CupertinoCalendarFormatter = String Function(DateTime dateTime);

/// A customizable Cupertino-style button that displays a calendar picker
/// when tapped.
class CupertinoCalendarPickerButton extends StatefulWidget {
  const CupertinoCalendarPickerButton({
    required this.minimumDateTime,
    required this.maximumDateTime,
    this.initialDateTime,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onDateTimeChanged,
    this.onDateSelected,
    this.currentDateTime,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.buttonDecoration,
    this.footerDecoration,
    this.timeLabel,
    this.mode = CupertinoCalendarMode.date,
    this.formatter,
    this.minuteInterval = 1,
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

  /// A callback that is triggered when the user selects a date in the calendar.
  final ValueChanged<DateTime>? onDateSelected;

  /// The initially selected [DateTime] that the calendar should display.
  ///
  /// This date is highlighted in the picker and the default date when the picker
  /// is first displayed.
  final DateTime? initialDateTime;

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

  /// The decoration for the footer of the calendar.
  ///
  /// Applied for the [dateTime] mode only.
  final CalendarFooterDecoration? footerDecoration;

  /// The mode of the calendar picker, determining whether it operates in [date]
  /// or [dateTime] selection mode.
  final CupertinoCalendarMode mode;

  /// The custom formatter of the calendar picker button.
  final CupertinoCalendarFormatter? formatter;

  /// An optional label to be displayed when the calendar is in a mode that
  /// includes time selection.
  ///
  /// This label typically indicates what the selected time is for or provides
  /// additional context.
  final String? timeLabel;

  /// The interval of minutes that the time picker should allow, applicable
  /// when the calendar is in a mode that includes time selection.
  ///
  /// The default value is 1 minute, meaning the user can select any minute of the hour.
  final int minuteInterval;

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
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  @override
  void didUpdateWidget(CupertinoCalendarPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDateTime != _selectedDateTime) {
      _selectedDateTime = widget.initialDateTime ?? DateTime.now();
    }
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
      widget.onDateTimeChanged?.call(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    late String formattedString;

    final CupertinoCalendarFormatter? formatter = widget.formatter;

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
      if (widget.mode == CupertinoCalendarMode.dateTime) {
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
      decoration: widget.buttonDecoration,
      showPickerFunction: (RenderBox? renderBox) => showCupertinoCalendarPicker(
        context,
        widgetRenderBox: renderBox,
        minimumDateTime: widget.minimumDateTime,
        initialDateTime: _selectedDateTime,
        currentDateTime: widget.currentDateTime,
        mainColor: widget.mainColor,
        headerDecoration: widget.headerDecoration,
        containerDecoration: widget.containerDecoration,
        monthPickerDecoration: widget.monthPickerDecoration,
        weekdayDecoration: widget.weekdayDecoration,
        footerDecoration: widget.footerDecoration,
        offset: widget.offset,
        maximumDateTime: widget.maximumDateTime,
        barrierColor: widget.barrierColor,
        verticalSpacing: widget.verticalSpacing,
        horizontalSpacing: widget.horizontalSpacing,
        onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
        mode: widget.mode,
        onDateTimeChanged: _onDateTimeChanged,
        onDateSelected: widget.onDateSelected,
        timeLabel: widget.timeLabel,
        minuteInterval: widget.minuteInterval,
      ),
    );
  }
}
