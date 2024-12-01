// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoTimePicker extends StatelessWidget {
  const CupertinoTimePicker({
    required this.initialTime,
    required this.minimumTime,
    required this.maximumTime,
    required this.onTimeChanged,
    required this.minuteInterval,
    this.use24hFormat,
    super.key,
  });

  final TimeOfDay initialTime;
  final TimeOfDay minimumTime;
  final TimeOfDay maximumTime;
  final ValueChanged<DateTime> onTimeChanged;
  final int minuteInterval;
  final bool? use24hFormat;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: timePickerWheelHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          child: CupertinoTimePickerWheel(
            initialDateTime: initialTime.toNowDateTime(),
            minimumDateTime: minimumTime.toNowDateTime(),
            maximumDateTime: maximumTime.toNowDateTime(),
            onTimeChanged: onTimeChanged,
            minuteInterval: minuteInterval,
            use24hFormat: use24hFormat,
          ),
        ),
      ),
    );
  }
}
