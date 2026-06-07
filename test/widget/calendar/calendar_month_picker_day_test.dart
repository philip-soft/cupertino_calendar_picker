// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarMonthPickerDay', () {
    final DateTime day = DateTime.utc(2024, 6, 15);

    Widget buildDay({
      required CalendarMonthPickerDayStyle style,
      ValueChanged<DateTime>? onSelected,
      double size = 42.0,
    }) {
      return wrapWithApp(
        SizedBox(
          width: size,
          height: size,
          child: CalendarMonthPickerDay(
            dayDate: day,
            style: style,
            backgroundCircleSize: size,
            onDaySelected: onSelected,
          ),
        ),
      );
    }

    testWidgets('renders without throwing for default style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildDay(style: CalendarMonthPickerDefaultDayStyle()),
      );

      expect(find.byType(CalendarMonthPickerDay), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('fires onDaySelected with day date when tapped', (
      WidgetTester tester,
    ) async {
      DateTime? tapped;
      await tester.pumpWidget(
        buildDay(
          style: CalendarMonthPickerDefaultDayStyle(),
          onSelected: (DateTime d) => tapped = d,
        ),
      );

      await tester.tap(find.byType(CalendarMonthPickerDay));
      await tester.pump();

      expect(tapped, day);
    });

    testWidgets('tapping disabled day (null callback) does nothing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildDay(style: CalendarMonthPickerDisabledDayStyle()),
      );

      await tester.tap(find.byType(CalendarMonthPickerDay));
      await tester.pump();
    });

    testWidgets('paints background circle for selected style', (
      WidgetTester tester,
    ) async {
      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle(
        mainColor: CupertinoColors.systemRed,
      );

      await tester.pumpWidget(buildDay(style: style));

      final CustomPaint paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(CalendarMonthPickerDay),
          matching: find.byType(CustomPaint),
        ),
      );
      final CalendarMonthPickerDayPainter painter =
          paint.painter! as CalendarMonthPickerDayPainter;
      expect(painter.backgroundCircleColor, isNotNull);
      expect(painter.day, '15');
    });

    testWidgets('default style has null background circle color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildDay(style: CalendarMonthPickerDefaultDayStyle()),
      );

      final CustomPaint paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(CalendarMonthPickerDay),
          matching: find.byType(CustomPaint),
        ),
      );
      final CalendarMonthPickerDayPainter painter =
          paint.painter! as CalendarMonthPickerDayPainter;
      expect(painter.backgroundCircleColor, isNull);
    });
  });

  group('CalendarMonthPickerDayPainter.shouldRepaint', () {
    const TextStyle style = TextStyle(fontSize: 20.0);
    const TextScaler scaler = TextScaler.noScaling;

    test('returns false when nothing changes', () {
      const CalendarMonthPickerDayPainter a = CalendarMonthPickerDayPainter(
        day: '5',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 40.0,
      );
      const CalendarMonthPickerDayPainter b = CalendarMonthPickerDayPainter(
        day: '5',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 40.0,
      );

      expect(a.shouldRepaint(b), isFalse);
    });

    test('returns true when day text changes', () {
      const CalendarMonthPickerDayPainter a = CalendarMonthPickerDayPainter(
        day: '5',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 40.0,
      );
      const CalendarMonthPickerDayPainter b = CalendarMonthPickerDayPainter(
        day: '6',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 40.0,
      );

      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when background circle size changes', () {
      const CalendarMonthPickerDayPainter a = CalendarMonthPickerDayPainter(
        day: '5',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 40.0,
      );
      const CalendarMonthPickerDayPainter b = CalendarMonthPickerDayPainter(
        day: '5',
        textScaler: scaler,
        style: style,
        backgroundCircleSize: 38.0,
      );

      expect(a.shouldRepaint(b), isTrue);
    });
  });
}
