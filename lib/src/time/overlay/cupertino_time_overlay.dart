// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoTimeOverlay extends StatefulWidget {
  CupertinoTimeOverlay({
    required this.widgetRenderBox,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.minuteInterval,
    this.use24hFormat,
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
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final int minuteInterval;
  final bool? use24hFormat;

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
      child: CupertinoTimePicker(
        initialTime: widget.initialTime,
        minimumTime: widget.minimumTime,
        maximumTime: widget.maximumTime,
        onTimeChanged: _onDateTimeChanged,
        minuteInterval: widget.minuteInterval,
        use24hFormat: widget.use24hFormat,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
