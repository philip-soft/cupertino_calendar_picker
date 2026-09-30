// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;

import 'support/golden_harness.dart';

void main() {
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15, 14, 30);
  const TimeOfDay fixedTime = TimeOfDay(hour: 14, minute: 30);

  Widget buildCalendarButton(
    Brightness brightness, {
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  }) {
    return goldenApp(
      brightness: brightness,
      child: CupertinoCalendarPickerButton(
        minimumDateTime: minimum,
        maximumDateTime: maximum,
        initialDateTime: fixedDate,
        mode: mode,
        use24hFormat: false,
      ),
    );
  }

  goldenTest(
    'CupertinoCalendarPickerButton renders date mode in light and dark themes',
    fileName: 'cupertino_calendar_picker_button_date',
    builder: () => lightDarkGroup(buildCalendarButton),
  );

  goldenTest(
    'CupertinoCalendarPickerButton renders dateTime mode in light and dark themes',
    fileName: 'cupertino_calendar_picker_button_date_time',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildCalendarButton(brightness, mode: CupertinoCalendarMode.dateTime),
    ),
  );

  goldenTest(
    'CupertinoTimePickerButton renders in light and dark themes',
    fileName: 'cupertino_time_picker_button',
    builder: () => lightDarkGroup(
      (Brightness brightness) => goldenApp(
        brightness: brightness,
        child: const CupertinoTimePickerButton(
          initialTime: fixedTime,
          use24hFormat: false,
        ),
      ),
    ),
  );
}
