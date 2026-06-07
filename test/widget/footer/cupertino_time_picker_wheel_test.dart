// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoTimePickerWheel', () {
    testWidgets('renders without error with valid bounds', (
      WidgetTester tester,
    ) async {
      final DateTime min = DateTime(2024);
      final DateTime max = DateTime(2024, 1, 1, 23, 59);
      final DateTime initial = DateTime(2024, 1, 1, 10, 30);

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 160.0,
            width: 231.0,
            child: CupertinoTimePickerWheel(
              initialDateTime: initial,
              minimumDateTime: min,
              maximumDateTime: max,
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: true,
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('respects 24h format when use24hFormat is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 160.0,
            width: 231.0,
            child: CupertinoTimePickerWheel(
              initialDateTime: DateTime(2024, 1, 1, 14, 30),
              minimumDateTime: DateTime(2024),
              maximumDateTime: DateTime(2024, 1, 1, 23, 59),
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: true,
            ),
          ),
        ),
      );

      expect(find.text('AM'), findsNothing);
      expect(find.text('PM'), findsNothing);
    });

    testWidgets('shows AM/PM markers when use24hFormat is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 160.0,
            width: 231.0,
            child: CupertinoTimePickerWheel(
              initialDateTime: DateTime(2024, 1, 1, 14, 30),
              minimumDateTime: DateTime(2024),
              maximumDateTime: DateTime(2024, 1, 1, 23, 59),
              onTimeChanged: (_) {},
              minuteInterval: 1,
              use24hFormat: false,
            ),
          ),
        ),
      );

      expect(find.text('AM'), findsOneWidget);
      expect(find.text('PM'), findsOneWidget);
    });

    testWidgets('falls back to context use24hFormat when null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 160.0,
            width: 231.0,
            child: CupertinoTimePickerWheel(
              initialDateTime: DateTime(2024, 1, 1, 10),
              minimumDateTime: DateTime(2024),
              maximumDateTime: DateTime(2024, 1, 1, 23, 59),
              onTimeChanged: (_) {},
              minuteInterval: 1,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
