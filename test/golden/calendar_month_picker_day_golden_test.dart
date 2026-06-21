// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  const double daySize = calendarMonthPickerDayMaxSize;
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);
  const CupertinoDynamicColor mainColor = CupertinoColors.systemRed;

  Widget buildAllStates({required Brightness brightness}) {
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
          child: Builder(
            builder: (BuildContext context) {
              final Color resolvedMain = mainColor.resolveFrom(context);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: daySize,
                    height: daySize,
                    child: CalendarMonthPickerDay(
                      dayDate: fixedDate,
                      style:
                          CalendarMonthPickerDefaultDayStyle.withDynamicColor(
                        context,
                      ),
                      backgroundCircleSize: daySize,
                    ),
                  ),
                  SizedBox(
                    width: daySize,
                    height: daySize,
                    child: CalendarMonthPickerDay(
                      dayDate: fixedDate,
                      style:
                          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
                        context,
                        mainColor: resolvedMain,
                      ),
                      backgroundCircleSize: daySize,
                    ),
                  ),
                  SizedBox(
                    width: daySize,
                    height: daySize,
                    child: CalendarMonthPickerDay(
                      dayDate: fixedDate,
                      style:
                          CalendarMonthPickerSelectedDayStyle.withDynamicColor(
                        context,
                        mainColor: resolvedMain,
                      ),
                      backgroundCircleSize: daySize,
                    ),
                  ),
                  SizedBox(
                    width: daySize,
                    height: daySize,
                    child: CalendarMonthPickerDay(
                      dayDate: fixedDate,
                      style: CalendarMonthPickerSelectedCurrentDayStyle
                          .withDynamicColor(
                        context,
                        mainColor: resolvedMain,
                      ),
                      backgroundCircleSize: daySize,
                    ),
                  ),
                  SizedBox(
                    width: daySize,
                    height: daySize,
                    child: CalendarMonthPickerDay(
                      dayDate: fixedDate,
                      style:
                          CalendarMonthPickerDisabledDayStyle.withDynamicColor(
                        context,
                      ),
                      backgroundCircleSize: daySize,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  goldenTest(
    'CalendarMonthPickerDay renders all day states in light and dark themes',
    fileName: 'calendar_month_picker_day',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: <Widget>[
        GoldenTestScenario(
          name:
              'light — default / current / selected / selected-current / disabled',
          child: buildAllStates(brightness: Brightness.light),
        ),
        GoldenTestScenario(
          name:
              'dark — default / current / selected / selected-current / disabled',
          child: buildAllStates(brightness: Brightness.dark),
        ),
      ],
    ),
  );
}
