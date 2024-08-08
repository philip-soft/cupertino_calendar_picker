import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
  }

  DateTime toNowDateTime() {
    return DateTime.now().copyWith(
      hour: hour,
      minute: minute,
    );
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
