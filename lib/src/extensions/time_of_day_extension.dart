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

  String timeWithDayPeriodFormat(BuildContext context) {
    final MaterialLocalizations localizations = context.materialLocalization;
    final String formattedTime = localizations.formatTimeOfDay(this);
    final int spaceIndex = formattedTime.indexOf(' ');
    return formattedTime.replaceRange(spaceIndex, null, '');
  }

  String timeFormat(
    BuildContext context, {
    required bool? use24hFormat,
  }) {
    final MaterialLocalizations localizations = context.materialLocalization;
    final bool use24HoursFormat = use24hFormat ?? context.alwaysUse24hFormat;
    return localizations.formatTimeOfDay(
      this,
      alwaysUse24HourFormat: use24HoursFormat,
    );
  }
}
