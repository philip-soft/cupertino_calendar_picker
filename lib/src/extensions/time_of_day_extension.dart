// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
  }

  /// Returns [date] with its time replaced by this time.
  DateTime onDate(DateTime date) {
    return date.truncateToMinutes(newHour: hour, newMinute: minute);
  }

  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute < other.minute;
    } else {
      return false;
    }
  }

  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute > other.minute;
    } else {
      return false;
    }
  }

  /// Returns this time limited to the inclusive range [minimum]...[maximum].
  ///
  /// A `null` bound does not limit the time.
  TimeOfDay clampTo(TimeOfDay? minimum, TimeOfDay? maximum) {
    if (minimum != null && isBefore(minimum)) return minimum;
    if (maximum != null && isAfter(maximum)) return maximum;
    return this;
  }

  /// Formats the time in the 12-hour format without the day period.
  String timeWithDayPeriodFormat(BuildContext context) {
    return DateFormat('h:mm', context.localeString).format(toDateTime());
  }

  /// Formats the time in the ambient locale.
  ///
  /// When [use24hFormat] is `null`, [MediaQuery.alwaysUse24HourFormatOf]
  /// decides the format.
  String timeFormat(BuildContext context, {required bool? use24hFormat}) {
    final bool use24HoursFormat = use24hFormat ?? context.alwaysUse24hFormat;
    final String locale = context.localeString;
    final DateFormat format = use24HoursFormat
        ? DateFormat.Hm(locale)
        : DateFormat('h:mm a', locale);
    return format.format(toDateTime());
  }
}
