// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

void main() {
  Widget buildScenario({required Brightness brightness}) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: brightness),
      locale: const Locale('en', 'US'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: CupertinoPageScaffold(
        child: Center(
          child: SizedBox(
            width: 320.0,
            child: Builder(
              builder: (BuildContext context) {
                return CalendarWeekdays(
                  decoration: CalendarWeekdayDecoration.withDynamicColor(
                    context,
                  ),
                  firstDayOfWeekIndex: 0,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CalendarWeekdays renders weekday labels in light and dark themes',
    fileName: 'calendar_weekdays',
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
}
