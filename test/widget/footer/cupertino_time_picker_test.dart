// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoTimePicker', () {
    testWidgets('renders within a SizedBox sized to timePickerWheelHeight', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            width: 231.0,
            child: CupertinoTimePicker(
              initialTime: const TimeOfDay(hour: 10, minute: 30),
              minimumTime: const TimeOfDay(hour: 0, minute: 0),
              maximumTime: const TimeOfDay(hour: 23, minute: 59),
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: true,
            ),
          ),
        ),
      );

      final Finder boxFinder = find.byWidgetPredicate(
        (Widget w) => w is SizedBox && w.height == timePickerWheelHeight,
      );
      expect(boxFinder, findsWidgets);
    });

    testWidgets('forwards initialTime through the wheel widget', (
      WidgetTester tester,
    ) async {
      const TimeOfDay initial = TimeOfDay(hour: 7, minute: 15);

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            width: 231.0,
            child: CupertinoTimePicker(
              initialTime: initial,
              minimumTime: const TimeOfDay(hour: 0, minute: 0),
              maximumTime: const TimeOfDay(hour: 23, minute: 59),
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: true,
            ),
          ),
        ),
      );

      final CupertinoTimePickerWheel wheel =
          tester.widget<CupertinoTimePickerWheel>(
        find.byType(CupertinoTimePickerWheel),
      );
      expect(wheel.initialDateTime.hour, 7);
      expect(wheel.initialDateTime.minute, 15);
    });

    testWidgets('forwards minuteInterval and use24hFormat to the wheel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            width: 231.0,
            child: CupertinoTimePicker(
              initialTime: const TimeOfDay(hour: 10, minute: 0),
              minimumTime: const TimeOfDay(hour: 0, minute: 0),
              maximumTime: const TimeOfDay(hour: 23, minute: 59),
              onTimeChanged: (_) {},
              minuteInterval: 5,
              use24hFormat: false,
            ),
          ),
        ),
      );

      final CupertinoTimePickerWheel wheel =
          tester.widget<CupertinoTimePickerWheel>(
        find.byType(CupertinoTimePickerWheel),
      );
      expect(wheel.minuteInterval, 5);
      expect(wheel.use24hFormat, false);
    });
  });
}
