import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerButton extends StatefulWidget {
  const TimePickerButton({
    required this.selectedTime,
    required this.minimumDate,
    required this.maximumDate,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onTimeChanged,
    this.currentDate,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
  });

  /// The minimum selectable [DateTime].
  final DateTime minimumDate;

  /// The maximum selectable [DateTime].
  final DateTime maximumDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// The selected [DateTime] that the calendar should display.
  final TimeOfDay selectedTime;

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

  @override
  State<TimePickerButton> createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
  }

  @override
  void didUpdateWidget(TimePickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedTime != _selectedTime) {
      _selectedTime = widget.selectedTime;
    }
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
      widget.onTimeChanged?.call(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPickerButton<TimeOfDay?>(
      title: _selectedTime.format(context),
      mainColor: widget.mainColor,
      showPickerFunction: (RenderBox? renderBox) => showCupertinoTimePicker(
        context,
        widgetRenderBox: renderBox,
        mainColor: widget.mainColor,
        containerDecoration: widget.containerDecoration,
        offset: widget.offset,
        barrierColor: widget.barrierColor,
        verticalSpacing: widget.verticalSpacing,
        horizontalSpacing: widget.horizontalSpacing,
        onTimeChanged: _onTimeChanged,
      ),
    );
  }
}
