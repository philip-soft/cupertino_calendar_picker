// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // Fixed dates keep the rendered output deterministic across runs/machines.
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);

  const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
    CancelCupertinoCalendarAction(),
    ConfirmCupertinoCalendarAction(),
  ];

  Widget buildCalendar({
    required Brightness brightness,
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  }) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: brightness),
      locale: const Locale('en', 'US'),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
              type: CupertinoCalendarType.compact,
              mode: mode,
              actions: actions,
            ),
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoCalendar compact renders date mode with actions',
    fileName: 'cupertino_calendar_compact_actions',
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
    'CupertinoCalendar compact renders dateTime mode with actions',
    fileName: 'cupertino_calendar_compact_date_time_actions',
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
