import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.widgetRenderBox,
    required this.minimumDate,
    required this.maximumDate,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    required this.dismissBehavior,
    required this.mode,
    this.onDateChanged,
    this.onDateSelected,
    this.currentDate,
    this.initialDate,
    super.key,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final DateTime? initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final PickerContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? headerDecoration;
  final CalendarDismissBehavior dismissBehavior;
  final Color mainColor;
  final CupertinoCalendarPickerMode mode;

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  AnimationController? _controller;
  DateTime? _selectedDate;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    _controller?.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop(_selectedDate);
    }
  }

  void _closeOverlay() {
    if (_controller != null) {
      final bool isReverseInProgress =
          _controller!.status == AnimationStatus.reverse;
      if (!isReverseInProgress) {
        _controller?.reverse(from: 0.75);
      }
    }
  }

  void _onDateChanged(DateTime date) {
    _selectedDate = date;
    widget.onDateChanged?.call(date);
  }

  void _onDateSelected(DateTime date) {
    _selectedDate = date;
    widget.onDateSelected?.call(date);

    if (widget.dismissBehavior.hasDateSelectDismiss) {
      _closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = switch (widget.mode) {
      CupertinoCalendarPickerMode.date => calendarDatePickerHeight,
      CupertinoCalendarPickerMode.dateTime => calendarDateTimePickerHeight,
    };

    return CupertinoPickerOverlay(
      onInitialized: _onInitialized,
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: height,
      width: calendarWidth,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      outsideTapDismissable: widget.dismissBehavior.hasOusideTapDismiss,
      child: CupertinoCalendar(
        weekdayDecoration: widget.weekdayDecoration,
        monthPickerDecoration: widget.monthPickerDecoration,
        headerDecoration: widget.headerDecoration,
        minimumDate: widget.minimumDate,
        initialDate: widget.initialDate,
        currentDate: widget.currentDate,
        maximumDate: widget.maximumDate,
        onDateChanged: _onDateChanged,
        onDateSelected: _onDateSelected,
        onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
        mainColor: widget.mainColor,
        mode: widget.mode,
        type: CupertinoCalendarType.compact,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
