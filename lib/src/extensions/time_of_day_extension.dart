import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
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
