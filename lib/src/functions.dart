import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shows a cupertino calendar picker as an overlay above or below the widget.
///
/// It will display a grid of days for the [initialDate]'s month. The day
/// indicated by [initialDate] will be selected.
///
/// The optional [onDisplayedMonthChanged] callback can be used to track
/// the currently displayed month.
///
/// [maximumDate] must be after or equal to [minimumDate].
///
/// [initialDate] must be between [minimumDate] and [maximumDate] or equal to
/// one of them.
///
/// [currentDate] represents the current day (i.e. today). This
/// date will be highlighted in the day grid. If null, the date of
/// `DateTime.now()` will be used.
Future<void> showCupertinoCalendarPicker(
  BuildContext context, {
  /// The widget's render box around which the calendar will be displayed.
  required RenderBox? widgetRenderBox,

  /// The minimum selectable [DateTime].
  required DateTime minimumDate,

  /// The maximum selectable [DateTime].
  required DateTime maximumDate,

  /// Called when the user selects a date in the picker.
  ValueChanged<DateTime>? onDateChanged,

  /// The initially selected [DateTime] that the calendar should display.
  DateTime? initialDate,

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  DateTime? currentDate,

  /// Called when the user navigates to a new month in the picker.
  ValueChanged<DateTime>? onDisplayedMonthChanged,

  /// The spacing from left and right sides of the screen.
  double horizontalSpacing = 15.0,

  /// The spacing from top and bottom sides of the screen.
  double verticalSpacing = 15.0,

  /// The offset from top/bottom of the [widgetRenderBox] location.
  Offset offset = const Offset(0.0, 10.0),
  Color barrierColor = Colors.transparent,
  Color mainColor = CupertinoColors.systemRed,
  CalendarContainerDecoration? containerDecoration,
  CalendarWeekdayDecoration? weekdayDecoration,
  CalendarMonthPickerDecoration? monthPickerDecoration,
  CalendarHeaderDecoration? calendarHeaderDecoration,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: calendarPickerBarrierLabel,
    barrierColor: barrierColor,
    transitionDuration: Duration.zero,
    routeSettings: const RouteSettings(name: calendarPickerRouteName),
    transitionBuilder: (
      BuildContext _,
      Animation<double> __,
      Animation<double> ___,
      Widget child,
    ) {
      return child;
    },
    pageBuilder: (
      BuildContext _,
      Animation<double> __,
      Animation<double> ___,
    ) {
      return CupertinoCalendarOverlay(
        mainColor: mainColor,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
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
