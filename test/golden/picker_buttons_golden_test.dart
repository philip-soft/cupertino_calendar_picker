// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15, 14, 30);
  const TimeOfDay fixedTime = TimeOfDay(hour: 14, minute: 30);

  Widget buildCalendarButton({required Brightness brightness}) {
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
          child: CupertinoCalendarPickerButton(
            minimumDateTime: minimum,
            maximumDateTime: maximum,
            initialDateTime: fixedDate,
          ),
        ),
      ),
    );
  }

  Widget buildCalendarDateTimeButton({required Brightness brightness}) {
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
          child: CupertinoCalendarPickerButton(
            minimumDateTime: minimum,
            maximumDateTime: maximum,
            initialDateTime: fixedDate,
            mode: CupertinoCalendarMode.dateTime,
            use24hFormat: false,
          ),
        ),
      ),
    );
  }

  Widget buildTimeButton({required Brightness brightness}) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: brightness),
      locale: const Locale('en', 'US'),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const CupertinoPageScaffold(
        child: Center(
          child: CupertinoTimePickerButton(
            initialTime: fixedTime,
            use24hFormat: false,
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoCalendarPickerButton renders date mode in light and dark themes',
    fileName: 'cupertino_calendar_picker_button_date',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildCalendarButton(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildCalendarButton(brightness: Brightness.dark),
        ),
      ],
    ),
  );

  goldenTest(
    'CupertinoCalendarPickerButton renders dateTime mode in light and dark themes',
    fileName: 'cupertino_calendar_picker_button_date_time',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildCalendarDateTimeButton(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildCalendarDateTimeButton(brightness: Brightness.dark),
        ),
      ],
    ),
  );

  goldenTest(
    'CupertinoTimePickerButton renders in light and dark themes',
    fileName: 'cupertino_time_picker_button',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildTimeButton(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildTimeButton(brightness: Brightness.dark),
        ),
      ],
    ),
  );
}
