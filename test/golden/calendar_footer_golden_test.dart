// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  const TimeOfDay fixedTime = TimeOfDay(hour: 14, minute: 30);

  Widget buildScenario({
    required Brightness brightness,
    bool use24h = false,
    String? label,
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
            child: Builder(
              builder: (BuildContext context) {
                return CalendarFooter(
                  time: fixedTime,
                  onTimePickerStateChanged: (_) {},
                  onTimeChanged: (_) {},
                  type: CupertinoCalendarType.compact,
                  label: label,
                  mainColor: CupertinoColors.systemRed.resolveFrom(context),
                  decoration:
                      CalendarFooterDecoration.withDynamicColor(context),
                  use24hFormat: use24h,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CalendarFooter renders time row with AM/PM in light and dark themes',
    fileName: 'calendar_footer',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildScenario(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildScenario(brightness: Brightness.dark),
        ),
      ],
    ),
  );

  goldenTest(
    'CalendarFooter renders time row with label in light and dark themes',
    fileName: 'calendar_footer_label',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildScenario(
            brightness: Brightness.light,
            label: 'Time',
          ),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildScenario(
            brightness: Brightness.dark,
            label: 'Time',
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'CalendarFooter renders time row in 24h format in light and dark themes',
    fileName: 'calendar_footer_24h',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child: buildScenario(brightness: Brightness.light, use24h: true),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildScenario(brightness: Brightness.dark, use24h: true),
        ),
      ],
    ),
  );
}
