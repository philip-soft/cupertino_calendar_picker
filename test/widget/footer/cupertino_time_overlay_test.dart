// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

Future<RenderBox> _pumpAnchor(WidgetTester tester) async {
  final GlobalKey anchorKey = GlobalKey();
  await tester.pumpWidget(
    wrapWithApp(
      Stack(
        children: <Widget>[
          Positioned(
            left: 100.0,
            top: 100.0,
            width: 80.0,
            height: 40.0,
            child: SizedBox(key: anchorKey),
          ),
        ],
      ),
    ),
  );
  return anchorKey.currentContext!.findRenderObject()! as RenderBox;
}

void main() {
  group('CupertinoTimeOverlay', () {
    testWidgets('renders the time picker child after animation starts', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimeOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            minuteInterval: 1,
            use24hFormat: true,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CupertinoTimePicker), findsOneWidget);
    });

    testWidgets('defaults to TimeOfDay.now() when no initialTime provided', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimeOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            minuteInterval: 1,
            use24hFormat: true,
          ),
        ),
      );

      final CupertinoTimeOverlay overlay = tester.widget<CupertinoTimeOverlay>(
        find.byType(CupertinoTimeOverlay),
      );
      expect(overlay.initialTime, isA<TimeOfDay>());
    });

    testWidgets('asserts when maximumTime is before minimumTime', (
      WidgetTester tester,
    ) async {
      expect(
        () => CupertinoTimeOverlay(
          widgetRenderBox: null,
          horizontalSpacing: 15.0,
          verticalSpacing: 15.0,
          offset: const Offset(0.0, 10.0),
          minuteInterval: 1,
          use24hFormat: true,
          minimumTime: const TimeOfDay(hour: 10, minute: 0),
          maximumTime: const TimeOfDay(hour: 9, minute: 0),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('asserts when initialTime is before minimumTime', (
      WidgetTester tester,
    ) async {
      expect(
        () => CupertinoTimeOverlay(
          widgetRenderBox: null,
          horizontalSpacing: 15.0,
          verticalSpacing: 15.0,
          offset: const Offset(0.0, 10.0),
          minuteInterval: 1,
          use24hFormat: true,
          minimumTime: const TimeOfDay(hour: 10, minute: 0),
          maximumTime: const TimeOfDay(hour: 20, minute: 0),
          initialTime: const TimeOfDay(hour: 9, minute: 0),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('asserts when initialTime is after maximumTime', (
      WidgetTester tester,
    ) async {
      expect(
        () => CupertinoTimeOverlay(
          widgetRenderBox: null,
          horizontalSpacing: 15.0,
          verticalSpacing: 15.0,
          offset: const Offset(0.0, 10.0),
          minuteInterval: 1,
          use24hFormat: true,
          minimumTime: const TimeOfDay(hour: 10, minute: 0),
          maximumTime: const TimeOfDay(hour: 12, minute: 0),
          initialTime: const TimeOfDay(hour: 13, minute: 0),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'wheel scroll inside the overlay invokes onTimeChanged',
      (WidgetTester tester) async {
        final RenderBox anchor = await _pumpAnchor(tester);
        TimeOfDay? changed;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoTimeOverlay(
              widgetRenderBox: anchor,
              horizontalSpacing: 15.0,
              verticalSpacing: 15.0,
              offset: const Offset(0.0, 10.0),
              minuteInterval: 1,
              use24hFormat: true,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
              onTimeChanged: (TimeOfDay t) => changed = t,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final Finder wheels = find.byType(ListWheelScrollView);
        expect(wheels, findsWidgets);
        await tester.fling(
          wheels.first,
          const Offset(0, -100),
          600,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
      },
    );

    testWidgets('forwards onTimeChanged callback through the overlay', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);
      int callCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimeOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            minuteInterval: 1,
            use24hFormat: true,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
            onTimeChanged: (_) => callCount++,
          ),
        ),
      );
      await tester.pump();

      final CupertinoTimeOverlay overlay = tester.widget<CupertinoTimeOverlay>(
        find.byType(CupertinoTimeOverlay),
      );
      expect(overlay.onTimeChanged, isNotNull);
      expect(callCount, 0);
    });
  });
}
