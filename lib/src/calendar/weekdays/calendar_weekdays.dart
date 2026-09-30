// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({
    required this.decoration,
    required this.firstDayOfWeekIndex,
    super.key,
  });

  final CalendarWeekdayDecoration decoration;
  final int? firstDayOfWeekIndex;

  List<Widget> _weekdays(BuildContext context) {
    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = PackageDateUtils.firstDayOffset(
      year,
      month,
      firstDayOfWeekIndex ?? context.materialLocalization.firstDayOfWeekIndex,
    );
    final DateTime firstDayOfWeekDate = DateTime.utc(
      year,
      month,
      1 - firstDayOffset,
    );
    // The narrow format is the locale's one-letter form, which the first
    // letter of the abbreviation is not in every locale, e.g. "周一" in Chinese.
    final DateFormat format =
        context.textScaleFactor > calendarFormatChangeTextScaleFactor
        ? DateFormat.EEEEE(context.localeString)
        : DateFormat.E(context.localeString);
    return List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final DateTime date = firstDayOfWeekDate.addDays(index);

      return Expanded(
        child: CalendarWeekday(
          weekday: format.format(date).toUpperCase(),
          decoration: decoration,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Day cells announce their full date, so the abbreviated weekdays
    // would only add noise for screen readers.
    return ExcludeSemantics(
      child: Container(
        height: calendarWeekdaysHeight,
        margin: const EdgeInsets.symmetric(
          horizontal: calendarWeekdaysHorizontalPadding,
        ),
        child: Row(children: _weekdays(context)),
      ),
    );
  }
}
