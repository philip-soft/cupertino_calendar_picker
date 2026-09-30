// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;

import '../support/test_app.dart';

Widget _app(Widget child) {
  return wrapTestWidget(
    child,
    brightness: Brightness.light,
    textDirection: TextDirection.ltr,
    locale: const Locale('en', 'US'),
    layout: (Widget child) => Center(child: child),
  );
}

Finder _day(DateTime date) {
  return find.byWidgetPredicate(
    (Widget widget) =>
        widget is CalendarMonthPickerDay && widget.dayDate == date,
  );
}

void main() {
  group('default initial date', () {
    testWidgets('CupertinoCalendar clamps today into a future range', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2100, 3, 5),
            maximumDateTime: DateTime(2100, 12, 31),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(tester.takeException(), isNull);
      expect(find.text('March 2100'), findsOneWidget);
      expect(_day(DateTime(2100, 3, 5)), findsOneWidget);
    });

    testWidgets('CupertinoCalendar clamps today into a past range', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2000),
            maximumDateTime: DateTime(2000, 5, 20),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('May 2000'), findsOneWidget);
    });

    testWidgets('CupertinoCalendarPickerButton clamps today into the range', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          CupertinoCalendarPickerButton(
            minimumDateTime: DateTime(2100, 3, 5),
            maximumDateTime: DateTime(2100, 12, 31),
          ),
        ),
      );
      expect(find.text('Mar 5, 2100'), findsOneWidget);

      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('March 2100'), findsOneWidget);
    });

    testWidgets('CupertinoTimePickerButton clamps now into the range', (
      WidgetTester tester,
    ) async {
      const TimeOfDay bound = TimeOfDay(hour: 0, minute: 0);
      await tester.pumpWidget(
        _app(
          const CupertinoTimePickerButton(
            minimumTime: bound,
            maximumTime: bound,
            use24hFormat: true,
          ),
        ),
      );
      expect(find.text('00:00'), findsOneWidget);

      await tester.tap(find.byType(CupertinoTimePickerButton));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('day period switcher', () {
    testWidgets('never produces a time after maximumDateTime', (
      WidgetTester tester,
    ) async {
      // Arrange
      final DateTime maximum = DateTime(2026, 9, 10, 11);
      DateTime? changed;
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2026),
            maximumDateTime: maximum,
            initialDateTime: DateTime(2026, 9, 10, 9),
            mode: CupertinoCalendarMode.dateTime,
            type: CupertinoCalendarType.compact,
            use24hFormat: false,
            onDateTimeChanged: (DateTime value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('PM'));
      await tester.pumpAndSettle();

      // Assert
      expect(changed, maximum);
      expect(find.text('11:00'), findsOneWidget);
    });

    testWidgets('never produces a time before minimumDateTime', (
      WidgetTester tester,
    ) async {
      final DateTime minimum = DateTime(2026, 9, 10, 14, 30);
      DateTime? changed;
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: minimum,
            maximumDateTime: DateTime(2026, 12, 31),
            initialDateTime: DateTime(2026, 9, 10, 15),
            mode: CupertinoCalendarMode.dateTime,
            type: CupertinoCalendarType.compact,
            use24hFormat: false,
            onDateTimeChanged: (DateTime value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('AM'));
      await tester.pumpAndSettle();

      expect(changed, minimum);
    });
  });

  group('changing the range at runtime', () {
    testWidgets('keeps the displayed month when minimumDateTime changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      Widget build(DateTime minimum) {
        return _app(
          CupertinoCalendar(
            minimumDateTime: minimum,
            maximumDateTime: DateTime(2027, 12, 31),
            initialDateTime: DateTime(2026, 9, 10),
          ),
        );
      }

      await tester.pumpWidget(build(DateTime(2026)));
      await tester.pumpAndSettle();
      expect(_day(DateTime(2026, 9, 15)), findsOneWidget);

      // Act
      await tester.pumpWidget(build(DateTime(2025)));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('September 2026'), findsOneWidget);
      expect(_day(DateTime(2026, 9, 15)), findsOneWidget);
    });

    testWidgets('clamps the selection when the range shrinks past it', (
      WidgetTester tester,
    ) async {
      Widget build(DateTime maximum) {
        return _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2026),
            maximumDateTime: maximum,
            initialDateTime: DateTime(2026, 9, 10),
          ),
        );
      }

      await tester.pumpWidget(build(DateTime(2026, 12, 31)));
      await tester.pumpAndSettle();

      await tester.pumpWidget(build(DateTime(2026, 5, 20)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('May 2026'), findsOneWidget);
    });
  });

  group('year picker', () {
    testWidgets('clamps the day when switching to a shorter month', (
      WidgetTester tester,
    ) async {
      // Arrange
      DateTime? changed;
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2026),
            maximumDateTime: DateTime(2026, 12, 31),
            initialDateTime: DateTime(2026, 1, 31),
            onDateTimeChanged: (DateTime value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('January 2026'));
      await tester.pumpAndSettle();

      // Act: report February from the month/year wheel.
      tester
          .widget<CustomCupertinoDatePicker>(
            find.byType(CustomCupertinoDatePicker),
          )
          .onDateTimeChanged(DateTime(2026, 2));
      await tester.pumpAndSettle();

      // Assert
      expect(changed, DateTime(2026, 2, 28));
    });
  });
}
