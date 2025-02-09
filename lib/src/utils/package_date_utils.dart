// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

abstract final class PackageDateUtils {
  static DateTime monthDateOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static int firstDayOffset(
    int year,
    int month,
    int firstDayOfWeekIndex,
  ) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    final int newfirstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - newfirstDayOfWeekIndex) % 7;
  }
}
