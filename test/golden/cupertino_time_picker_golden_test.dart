// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;

import 'support/golden_harness.dart';

void main() {
  const TimeOfDay minimum = TimeOfDay(hour: 0, minute: 0);
  const TimeOfDay maximum = TimeOfDay(hour: 23, minute: 59);
  const TimeOfDay initial = TimeOfDay(hour: 14, minute: 30);

  Widget buildScenario(Brightness brightness, {bool use24hFormat = false}) {
    return goldenApp(
      brightness: brightness,
      child: SizedBox(
        width: 320.0,
        child: CupertinoTimePicker(
          initialTime: initial,
          minimumTime: minimum,
          maximumTime: maximum,
          onTimeChanged: (_) {},
          minuteInterval: 1,
          use24hFormat: use24hFormat,
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoTimePicker renders 12h wheel in light and dark themes',
    fileName: 'cupertino_time_picker',
    builder: () => lightDarkGroup(buildScenario),
  );

  goldenTest(
    'CupertinoTimePicker renders 24h wheel in light and dark themes',
    fileName: 'cupertino_time_picker_24h',
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildScenario(brightness, use24hFormat: true),
    ),
  );
}
