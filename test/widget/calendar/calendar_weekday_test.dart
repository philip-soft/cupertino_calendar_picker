// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarWeekday', () {
    testWidgets('renders provided weekday string', (WidgetTester tester) async {
      const String weekday = 'MON';

      await tester.pumpWidget(
        wrapWithApp(
          const CalendarWeekday(weekday: weekday),
        ),
      );

      expect(find.text(weekday), findsOneWidget);
    });

    testWidgets('renders with default null decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CalendarWeekday(weekday: 'TUE'),
        ),
      );

      final Text textWidget = tester.widget<Text>(find.text('TUE'));
      expect(textWidget.style, isNull);
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('applies decoration text style', (WidgetTester tester) async {
      const TextStyle customStyle = TextStyle(
        fontSize: 18.0,
        color: CupertinoColors.activeBlue,
      );
      final CalendarWeekdayDecoration decoration = CalendarWeekdayDecoration(
        textStyle: customStyle,
      );

      await tester.pumpWidget(
        wrapWithApp(
          CalendarWeekday(
            weekday: 'WED',
            decoration: decoration,
          ),
        ),
      );

      final Text textWidget = tester.widget<Text>(find.text('WED'));
      expect(textWidget.style, customStyle);
    });

    testWidgets('lays out within a SizedBox of width 40', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CalendarWeekday(weekday: 'FRI'),
        ),
      );

      final SizedBox box = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.text('FRI'),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(box.width, 40.0);
    });
  });
}
