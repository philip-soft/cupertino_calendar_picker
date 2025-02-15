// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays a Cupertino-style calendar picker as an overlay above or below the widget.
///
/// The picker allows users to select a date or a date-time depending on the specified mode.
/// It can be positioned relative to the [widgetRenderBox] and supports customizations
/// such as spacing, color, and decorations.
///
/// The method returns a [Future] that resolves to a [DateTime] if a date was selected,
/// or `null` if the picker was dismissed without a selection.
///
/// ## Parameters:
///
/// - [context]:
///   The build context in which the picker will be displayed. This is required to show
///   the overlay.
///
/// - [widgetRenderBox]:
///   The render box of the widget relative to which the calendar picker is displayed.
///   This is required to correctly position the picker. If `null`, the picker
///   might not display correctly.
///
/// - [minimumDateTime]:
///   The earliest selectable [DateTime] in the picker.
///
/// - [maximumDateTime]:
///   The latest selectable [DateTime] in the picker.
///   Must be after or equal to [minimumDateTime].
///
/// - [onDateTimeChanged]:
///   A callback that is triggered whenever the selected [DateTime] changes in the picker.
///
/// - [onDateSelected]:
///   A callback that is triggered when a date is selected by the user. This is useful
///   for handling the final date selection action.
///
/// - [initialDateTime]:
///   The initially selected [DateTime] that the calendar should display when it opens.
///   This must be between [minimumDateTime] and [maximumDateTime], or equal to one of them.
///   If not provided, the calendar will default to `DateTime.now()`.
///
/// - [currentDateTime]:
///   The [DateTime] representing the current day (i.e., today). It will be highlighted
///   in the day grid. If `null`, `DateTime.now()` will be used.
///
/// - [onDisplayedMonthChanged]:
///   A callback that is triggered when the user navigates to a different month in the picker.
///   Useful for tracking the month being displayed.
///
/// - [horizontalSpacing]:
///   The horizontal spacing between the picker and the edges of the screen.
///   Default is [15.0] pixels.
///
/// - [verticalSpacing]:
///   The vertical spacing between the picker and the edges of the screen.
///   Default is [15.0] pixels.
///
/// - [offset]:
///   The offset from the top/bottom of the [widgetRenderBox] location.
///   Default is `Offset(0.0, 10.0)`.
///
/// - [barrierColor]:
///   The color of the barrier that darkens the rest of the screen when
///   the picker is displayed.
///   Default is [Colors.transparent], meaning no darkening occurs.
///
/// - [mainColor]:
///   The primary color used in the calendar picker, typically for highlighting
///   the selected date and other important elements.
///   Default is [CupertinoColors.systemRed].
///
/// - [dismissBehavior]:
///   Determines how the calendar can be dismissed. The default value is
///   [CalendarDismissBehavior.onOutsideTap], allowing dismissal by tapping
///   outside the calendar.
///   The Android back button will always close the calendar.
///
/// - [containerDecoration]:
///   Optional custom decoration for the picker container.
///
/// - [weekdayDecoration]:
///   Optional custom decoration for the weekdays' row in the calendar.
///
/// - [monthPickerDecoration]:
///   Optional custom decoration for the month picker view.
///
/// - [headerDecoration]:
///   Optional custom decoration for the header of the picker.
///
/// - [footerDecoration]:
///   Optional custom decoration for the footer of the picker.
///   Applied for the [dateTime] mode only.
///
/// - [mode]:
///   The mode in which the picker operates. Default is [CupertinoCalendarMode.date].
///   If [CupertinoCalendarMode.dateTime] is used, the picker will also
///   allow selecting time.
///
/// - [timeLabel]:
///   An optional label to be displayed when the calendar is in a mode that includes time selection.
///   [CupertinoCalendarMode.dateTime] mode.
///   This label typically indicates what the selected time is for or provides
///   additional context.
///
/// - [minuteInterval]:
///   The interval of minutes that the time picker should allow, applicable only in
///   [CupertinoCalendarMode.dateTime] mode.
///   The default value is 1 minute, meaning the user can select any minute of the hour.
///
/// - [use24hFormat]:
///   For 24h format being used or not, results in AM/PM being shown or hidden in the widget.
///   Setting to `true` or `false` will force 24h format to be on or off.
///   The default value is null, which calls [MediaQuery.alwaysUse24HourFormatOf].
///
/// - [firstDayOfWeekIndex]:
///   The index of the first day of the week, where 0 represents Sunday.
///   The default value is based on the locale.
///
/// - [actions]:
///   A list of actions that will be displayed at the bottom of the calendar picker.
///   Available actions are [CancelCupertinoCalendarAction], [ConfirmCupertinoCalendarAction].
///   Displayed only when the calendar is in the `compact` mode.
///
/// ## Returns:
///
/// A [Future] that resolves to the selected [DateTime] if a date was chosen, or `null`
/// if the picker was dismissed without a selection.

Future<DateTime?> showCupertinoCalendarPicker(
  BuildContext context, {
  required RenderBox? widgetRenderBox,
  required DateTime minimumDateTime,
  required DateTime maximumDateTime,
  ValueChanged<DateTime>? onDateTimeChanged,
  ValueChanged<DateTime>? onDateSelected,
  DateTime? initialDateTime,
  DateTime? currentDateTime,
  ValueChanged<DateTime>? onDisplayedMonthChanged,
  double horizontalSpacing = 15.0,
  double verticalSpacing = 15.0,
  Offset offset = const Offset(0.0, 10.0),
  Color barrierColor = Colors.transparent,
  Color mainColor = CupertinoColors.systemRed,
  CalendarDismissBehavior dismissBehavior =
      CalendarDismissBehavior.onOutsideTap,
  PickerContainerDecoration? containerDecoration,
  CalendarWeekdayDecoration? weekdayDecoration,
  CalendarMonthPickerDecoration? monthPickerDecoration,
  CalendarHeaderDecoration? headerDecoration,
  CalendarFooterDecoration? footerDecoration,
  CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  String? timeLabel,
  int minuteInterval = 1,
  bool? use24hFormat,
  int? firstDayOfWeekIndex,
  List<CupertinoCalendarAction>? actions,
}) {
  return showGeneralDialog<DateTime?>(
    context: context,
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
        initialDateTime: initialDateTime,
        minimumDateTime: minimumDateTime,
        maximumDateTime: maximumDateTime,
        currentDateTime: currentDateTime,
        onDateTimeChanged: onDateTimeChanged,
        onDateSelected: onDateSelected,
        onDisplayedMonthChanged: onDisplayedMonthChanged,
        containerDecoration: containerDecoration,
        weekdayDecoration: weekdayDecoration,
        monthPickerDecoration: monthPickerDecoration,
        headerDecoration: headerDecoration,
        footerDecoration: footerDecoration,
        dismissBehavior: dismissBehavior,
        mode: mode,
        timeLabel: timeLabel,
        minuteInterval: minuteInterval,
        use24hFormat: use24hFormat ?? context.alwaysUse24hFormat,
        firstDayOfWeekIndex: firstDayOfWeekIndex,
        actions: actions,
      );
    },
  );
}

/// Displays a Cupertino-style time picker as an overlay above or below the widget.
///
/// The picker allows users to select a specific time of day, with optional restrictions
/// on the minimum and maximum selectable times. The picker can be positioned relative
/// to the [widgetRenderBox].
///
/// The method returns a [Future] that resolves to a [TimeOfDay] if a time was selected,
/// or `null` if the picker was dismissed without a selection.
///
/// ## Parameters:
///
/// - [context]:
///   The build context in which the picker will be displayed. This is required to show
///   the overlay.
///
/// - [widgetRenderBox]:
///   The render box of the widget relative to which the time picker is displayed.
///   This is required to correctly position the picker. If `null`, the picker
///   might not display correctly.
///
/// - [minimumTime]:
///   The earliest selectable [TimeOfDay] in the picker. If provided, users will not be able
///   to select a time earlier than this value.
///
/// - [maximumTime]:
///   The latest selectable [TimeOfDay] in the picker. If provided, users will not be able
///   to select a time later than this value. This should be after or equal to [minimumTime].
///
/// - [onTimeChanged]:
///   A callback that is triggered whenever the selected [TimeOfDay] changes in the picker.
///
/// - [initialTime]:
///   The initially selected [TimeOfDay] that the time picker should display when it opens.
///   If not provided, the `TimeOfDay.now()` will be used as the initial selection.
///
/// - [horizontalSpacing]:
///   The horizontal spacing between the picker and the edges of the screen.
///   Default is [15.0] pixels.
///
/// - [verticalSpacing]:
///   The vertical spacing between the picker and the edges of the screen.
///   Default is [15.0] pixels.
///
/// - [offset]:
///   The offset from the top/bottom of the [widgetRenderBox] location.
///   Default is `Offset(0.0, 10.0)`.
///
/// - [barrierColor]:
///   The color of the barrier that darkens the rest of the screen when the picker is displayed.
///   Default is [Colors.transparent], meaning no darkening occurs.
///
/// - [containerDecoration]:
///   Optional custom decoration for the picker container.
///
/// - [minuteInterval]:
///   The interval of minutes that the time picker should allow.
///   The default value is 1 minute, meaning the user can select any minute of the hour.
///
/// - [use24hFormat]:
///   For 24h format being used or not, results in AM/PM being shown or hidden in the widget.
///   Setting to `true` or `false` will force 24h format to be on or off.
///   Can be used as a type of duration picker (limited to 23 hours) when set to `true`.
///   The default value is null, which calls [MediaQuery.alwaysUse24HourFormatOf].
///
/// ## Returns:
///
/// A [Future] that resolves to the selected [TimeOfDay] if a time was chosen, or `null`
/// if the picker was dismissed without a selection.

Future<TimeOfDay?> showCupertinoTimePicker(
  BuildContext context, {
  required RenderBox? widgetRenderBox,
  TimeOfDay? minimumTime,
  TimeOfDay? maximumTime,
  ValueChanged<TimeOfDay>? onTimeChanged,
  TimeOfDay? initialTime,
  double horizontalSpacing = 15.0,
  double verticalSpacing = 15.0,
  Offset offset = const Offset(0.0, 10.0),
  Color barrierColor = Colors.transparent,
  PickerContainerDecoration? containerDecoration,
  int minuteInterval = 1,
  bool? use24hFormat,
}) {
  return showGeneralDialog<TimeOfDay?>(
    context: context,
    barrierLabel: timePickerBarrierLabel,
    barrierColor: barrierColor,
    transitionDuration: Duration.zero,
    routeSettings: const RouteSettings(name: timePickerRouteName),
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
      return CupertinoTimeOverlay(
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
        offset: offset,
        widgetRenderBox: widgetRenderBox,
        initialTime: initialTime,
        minimumTime: minimumTime,
        maximumTime: maximumTime,
        containerDecoration: containerDecoration,
        onTimeChanged: onTimeChanged,
        minuteInterval: minuteInterval,
        use24hFormat: use24hFormat ?? context.alwaysUse24hFormat,
      );
    },
  );
}
