// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

extension PackageDateTimeExtension on DateTime {
  DateTime addDays(int days) {
    return DateTime.utc(year, month, day + days);
  }

  DateTime truncateToMinutes({int? newHour, int? newMinute}) {
    return DateTime(year, month, day, newHour ?? hour, newMinute ?? minute);
  }
}
