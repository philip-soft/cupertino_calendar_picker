// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
  }

  DateTime toNowDateTime() {
    return DateTime.now().truncateToMinutes(newHour: hour, newMinute: minute);
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

  String customFormat(BuildContext context) {
    final bool use24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);
    final String formattedTime = format(context);
    if (use24HoursFormat) {
      return formattedTime;
    } else {
      final int spaceIndex = formattedTime.indexOf(' ');
      return formattedTime.replaceRange(spaceIndex, null, '');
    }
  }
}
