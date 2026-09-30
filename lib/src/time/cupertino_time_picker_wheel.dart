// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

class CupertinoTimePickerWheel extends StatelessWidget {
  const CupertinoTimePickerWheel({
    required this.initialDateTime,
    required this.onTimeChanged,
    required this.minuteInterval,
    this.minimumDateTime,
    this.maximumDateTime,
    this.use24hFormat,
    this.pickerKey,
    super.key,
  });

  final GlobalKey<CustomCupertinoDatePickerDateTimeState>? pickerKey;
  final DateTime initialDateTime;
  final DateTime? minimumDateTime;
  final DateTime? maximumDateTime;
  final ValueChanged<DateTime> onTimeChanged;
  final int minuteInterval;
  final bool? use24hFormat;

  /// The wheel only displays multiples of [minuteInterval], so the initial
  /// time is rounded down to one of them.
  DateTime get _alignedInitialDateTime {
    final int minute = initialDateTime.minute;
    return initialDateTime.truncateToMinutes(
      newMinute: minute - minute % minuteInterval,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoDatePicker(
      key: pickerKey,
      mode: CupertinoDatePickerMode.time,
      initialDateTime: _alignedInitialDateTime,
      minimumDate: minimumDateTime,
      maximumDate: maximumDateTime,
      onDateTimeChanged: onTimeChanged,
      use24hFormat: use24hFormat ?? context.alwaysUse24hFormat,
      minuteInterval: minuteInterval,
    );
  }
}
