// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/golden_harness.dart';

void main() {
  // Fixed dates keep the rendered output deterministic across runs/machines.
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);

  Widget buildCalendar(
    Brightness brightness, {
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
    DateTime? min,
    DateTime? max,
    DateTime? initial,
    SelectableDayPredicate? selectableDayPredicate,
    TextDirection? textDirection,
    double? textScale,
  }) {
    return goldenApp(
      brightness: brightness,
      textDirection: textDirection,
      textScale: textScale,
      child: SizedBox(
        width: 320.0,
        child: CupertinoCalendar(
          minimumDateTime: min ?? minimum,
          maximumDateTime: max ?? maximum,
          initialDateTime: initial ?? fixedDate,
          currentDateTime: fixedDate,
          selectableDayPredicate: selectableDayPredicate,
          firstDayOfWeekIndex: 0,
          mode: mode,
          use24hFormat: false,
        ),
      ),
    );
  }

  /// Taps [finder] in every scenario of the group.
  Interaction tapInEveryScenario(Finder finder) {
    return (WidgetTester tester) async {
      final int count = finder.evaluate().length;
      for (int index = 0; index < count; index++) {
        await tester.tap(finder.at(index));
      }
      await tester.pumpAndSettle();
      return null;
    };
  }

  goldenTest(
    'CupertinoCalendar renders date mode in light and dark themes',
    fileName: 'cupertino_calendar_date',
    builder: () => lightDarkGroup(buildCalendar),
  );

  goldenTest(
    'CupertinoCalendar renders dateTime mode in light and dark themes',
    fileName: 'cupertino_calendar_date_time',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildCalendar(brightness, mode: CupertinoCalendarMode.dateTime),
    ),
  );

  goldenTest(
    'CupertinoCalendar renders disabled days and month switchers',
    fileName: 'cupertino_calendar_limited_range',
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildCalendar(
        brightness,
        min: DateTime.utc(2024, 6, 10),
        max: DateTime.utc(2024, 6, 25),
        selectableDayPredicate: (DateTime day) =>
            day.weekday != DateTime.saturday && day.weekday != DateTime.sunday,
      ),
    ),
  );

  goldenTest(
    'CupertinoCalendar renders a five-row month',
    fileName: 'cupertino_calendar_five_rows',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildCalendar(brightness, initial: DateTime.utc(2024, 5, 15)),
    ),
  );

  goldenTest(
    'CupertinoCalendar renders right-to-left',
    fileName: 'cupertino_calendar_rtl',
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildCalendar(
        brightness,
        mode: CupertinoCalendarMode.dateTime,
        textDirection: TextDirection.rtl,
      ),
    ),
  );

  goldenTest(
    'CupertinoCalendar clamps a large text scale and narrows the weekdays',
    fileName: 'cupertino_calendar_large_text',
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildCalendar(
        brightness,
        mode: CupertinoCalendarMode.dateTime,
        textScale: 2.0,
      ),
    ),
  );

  goldenTest(
    'CupertinoCalendar renders the year picker',
    fileName: 'cupertino_calendar_year_picker',
    whilePerforming: tapInEveryScenario(find.text('June 2024')),
    builder: () => lightDarkGroup(buildCalendar),
  );

  goldenTest(
    'CupertinoCalendar renders the time picker',
    fileName: 'cupertino_calendar_time_picker',
    whilePerforming: tapInEveryScenario(find.text('2:30 PM')),
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildCalendar(
        brightness,
        mode: CupertinoCalendarMode.dateTime,
        initial: DateTime.utc(2024, 6, 15, 14, 30),
      ),
    ),
  );
}
