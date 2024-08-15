import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTimePickerButton extends StatefulWidget {
  const CupertinoTimePickerButton({
    this.selectedTime,
    this.minimumTime,
    this.maximumTime,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onTimeChanged,
    this.containerDecoration,
    this.decoration,
  });

  /// The minimum selectable [TimeOfDay].
  final TimeOfDay? minimumTime;

  /// The maximum selectable [TimeOfDay].
  final TimeOfDay? maximumTime;

  /// Called when the user selects a time in the picker.
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// The selected [TimeOfDay] that the picker should display.
  final TimeOfDay? selectedTime;

  /// The spacing from left and right side of the screen.
  final double horizontalSpacing = 15.0;

  /// The spacing from top and bottom side of the screen.
  final double verticalSpacing = 15.0;

  /// The offset from top/bottom of the [widgetRenderBox] location.
  final Offset offset;
  final Color barrierColor;
  final Color mainColor;
  final PickerContainerDecoration? containerDecoration;
  final PickerButtonDecoration? decoration;

  @override
  State<CupertinoTimePickerButton> createState() =>
      _CupertinoTimePickerButtonState();
}

class _CupertinoTimePickerButtonState extends State<CupertinoTimePickerButton> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime ?? TimeOfDay.now();
  }

  @override
  void didUpdateWidget(CupertinoTimePickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedTime != _selectedTime) {
      _selectedTime = widget.selectedTime ?? TimeOfDay.now();
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
        initialTime: _selectedTime,
        minimumTime: widget.minimumTime,
        maximumTime: widget.maximumTime,
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
