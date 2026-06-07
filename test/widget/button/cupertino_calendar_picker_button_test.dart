// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoCalendarPickerButton', () {
    final DateTime min = DateTime.utc(2020);
    final DateTime max = DateTime.utc(2030, 12, 31);

    testWidgets('formats the initial date with the default formatter', (
      WidgetTester tester,
    ) async {
      final DateTime initial = DateTime.utc(2024, 6, 15);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
          ),
        ),
      );

      expect(find.text('Jun 15, 2024'), findsOneWidget);
    });

    testWidgets('uses the custom formatter when provided', (
      WidgetTester tester,
    ) async {
      final DateTime initial = DateTime.utc(2024, 6, 15);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            formatter: (DateTime d) => 'X-${d.year}-${d.month}-${d.day}',
          ),
        ),
      );

      expect(find.text('X-2024-6-15'), findsOneWidget);
    });

    testWidgets('appends time string when mode is dateTime', (
      WidgetTester tester,
    ) async {
      final DateTime initial = DateTime.utc(2024, 6, 15, 14, 30);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            mode: CupertinoCalendarMode.dateTime,
            use24hFormat: true,
          ),
        ),
      );

      expect(find.text('Jun 15, 2024 14:30'), findsOneWidget);
    });

    testWidgets('uses CupertinoPickerButton internally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: DateTime.utc(2024, 6, 15),
          ),
        ),
      );

      expect(find.byType(CupertinoPickerButton<DateTime?>), findsOneWidget);
    });

    testWidgets('updates label when initialDateTime prop changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: DateTime.utc(2024),
          ),
        ),
      );
      expect(find.text('Jan 1, 2024'), findsOneWidget);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: DateTime.utc(2024, 12, 25),
          ),
        ),
      );

      expect(find.text('Dec 25, 2024'), findsOneWidget);
    });

    testWidgets(
      'selecting a date in the overlay updates the button label',
      (WidgetTester tester) async {
        DateTime? changed;
        await tester.pumpWidget(
          wrapWithApp(
            CupertinoCalendarPickerButton(
              minimumDateTime: min,
              maximumDateTime: max,
              initialDateTime: DateTime.utc(2024, 6, 15),
              onDateTimeChanged: (DateTime d) => changed = d,
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoCalendarPickerButton));
        await tester.pumpAndSettle();

        final Finder day20 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 20 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day20.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(changed?.day, 20);
        expect(find.text('Jun 20, 2024'), findsOneWidget);
      },
    );

    testWidgets(
      'does not update label after onDateTimeChanged when a confirm action is set',
      (WidgetTester tester) async {
        DateTime? changed;
        await tester.pumpWidget(
          wrapWithApp(
            CupertinoCalendarPickerButton(
              minimumDateTime: min,
              maximumDateTime: max,
              initialDateTime: DateTime.utc(2024, 6, 15),
              dismissBehavior: CalendarDismissBehavior.onActionTap,
              actions: const <CupertinoCalendarAction>[
                ConfirmCupertinoCalendarAction(),
              ],
              onDateTimeChanged: (DateTime d) => changed = d,
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoCalendarPickerButton));
        await tester.pumpAndSettle();

        final Finder day18 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 18 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day18.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(find.text('Jun 15, 2024'), findsOneWidget);
      },
    );

    testWidgets('opens overlay and fires onPressed when tapped', (
      WidgetTester tester,
    ) async {
      int pressedCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarPickerButton(
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: DateTime.utc(2024, 6, 15),
            onPressed: () => pressedCount++,
          ),
        ),
      );

      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(pressedCount, 1);
      expect(find.byType(CupertinoCalendar), findsOneWidget);
    });

    testWidgets(
      'onCompleted is called after calendar picker is dismissed',
      (WidgetTester tester) async {
        DateTime? completedWith;
        bool completedCalled = false;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoCalendarPickerButton(
              minimumDateTime: min,
              maximumDateTime: max,
              initialDateTime: DateTime.utc(2024, 6, 15),
              onCompleted: (DateTime? val) {
                completedCalled = true;
                completedWith = val;
              },
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoCalendarPickerButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        final Finder day20 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 20 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day20.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(5.0, 5.0));
        await tester.pumpAndSettle();

        expect(completedCalled, isTrue);
        expect(completedWith, anyOf(isNull, isA<DateTime>()));
      },
    );
  });
}
