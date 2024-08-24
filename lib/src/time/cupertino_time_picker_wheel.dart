// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTimePickerWheel extends StatelessWidget {
  const CupertinoTimePickerWheel({
    required this.initialDateTime,
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.onTimeChanged,
    required this.minuteInterval,
    this.pickerKey,
    super.key,
  });

  final GlobalKey<CustomCupertinoDatePickerDateTimeState>? pickerKey;
  final DateTime initialDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
  final ValueChanged<DateTime> onTimeChanged;
  final int minuteInterval;

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoDatePicker(
      key: pickerKey,
      mode: CupertinoDatePickerMode.time,
      initialDateTime: initialDateTime,
      minimumDate: minimumDateTime,
      maximumDate: maximumDateTime,
      onDateTimeChanged: onTimeChanged,
      use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      minuteInterval: minuteInterval,
    );
  }
}
