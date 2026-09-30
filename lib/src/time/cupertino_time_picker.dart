// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

class CupertinoTimePicker extends StatelessWidget {
  const CupertinoTimePicker({
    required this.initialTime,
    required this.onTimeChanged,
    required this.minuteInterval,
    required this.use24hFormat,
    this.minimumTime,
    this.maximumTime,
    super.key,
  });

  final TimeOfDay initialTime;

  /// The earliest selectable time. `null` means no limit.
  final TimeOfDay? minimumTime;

  /// The latest selectable time. `null` means no limit.
  final TimeOfDay? maximumTime;
  final ValueChanged<DateTime> onTimeChanged;
  final int minuteInterval;
  final bool use24hFormat;

  @override
  Widget build(BuildContext context) {
    // All times share one date so that they are comparable with each other.
    final DateTime today = DateUtils.dateOnly(DateTime.now());

    return Center(
      child: SizedBox(
        height: timePickerWheelHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: timePickerHorizontalPadding,
          ),
          child: CupertinoTimePickerWheel(
            initialDateTime: initialTime.onDate(today),
            minimumDateTime: minimumTime?.onDate(today),
            maximumDateTime: maximumTime?.onDate(today),
            onTimeChanged: onTimeChanged,
            minuteInterval: minuteInterval,
            use24hFormat: use24hFormat,
          ),
        ),
      ),
    );
  }
}
