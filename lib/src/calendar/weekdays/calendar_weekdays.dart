// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({required this.decoration, super.key});

  final CalendarWeekdayDecoration decoration;

  List<Widget> _weekdays(BuildContext context) {
    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      context.materialLocalization,
    );
    final DateTime firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    return List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final DateTime date = firstDayOfWeekDate.addDays(index);
      final String weekday = DateFormat.E(context.localeString).format(date);

      return Expanded(
        child: CalendarWeekday(
          weekday: weekday.toUpperCase(),
          decoration: decoration,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: calendarWeekdaysHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: calendarWeekdaysHorizontalPadding,
      ),
      child: Row(
        children: _weekdays(context),
      ),
    );
  }
}
