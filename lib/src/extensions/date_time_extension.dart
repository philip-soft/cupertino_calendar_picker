// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:material_ui/material_ui.dart';

extension PackageDateTimeExtension on DateTime {
  DateTime addDays(int days) {
    return DateTime.utc(year, month, day + days);
  }

  /// Drops seconds and smaller units, keeping [isUtc].
  DateTime truncateToMinutes({int? newHour, int? newMinute}) {
    return _withFields(year, month, day, newHour ?? hour, newMinute ?? minute);
  }

  /// Returns this date limited to the inclusive range [minimum]...[maximum].
  DateTime clampTo(DateTime minimum, DateTime maximum) {
    if (isBefore(minimum)) return minimum;
    if (isAfter(maximum)) return maximum;
    return this;
  }

  /// Returns this date moved to [year] and [month], limiting the day to the
  /// number of days in that month.
  DateTime withMonth(int year, int month) {
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    return copyWith(year: year, month: month, day: day.clamp(1, daysInMonth));
  }

  /// Returns the current local wall-clock time, flagged as UTC when this date
  /// is UTC, so that it compares consistently with this date.
  DateTime nowInSameZone() {
    final DateTime now = DateTime.now();
    return _withFields(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  DateTime _withFields(
    int year,
    int month,
    int day, [
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return isUtc
        ? DateTime.utc(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          )
        : DateTime(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          );
  }
}
