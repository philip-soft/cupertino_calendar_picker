import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTimeOverlay extends StatefulWidget {
  CupertinoTimeOverlay({
    required this.widgetRenderBox,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    TimeOfDay? initialTime,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    super.key,
    this.containerDecoration,
    this.onTimeChanged,
  })  : initialTime = initialTime ?? TimeOfDay.now(),
        minimumTime = minimumTime ?? const TimeOfDay(hour: 0, minute: -1),
        maximumTime = maximumTime ?? const TimeOfDay(hour: 23, minute: 60) {
    assert(
      !this.maximumTime.isBefore(this.minimumTime),
      'maximumTime ${this.maximumTime} must be on or after minimumTime ${this.minimumTime}.',
    );
    assert(
      !this.initialTime.isBefore(this.minimumTime),
      'initialTime ${this.initialTime} must be on or after minimumTime ${this.minimumTime}.',
    );
    assert(
      !this.initialTime.isAfter(this.maximumTime),
      'initialTime ${this.initialTime} must be on or before maximumTime ${this.maximumTime}.',
    );
  }

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final TimeOfDay initialTime;
  final TimeOfDay minimumTime;
  final TimeOfDay maximumTime;
  final PickerContainerDecoration? containerDecoration;
  final Color mainColor;
  final ValueChanged<TimeOfDay>? onTimeChanged;

  @override
  State<CupertinoTimeOverlay> createState() => _CupertinoTimeOverlayState();
}

class _CupertinoTimeOverlayState extends State<CupertinoTimeOverlay> {
  AnimationController? _controller;
  TimeOfDay? _selectedTime;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    _controller?.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop(_selectedTime);
    }
  }

  void _onDateTimeChanged(DateTime dateTime) {
    _selectedTime = TimeOfDay.fromDateTime(dateTime);
    widget.onTimeChanged?.call(_selectedTime!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPickerOverlay(
      onInitialized: _onInitialized,
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: timePickerHeight,
      width: timePickerWidth,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      outsideTapDismissable: true,
      child: Center(
        child: SizedBox(
          height: timePickerWheelHeight,
          child: CustomCupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: widget.initialTime.toNowDateTime(),
            minimumDate: widget.minimumTime.toNowDateTime(),
            maximumDate: widget.maximumTime.toNowDateTime(),
            onDateTimeChanged: _onDateTimeChanged,
            use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
