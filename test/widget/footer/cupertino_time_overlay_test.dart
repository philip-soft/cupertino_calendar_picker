// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/test_durations.dart';
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
            minuteInterval: 1,
            use24hFormat: true,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(overlayClosePumpDuration);

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
            minuteInterval: 1,
            use24hFormat: true,
          ),
        ),
      );

      final TimeOfDay now = TimeOfDay.now();
      final CupertinoTimePicker picker = tester.widget<CupertinoTimePicker>(
        find.byType(CupertinoTimePicker),
      );
      final int minutesFromNow =
          (picker.initialTime.hour * 60 + picker.initialTime.minute) -
          (now.hour * 60 + now.minute);
      expect(minutesFromNow.abs(), lessThanOrEqualTo(1));
    });

    testWidgets('clamps the default time to the range', (
      WidgetTester tester,
    ) async {
      const TimeOfDay bound = TimeOfDay(hour: 0, minute: 0);

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimeOverlay(
            minuteInterval: 1,
            use24hFormat: true,
            minimumTime: bound,
            maximumTime: bound,
          ),
        ),
      );

      final CupertinoTimePicker picker = tester.widget<CupertinoTimePicker>(
        find.byType(CupertinoTimePicker),
      );
      expect(picker.initialTime, bound);
    });

    testWidgets('asserts when maximumTime is before minimumTime', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimeOverlay(
            minuteInterval: 1,
            use24hFormat: true,
            minimumTime: TimeOfDay(hour: 10, minute: 0),
            maximumTime: TimeOfDay(hour: 9, minute: 0),
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when initialTime is before minimumTime', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimeOverlay(
            minuteInterval: 1,
            use24hFormat: true,
            minimumTime: TimeOfDay(hour: 10, minute: 0),
            maximumTime: TimeOfDay(hour: 20, minute: 0),
            initialTime: TimeOfDay(hour: 9, minute: 0),
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when initialTime is after maximumTime', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoTimeOverlay(
            minuteInterval: 1,
            use24hFormat: true,
            minimumTime: TimeOfDay(hour: 10, minute: 0),
            maximumTime: TimeOfDay(hour: 12, minute: 0),
            initialTime: TimeOfDay(hour: 13, minute: 0),
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('wheel scroll inside the overlay invokes onTimeChanged', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);
      TimeOfDay? changed;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimeOverlay(
            widgetRenderBox: anchor,
            minuteInterval: 1,
            use24hFormat: true,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
            onTimeChanged: (TimeOfDay t) => changed = t,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(overlayOpenPumpDuration);

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
    });

    testWidgets('forwards onTimeChanged callback through the overlay', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);
      int callCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoTimeOverlay(
            widgetRenderBox: anchor,
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
