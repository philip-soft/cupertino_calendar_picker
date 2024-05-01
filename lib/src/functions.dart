import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

const String _barrierLabel = 'CupertinoCalendarPickerBarrier';

Future<void> showCupertinoCalendarPicker(
  BuildContext context, {
  required DateTime minimumDate,
  required DateTime maximumDate,
  ValueChanged<DateTime>? onDateChanged,
  DateTime? initialDate,
  DateTime? currentDate,
  ValueChanged<DateTime>? onDisplayedMonthChanged,
  double horizontalSpacing = 10.0,
  Offset offset = const Offset(0.0, 30.0),
  RenderBox? widgetRenderBox,
  CalendarContainerDecoration? containerDecoration,
  CalendarWeekdayDecoration? weekdayDecoration,
  CalendarMonthPickerDecoration? monthPickerDecoration,
  CalendarHeaderDecoration? calendarHeaderDecoration,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: _barrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return child;
    },
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return CupertinoCalendarOverlay(
        horizontalSpacing: horizontalSpacing,
        offset: offset,
        widgetRenderBox: widgetRenderBox,
        initialDate: initialDate,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        currentDate: currentDate,
        onDateChanged: onDateChanged,
        onDisplayedMonthChanged: onDisplayedMonthChanged,
        containerDecoration: containerDecoration,
        weekdayDecoration: weekdayDecoration,
        monthPickerDecoration: monthPickerDecoration,
        calendarHeaderDecoration: calendarHeaderDecoration,
      );
    },
  );
}
