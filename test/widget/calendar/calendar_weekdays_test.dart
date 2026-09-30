// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarWeekdays', () {
    final CalendarWeekdayDecoration decoration = CalendarWeekdayDecoration();

    testWidgets('renders exactly seven weekday cells', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekdays(decoration: decoration, firstDayOfWeekIndex: 0),
        ),
      );

      expect(find.byType(CalendarWeekday), findsNWidgets(DateTime.daysPerWeek));
    });

    testWidgets('starts with Sunday when firstDayOfWeekIndex is 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekdays(decoration: decoration, firstDayOfWeekIndex: 0),
        ),
      );

      final CalendarWeekday firstWeekday = tester.widget<CalendarWeekday>(
        find.byType(CalendarWeekday).first,
      );
      expect(firstWeekday.weekday, 'SUN');
    });

    testWidgets('starts with Monday when firstDayOfWeekIndex is 1', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekdays(decoration: decoration, firstDayOfWeekIndex: 1),
        ),
      );

      final CalendarWeekday firstWeekday = tester.widget<CalendarWeekday>(
        find.byType(CalendarWeekday).first,
      );
      expect(firstWeekday.weekday, 'MON');
    });

    testWidgets('all weekday labels are uppercase', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekdays(decoration: decoration, firstDayOfWeekIndex: 0),
        ),
      );

      final Iterable<CalendarWeekday> weekdays = tester
          .widgetList<CalendarWeekday>(find.byType(CalendarWeekday));
      for (final CalendarWeekday w in weekdays) {
        expect(w.weekday, w.weekday.toUpperCase());
      }
    });

    testWidgets('falls back to locale first day when index is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekdays(decoration: decoration, firstDayOfWeekIndex: null),
        ),
      );

      final CalendarWeekday firstWeekday = tester.widget<CalendarWeekday>(
        find.byType(CalendarWeekday).first,
      );
      expect(firstWeekday.weekday, 'SUN');
    });

    testWidgets(
      'uses single-letter labels when textScaleFactor exceeds threshold',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: CalendarWeekdays(
                decoration: decoration,
                firstDayOfWeekIndex: 0,
              ),
            ),
          ),
        );

        final Iterable<CalendarWeekday> weekdays = tester
            .widgetList<CalendarWeekday>(find.byType(CalendarWeekday));
        for (final CalendarWeekday w in weekdays) {
          expect(w.weekday.length, 1);
        }
      },
    );

    final Map<Locale, List<String>> narrowWeekdays = <Locale, List<String>>{
      const Locale('en', 'US'): <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'],
      const Locale('zh'): <String>['一', '二', '三', '四', '五', '六', '日'],
      const Locale('ar'): <String>['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'],
    };
    for (final MapEntry<Locale, List<String>>(
          key: Locale locale,
          value: List<String> expected,
        )
        in narrowWeekdays.entries) {
      testWidgets('shows narrow weekdays at a large text scale in $locale', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(
                    calendarMaxTextScaleFactor,
                  ),
                ),
                child: CalendarWeekdays(
                  decoration: decoration,
                  firstDayOfWeekIndex: 1,
                ),
              ),
            ),
            locale: locale,
          ),
        );

        // Act
        final List<String> weekdays = tester
            .widgetList<CalendarWeekday>(find.byType(CalendarWeekday))
            .map((CalendarWeekday weekday) => weekday.weekday)
            .toList();

        // Assert
        expect(weekdays, expected);
      });
    }
  });
}
