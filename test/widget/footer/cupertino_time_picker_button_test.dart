// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoTimePickerButton', () {
    testWidgets('renders the formatted initial time as its label', (
      WidgetTester tester,
    ) async {
      const TimeOfDay initial = TimeOfDay(hour: 9, minute: 5);

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimePickerButton(
            initialTime: initial,
            use24hFormat: true,
          ),
        ),
      );

      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('uses 12h format when use24hFormat is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimePickerButton(
            initialTime: TimeOfDay(hour: 14, minute: 30),
            use24hFormat: false,
          ),
        ),
      );

      expect(find.text('2:30 PM'), findsOneWidget);
    });

    testWidgets('updates label when initialTime prop changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimePickerButton(
            initialTime: TimeOfDay(hour: 8, minute: 0),
            use24hFormat: true,
          ),
        ),
      );
      expect(find.text('08:00'), findsOneWidget);

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimePickerButton(
            initialTime: TimeOfDay(hour: 18, minute: 45),
            use24hFormat: true,
          ),
        ),
      );

      expect(find.text('18:45'), findsOneWidget);
    });

    testWidgets('opens overlay when tapped and fires onPressed callback', (
      WidgetTester tester,
    ) async {
      int pressedCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimePickerButton(
            initialTime: const TimeOfDay(hour: 10, minute: 0),
            use24hFormat: true,
            onPressed: () => pressedCount++,
          ),
        ),
      );

      await tester.tap(find.byType(CupertinoTimePickerButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(pressedCount, 1);
      expect(find.byType(CupertinoTimePicker), findsOneWidget);
    });

    testWidgets(
      'wheel scroll fires onTimeChanged and onCompleted with the picked value',
      (WidgetTester tester) async {
        TimeOfDay? changed;
        TimeOfDay? completed;
        bool completedFired = false;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoTimePickerButton(
              initialTime: const TimeOfDay(hour: 10, minute: 0),
              use24hFormat: true,
              onTimeChanged: (TimeOfDay t) => changed = t,
              onCompleted: (TimeOfDay? t) {
                completed = t;
                completedFired = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(CupertinoTimePickerButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final Finder wheels = find.byType(ListWheelScrollView);
        expect(wheels, findsWidgets);
        await tester.fling(
          wheels.first,
          const Offset(0, -120),
          800,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(5.0, 5.0));
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(completedFired, isTrue);
        expect(completed == null || completed is TimeOfDay, isTrue);
      },
    );

    testWidgets('uses CupertinoPickerButton internally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimePickerButton(
            initialTime: TimeOfDay(hour: 12, minute: 0),
            use24hFormat: true,
          ),
        ),
      );

      expect(find.byType(CupertinoPickerButton<TimeOfDay?>), findsOneWidget);
    });
  });
}
