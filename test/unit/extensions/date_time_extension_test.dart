// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PackageDateTimeExtension', () {
    group('addDays', () {
      test('adds positive number of days within a month', () {
        final DateTime date = DateTime.utc(2024, 6, 10);
        expect(date.addDays(5), DateTime.utc(2024, 6, 15));
      });

      test('adds days across a month boundary', () {
        final DateTime date = DateTime.utc(2024, 6, 28);
        expect(date.addDays(5), DateTime.utc(2024, 7, 3));
      });

      test('adds days across a year boundary', () {
        final DateTime date = DateTime.utc(2024, 12, 30);
        expect(date.addDays(5), DateTime.utc(2025, 1, 4));
      });

      test('adding zero days returns the same day', () {
        final DateTime date = DateTime.utc(2024, 6, 10);
        expect(date.addDays(0), DateTime.utc(2024, 6, 10));
      });

      test('adding negative days subtracts days', () {
        final DateTime date = DateTime.utc(2024, 6, 10);
        expect(date.addDays(-3), DateTime.utc(2024, 6, 7));
      });

      test('adding negative days across a month boundary', () {
        final DateTime date = DateTime.utc(2024, 6, 2);
        expect(date.addDays(-5), DateTime.utc(2024, 5, 28));
      });

      test('result is always UTC', () {
        final DateTime localDate = DateTime(2024, 6, 10, 15, 30);
        final DateTime result = localDate.addDays(1);
        expect(result.isUtc, isTrue);
      });
    });

    group('truncateToMinutes', () {
      test('removes seconds and sub-second components', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30, 45, 500, 100);
        final DateTime result = date.truncateToMinutes();
        expect(result.second, 0);
        expect(result.millisecond, 0);
        expect(result.microsecond, 0);
      });

      test('preserves year, month, day, hour, and minute by default', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30, 45);
        final DateTime result = date.truncateToMinutes();
        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 10);
        expect(result.hour, 14);
        expect(result.minute, 30);
      });

      test('overrides hour when newHour is provided', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30);
        final DateTime result = date.truncateToMinutes(newHour: 9);
        expect(result.hour, 9);
        expect(result.minute, 30);
      });

      test('overrides minute when newMinute is provided', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30);
        final DateTime result = date.truncateToMinutes(newMinute: 15);
        expect(result.hour, 14);
        expect(result.minute, 15);
      });

      test('overrides both hour and minute simultaneously', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30);
        final DateTime result =
            date.truncateToMinutes(newHour: 8, newMinute: 45);
        expect(result.hour, 8);
        expect(result.minute, 45);
      });

      test('newHour of 0 is applied correctly', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30);
        final DateTime result = date.truncateToMinutes(newHour: 0);
        expect(result.hour, 0);
      });

      test('newMinute of 0 is applied correctly', () {
        final DateTime date = DateTime(2024, 6, 10, 14, 30);
        final DateTime result = date.truncateToMinutes(newMinute: 0);
        expect(result.minute, 0);
      });
    });
  });
}
