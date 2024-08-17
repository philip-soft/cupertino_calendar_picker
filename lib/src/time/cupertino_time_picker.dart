import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTimePicker extends StatelessWidget {
  const CupertinoTimePicker({
    required this.initialTime,
    required this.minimumTime,
    required this.maximumTime,
    required this.onTimeChanged,
    required this.minuteInterval,
    super.key,
  });

  final TimeOfDay initialTime;
  final TimeOfDay minimumTime;
  final TimeOfDay maximumTime;
  final ValueChanged<DateTime> onTimeChanged;
  final int minuteInterval;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: timePickerWheelHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          child: CustomCupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialTime.toNowDateTime(),
            minimumDate: minimumTime.toNowDateTime(),
            maximumDate: maximumTime.toNowDateTime(),
            onDateTimeChanged: onTimeChanged,
            use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
            minuteInterval: minuteInterval,
          ),
        ),
      ),
    );
  }
}
