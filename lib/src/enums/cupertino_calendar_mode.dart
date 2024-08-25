// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// Specifies the mode of the Cupertino calendar.
///
/// This enum defines whether the calendar allows selection of just the date
/// or both date and time, altering the available UI elements and interactions.
enum CupertinoCalendarMode {
  /// The calendar is in date-only mode.
  ///
  /// In this mode, users can only select a date (year, month, and day) without
  /// any time selection.
  date,

  /// The calendar is in date-time mode.
  ///
  /// In this mode, users can select both a date (year, month, day) and a time
  /// (hours, minutes), providing a complete date-time selection experience.
  dateTime;
}
