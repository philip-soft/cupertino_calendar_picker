// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A button widget that triggers a Cupertino-style time picker when pressed.
class CupertinoTimePickerButton extends StatefulWidget {
  /// Creates a `CupertinoTimePickerButton` widget.
  const CupertinoTimePickerButton({
    this.initialTime,
    this.minimumTime,
    this.maximumTime,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    super.key,
    this.onTimeChanged,
    this.containerDecoration,
    this.mainColor = CupertinoColors.systemRed,
    this.buttonDecoration,
    this.minuteInterval = 1,
    this.onPressed,
  });

  /// The minimum selectable [TimeOfDay].
  ///
  /// This sets the earliest time that can be selected by the user. If `null`,
  /// the picker will allow any time to be chosen.
  final TimeOfDay? minimumTime;

  /// The maximum selectable [TimeOfDay].
  ///
  /// This sets the latest time that can be selected by the user. If `null`,
  /// the picker will allow any time to be chosen.
  final TimeOfDay? maximumTime;

  /// Called when the user selects a time in the picker.
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// The initial [TimeOfDay] that the picker should display. If `null`,
  /// `TimeOfDay.now()` will be used instead.
  final TimeOfDay? initialTime;

  /// The spacing from the left and right sides of the screen.
  /// Default is [15.0].
  final double horizontalSpacing = 15.0;

  /// The spacing from the top and bottom sides of the screen.
  /// Default is [15.0].
  final double verticalSpacing = 15.0;

  /// The offset from the top/bottom of the [widgetRenderBox] location.
  ///
  /// This controls the vertical position of the picker relative to
  /// the [widgetRenderBox].
  /// Default is `Offset(0.0, 10.0)`.
  final Offset offset;

  /// The color of the barrier that appears behind the picker.
  ///
  /// This color is applied to the background overlay that appears
  /// when the picker is displayed. The default is [Colors.transparent].
  final Color barrierColor;

  /// Custom decoration for the picker container.
  final PickerContainerDecoration? containerDecoration;

  /// Custom decoration for the picker button.
  final PickerButtonDecoration? buttonDecoration;

  ///   The interval of minutes that the time picker should allow.
  ///   The default value is 1 minute, meaning the user can select any minute of the hour.
  final int minuteInterval;

  /// The primary color used within the button widget.
  final Color mainColor;

  /// A callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  @override
  State<CupertinoTimePickerButton> createState() =>
      _CupertinoTimePickerButtonState();
}

class _CupertinoTimePickerButtonState extends State<CupertinoTimePickerButton> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  @override
  void didUpdateWidget(CupertinoTimePickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime ?? TimeOfDay.now();
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
      decoration: widget.buttonDecoration,
      mainColor: widget.mainColor,
      onPressed: widget.onPressed,
      showPickerFunction: (RenderBox? renderBox) => showCupertinoTimePicker(
        context,
        widgetRenderBox: renderBox,
        initialTime: _selectedTime,
        minimumTime: widget.minimumTime,
        maximumTime: widget.maximumTime,
        containerDecoration: widget.containerDecoration,
        offset: widget.offset,
        barrierColor: widget.barrierColor,
        verticalSpacing: widget.verticalSpacing,
        horizontalSpacing: widget.horizontalSpacing,
        onTimeChanged: _onTimeChanged,
        minuteInterval: widget.minuteInterval,
      ),
    );
  }
}
