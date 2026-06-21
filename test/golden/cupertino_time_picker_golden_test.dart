// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  const TimeOfDay minimum = TimeOfDay(hour: 0, minute: 0);
  const TimeOfDay maximum = TimeOfDay(hour: 23, minute: 59);
  const TimeOfDay initial = TimeOfDay(hour: 14, minute: 30);

  Widget buildScenario({
    required Brightness brightness,
    bool use24hFormat = false,
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
            child: CupertinoTimePicker(
              initialTime: initial,
              minimumTime: minimum,
              maximumTime: maximum,
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: use24hFormat,
            ),
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoTimePicker renders 12h wheel in light and dark themes',
    fileName: 'cupertino_time_picker',
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
    'CupertinoTimePicker renders 24h wheel in light and dark themes',
    fileName: 'cupertino_time_picker_24h',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: <Widget>[
        GoldenTestScenario(
          name: 'light',
          child:
              buildScenario(brightness: Brightness.light, use24hFormat: true),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: buildScenario(brightness: Brightness.dark, use24hFormat: true),
        ),
      ],
    ),
  );
}
