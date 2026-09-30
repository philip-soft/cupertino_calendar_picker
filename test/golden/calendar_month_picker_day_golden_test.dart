// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

import 'support/golden_harness.dart';

void main() {
  const double daySize = calendarMonthPickerDayMaxSize;
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);

  /// The default, current, selected, selected-current and disabled styles.
  List<CalendarMonthPickerDayStyle> dayStyles(BuildContext context) {
    final Color mainColor = CupertinoColors.systemRed.resolveFrom(context);
    return <CalendarMonthPickerDayStyle>[
      CalendarMonthPickerDefaultDayStyle.withDynamicColor(context),
      CalendarMonthPickerCurrentDayStyle.withDynamicColor(
        context,
        mainColor: mainColor,
      ),
      CalendarMonthPickerSelectedDayStyle.withDynamicColor(
        context,
        mainColor: mainColor,
      ),
      CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
        context,
        mainColor: mainColor,
      ),
      CalendarMonthPickerDisabledDayStyle.withDynamicColor(context),
    ];
  }

  Widget buildAllStates(Brightness brightness) {
    return goldenApp(
      brightness: brightness,
      child: Builder(
        builder: (BuildContext context) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final CalendarMonthPickerDayStyle style in dayStyles(context))
              SizedBox(
                width: daySize,
                height: daySize,
                child: CalendarMonthPickerDay(
                  dayDate: fixedDate,
                  style: style,
                  backgroundCircleSize: daySize,
                ),
              ),
          ],
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
          name: 'light — default / current / selected / selected-current / disabled',
          child: buildAllStates(Brightness.light),
        ),
        GoldenTestScenario(
          name: 'dark — default / current / selected / selected-current / disabled',
          child: buildAllStates(Brightness.dark),
        ),
      ],
    ),
  );
}
