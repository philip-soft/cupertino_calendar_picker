// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PackageDateUtils', () {
    group('monthDateOnly', () {
      test('strips day, hour, minute and seconds from the input', () {
        final DateTime date = DateTime(2024, 6, 15, 14, 30, 45);

        final DateTime result = PackageDateUtils.monthDateOnly(date);

        expect(result, DateTime(2024, 6));
        expect(result.day, 1);
        expect(result.hour, 0);
        expect(result.minute, 0);
        expect(result.second, 0);
      });

      test('preserves year and month for the first day of the month', () {
        final DateTime date = DateTime(2024);

        final DateTime result = PackageDateUtils.monthDateOnly(date);

        expect(result.year, 2024);
        expect(result.month, 1);
        expect(result.day, 1);
      });

      test('handles December correctly', () {
        final DateTime date = DateTime(2023, 12, 31);

        final DateTime result = PackageDateUtils.monthDateOnly(date);

        expect(result, DateTime(2023, 12));
      });
    });

    group('firstDayOffset', () {
      test('returns 0 when the first day of the month is the first day of week',
          () {
        const int year = 2024;
        const int month = 4;
        const int firstDayOfWeekIndex = 1;

        final int result = PackageDateUtils.firstDayOffset(
          year,
          month,
          firstDayOfWeekIndex,
        );

        expect(result, 0);
      });

      test(
          'returns 6 when the first day of the month is the day before the '
          'week start', () {
        const int year = 2024;
        const int month = 6;
        const int firstDayOfWeekIndex = 0;

        final int result = PackageDateUtils.firstDayOffset(
          year,
          month,
          firstDayOfWeekIndex,
        );

        expect(result, 6);
      });

      test('returns correct offset for Sunday-starting week', () {
        const int year = 2024;
        const int month = 6;
        const int firstDayOfWeekIndex = 7;

        final int result = PackageDateUtils.firstDayOffset(
          year,
          month,
          firstDayOfWeekIndex,
        );

        expect(result, 6);
      });

      test('returns correct offset when month starts mid-week', () {
        const int year = 2024;
        const int month = 3;
        const int firstDayOfWeekIndex = 1;

        final int result = PackageDateUtils.firstDayOffset(
          year,
          month,
          firstDayOfWeekIndex,
        );

        expect(result, 4);
      });

      test('result is always in [0, 6]', () {
        for (int month = 1; month <= 12; month++) {
          for (int firstDay = 1; firstDay <= 7; firstDay++) {
            final int offset = PackageDateUtils.firstDayOffset(
              2024,
              month,
              firstDay,
            );
            expect(offset, inInclusiveRange(0, 6));
          }
        }
      });
    });
  });
}
