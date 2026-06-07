// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  bool alwaysUse24HourFormat = false,
}) {
  return MaterialApp(
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: MediaQuery(
      data: MediaQueryData(
        alwaysUse24HourFormat: alwaysUse24HourFormat,
      ),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('TimeOfDayExtension', () {
    group('toDateTime', () {
      test('produces a DateTime with year 0 and month 1 and day 1', () {
        const TimeOfDay time = TimeOfDay(hour: 9, minute: 30);

        final DateTime result = time.toDateTime();

        expect(result.year, 0);
        expect(result.month, 1);
        expect(result.day, 1);
        expect(result.hour, 9);
        expect(result.minute, 30);
      });

      test('handles midnight (00:00) correctly', () {
        const TimeOfDay time = TimeOfDay(hour: 0, minute: 0);

        final DateTime result = time.toDateTime();

        expect(result.hour, 0);
        expect(result.minute, 0);
      });

      test('handles end-of-day (23:59) correctly', () {
        const TimeOfDay time = TimeOfDay(hour: 23, minute: 59);

        final DateTime result = time.toDateTime();

        expect(result.hour, 23);
        expect(result.minute, 59);
      });
    });

    group('toNowDateTime', () {
      test('uses today date with provided hour and minute', () {
        const TimeOfDay time = TimeOfDay(hour: 7, minute: 15);
        final DateTime now = DateTime.now();

        final DateTime result = time.toNowDateTime();

        expect(result.year, now.year);
        expect(result.month, now.month);
        expect(result.day, now.day);
        expect(result.hour, 7);
        expect(result.minute, 15);
        expect(result.second, 0);
        expect(result.millisecond, 0);
      });
    });

    group('isBefore', () {
      test('returns true when hour is smaller', () {
        const TimeOfDay a = TimeOfDay(hour: 8, minute: 0);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 0);

        expect(TimeOfDayExtension(a).isBefore(b), isTrue);
      });

      test('returns true when hours are equal and minute is smaller', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 15);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isBefore(b), isTrue);
      });

      test('returns false when hour is larger', () {
        const TimeOfDay a = TimeOfDay(hour: 10, minute: 0);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 0);

        expect(TimeOfDayExtension(a).isBefore(b), isFalse);
      });

      test('returns false when hours and minutes are equal', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 30);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isBefore(b), isFalse);
      });

      test('returns false when hours are equal and minute is larger', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 45);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isBefore(b), isFalse);
      });
    });

    group('isAfter', () {
      test('returns true when hour is larger', () {
        const TimeOfDay a = TimeOfDay(hour: 10, minute: 0);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 0);

        expect(TimeOfDayExtension(a).isAfter(b), isTrue);
      });

      test('returns true when hours are equal and minute is larger', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 45);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isAfter(b), isTrue);
      });

      test('returns false when hour is smaller', () {
        const TimeOfDay a = TimeOfDay(hour: 8, minute: 0);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 0);

        expect(TimeOfDayExtension(a).isAfter(b), isFalse);
      });

      test('returns false when hours and minutes are equal', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 30);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isAfter(b), isFalse);
      });

      test('returns false when hours are equal and minute is smaller', () {
        const TimeOfDay a = TimeOfDay(hour: 9, minute: 15);
        const TimeOfDay b = TimeOfDay(hour: 9, minute: 30);

        expect(TimeOfDayExtension(a).isAfter(b), isFalse);
      });
    });

    group('timeWithDayPeriodFormat', () {
      testWidgets('formats time as h:mm without day period',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        const TimeOfDay time = TimeOfDay(hour: 15, minute: 7);
        final String result = time.timeWithDayPeriodFormat(capturedContext);

        expect(result, '3:07');
      });
    });

    group('timeFormat', () {
      testWidgets('uses 24-hour pattern when use24hFormat is true',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        const TimeOfDay time = TimeOfDay(hour: 15, minute: 7);
        final String result = time.timeFormat(
          capturedContext,
          use24hFormat: true,
        );

        expect(result, '15:07');
      });

      testWidgets(
          'uses 12-hour pattern with day period when use24hFormat is '
          'false', (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        const TimeOfDay time = TimeOfDay(hour: 15, minute: 7);
        final String result = time.timeFormat(
          capturedContext,
          use24hFormat: false,
        );

        expect(result, '3:07 PM');
      });

      testWidgets('falls back to context.alwaysUse24hFormat=false when null',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        const TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
        final String result = time.timeFormat(
          capturedContext,
          use24hFormat: null,
        );

        expect(result, '12:00 AM');
      });

      testWidgets('falls back to context.alwaysUse24hFormat=true when null',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            alwaysUse24HourFormat: true,
          ),
        );

        const TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
        final String result = time.timeFormat(
          capturedContext,
          use24hFormat: null,
        );

        expect(result, '00:00');
      });
    });
  });
}
