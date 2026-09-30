// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

import 'support/golden_harness.dart';

void main() {
  final DateTime fixedMonth = DateTime.utc(2024, 6);

  Widget buildScenario(
    Brightness brightness, {
    bool backwardEnabled = true,
    bool forwardEnabled = true,
  }) {
    return goldenApp(
      brightness: brightness,
      child: SizedBox(
        width: 320.0,
        height: 44.0,
        child: Builder(
          builder: (BuildContext context) {
            return CalendarHeader(
              currentMonth: fixedMonth,
              isYearPickerVisible: false,
              decoration: CalendarHeaderDecoration.withDynamicColor(
                context,
                mainColor: CupertinoColors.systemRed.resolveFrom(context),
              ),
              onYearPickerStateChanged: (_) {},
              onPreviousMonthIconTapped: backwardEnabled ? () {} : null,
              onNextMonthIconTapped: forwardEnabled ? () {} : null,
            );
          },
        ),
      ),
    );
  }

  goldenTest(
    'CalendarHeader renders navigation buttons in light and dark themes',
    fileName: 'calendar_header',
    builder: () => lightDarkGroup(buildScenario),
  );

  goldenTest(
    'CalendarHeader renders with disabled navigation buttons',
    fileName: 'calendar_header_disabled',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'backward disabled – light',
          child: buildScenario(Brightness.light, backwardEnabled: false),
        ),
        GoldenTestScenario(
          name: 'forward disabled – dark',
          child: buildScenario(Brightness.dark, forwardEnabled: false),
        ),
      ],
    ),
  );
}
