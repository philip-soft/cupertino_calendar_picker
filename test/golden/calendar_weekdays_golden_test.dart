// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

import 'support/golden_harness.dart';

void main() {
  Widget buildScenario(Brightness brightness) {
    return goldenApp(
      brightness: brightness,
      child: SizedBox(
        width: 320.0,
        child: Builder(
          builder: (BuildContext context) {
            return CalendarWeekdays(
              decoration: CalendarWeekdayDecoration.withDynamicColor(context),
              firstDayOfWeekIndex: 0,
            );
          },
        ),
      ),
    );
  }

  goldenTest(
    'CalendarWeekdays renders weekday labels in light and dark themes',
    fileName: 'calendar_weekdays',
    builder: () => lightDarkGroup(buildScenario),
  );
}
