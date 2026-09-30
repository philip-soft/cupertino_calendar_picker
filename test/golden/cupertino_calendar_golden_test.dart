// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

void main() {
  // Fixed dates keep the rendered output deterministic across runs/machines.
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);

  Widget buildCalendar({
    required Brightness brightness,
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  }) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: brightness),
      locale: const Locale('en', 'US'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: CupertinoPageScaffold(
        child: Center(
          child: SizedBox(
            width: 320.0,
            child: CupertinoCalendar(
              minimumDateTime: minimum,
              maximumDateTime: maximum,
              initialDateTime: fixedDate,
              currentDateTime: fixedDate,
              firstDayOfWeekIndex: 0,
              mode: mode,
            ),
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoCalendar renders date mode in light and dark themes',
    fileName: 'cupertino_calendar_date',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildCalendar(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildCalendar(brightness: Brightness.dark),
        ),
      ],
    ),
  );

  goldenTest(
    'CupertinoCalendar renders dateTime mode in light and dark themes',
    fileName: 'cupertino_calendar_date_time',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildCalendar(
            brightness: Brightness.light,
            mode: CupertinoCalendarMode.dateTime,
          ),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildCalendar(
            brightness: Brightness.dark,
            mode: CupertinoCalendarMode.dateTime,
          ),
        ),
      ],
    ),
  );
}
