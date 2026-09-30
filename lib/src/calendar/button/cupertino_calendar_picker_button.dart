// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

typedef CalendarButtonFormatter = String Function(DateTime dateTime);

/// A customizable Cupertino-style button that displays a calendar picker
/// when tapped.
class CupertinoCalendarPickerButton extends StatefulWidget {
  /// Creates a `CupertinoCalendarPickerButton` widget.
  const CupertinoCalendarPickerButton({
    required this.minimumDateTime,
    required this.maximumDateTime,
    this.selectableDayPredicate,
    this.dismissBehavior = CalendarDismissBehavior.onOutsideTap,
    this.initialDateTime,
    this.horizontalSpacing = pickerDefaultHorizontalSpacing,
    this.verticalSpacing = pickerDefaultVerticalSpacing,
    this.offset = pickerDefaultOffset,
    this.barrierColor = Colors.transparent,
    this.mainColor = calendarDefaultMainColor,
    super.key,
    this.onDateTimeChanged,
    this.onDateSelected,
    this.onCompleted,
    this.currentDateTime,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.buttonDecoration,
    this.footerDecoration,
    this.timeLabel,
    this.mode = CupertinoCalendarMode.date,
    this.formatter,
    this.minuteInterval = 1,
    this.onPressed,
    this.use24hFormat,
    this.firstDayOfWeekIndex,
    this.actions,
    this.useRootNavigator = true,
  });

  /// Specifies the earliest date that can be selected by the user
  /// in the calendar picker.
  final DateTime minimumDateTime;

  /// Specifies the latest date that can be selected by the user in the
  /// calendar picker.
  final DateTime maximumDateTime;

  /// A predicate that determines whether a specific day is selectable
  final SelectableDayPredicate? selectableDayPredicate;

  /// A callback that is triggered whenever the selected [DateTime] changes
  /// in the calendar.
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// A callback that is triggered when the user selects a date in the calendar.
  final ValueChanged<DateTime>? onDateSelected;

  /// A callback that is triggered when the user completes the selection.
  final ValueChanged<DateTime?>? onCompleted;

  /// The initially selected [DateTime] that the calendar should display.
  ///
  /// This date is highlighted in the picker and the default date when the picker
  /// is first displayed.
  ///
  /// Defaults to the current date, limited to the
  /// [minimumDateTime]...[maximumDateTime] range.
  final DateTime? initialDateTime;

  /// The [DateTime] value representing today's date, which will be
  /// highlighted within the calendar.
  final DateTime? currentDateTime;

  /// A callback function triggered when the user navigates to a different
  /// month in the calendar picker. It provides the newly displayed [DateTime]
  /// for the first day of the month.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Defines the spacing on the left and right sides of the calendar picker.
  ///
  /// Default is `15.0`.
  final double horizontalSpacing;

  /// Defines the spacing on the top and bottom sides of the calendar picker.
  ///
  /// Default is `15.0`.
  final double verticalSpacing;

  /// The position offset applied to the calendar picker from the top and
  /// bottom edges of this button. This is typically used to adjust the
  /// picker's placement on the screen.
  final Offset offset;

  /// The color of the modal barrier that appears behind the calendar when it
  /// is displayed. This provides a dimmed background to focus
  /// attention on the calendar.
  final Color barrierColor;

  /// The primary color used within the calendar widget.
  /// This color is applied to key elements such as selected dates, highlights,
  /// or the main theme of the calendar.
  final Color mainColor;

  /// The decoration for the main container of the calendar widget.
  final PickerContainerDecoration? containerDecoration;

  /// The decoration applied to the weekday headers (e.g., Mon, Tue, etc.)
  /// in the calendar.
  final CalendarWeekdayDecoration? weekdayDecoration;

  /// The decoration used for the month picker component of the calendar.
  final CalendarMonthPickerDecoration? monthPickerDecoration;

  /// The decoration for the header of the calendar.
  final CalendarHeaderDecoration? headerDecoration;

  /// The decoration for the button.
  final PickerButtonDecoration? buttonDecoration;

  /// The decoration for the footer of the calendar.
  ///
  /// Applied for the [CupertinoCalendarMode.dateTime] mode only.
  final CalendarFooterDecoration? footerDecoration;

  /// The mode of the calendar picker, determining whether it operates in
  /// [CupertinoCalendarMode.date] or [CupertinoCalendarMode.dateTime]
  /// selection mode.
  final CupertinoCalendarMode mode;

  /// The custom formatter of the calendar picker button.
  final CalendarButtonFormatter? formatter;

  /// An optional label to be displayed when the calendar is in a mode that
  /// includes time selection.
  ///
  /// This label typically indicates what the selected time is for or provides
  /// additional context.
  final String? timeLabel;

  /// The interval of minutes that the time picker should allow, applicable
  /// when the calendar is in a mode that includes time selection.
  final int minuteInterval;

  /// A callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// Determines how the calendar can be dismissed.
  /// The default value is [CalendarDismissBehavior.onOutsideTap],
  /// allowing dismissal by tapping outside the calendar.
  /// The Android back button will always close the calendar.
  final CalendarDismissBehavior dismissBehavior;

  /// For 24h format being used or not, results in AM/PM being shown or hidden in the widget.
  /// Setting to `true` or `false` will force 24h format to be on or off.
  /// The default value is null, which calls [MediaQuery.alwaysUse24HourFormatOf].
  ///
  /// Displayed only when the calendar is in a mode that includes time selection.
  final bool? use24hFormat;

  /// The index of the first day of the week, where 0 represents Sunday.
  ///
  /// The default value is based on the locale.
  final int? firstDayOfWeekIndex;

  /// A list of actions that will be displayed at the bottom of the calendar picker.
  ///
  /// Available actions are [CancelCupertinoCalendarAction], [ConfirmCupertinoCalendarAction].
  ///
  /// Displayed only when the calendar is in the [CupertinoCalendarType.compact] mode.
  ///
  /// If the list contains a [ConfirmCupertinoCalendarAction], the button
  /// displays the new date only after the action is pressed.
  final List<CupertinoCalendarAction>? actions;

  /// Whether to use the root navigator for displaying the dialog.
  /// Default is `true`.
  final bool useRootNavigator;

  @override
  State<CupertinoCalendarPickerButton> createState() =>
      _CupertinoCalendarPickerButtonState();
}

class _CupertinoCalendarPickerButtonState
    extends State<CupertinoCalendarPickerButton> {
  late DateTime _selectedDateTime;

  bool get _requiresConfirmation {
    final List<CupertinoCalendarAction> actions =
        widget.actions ?? const <CupertinoCalendarAction>[];
    return actions.any(
      (CupertinoCalendarAction action) =>
          action is ConfirmCupertinoCalendarAction,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _initialDateTime();
  }

  @override
  void didUpdateWidget(CupertinoCalendarPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDateTime != oldWidget.initialDateTime) {
      _selectedDateTime = _initialDateTime();
    } else if (widget.minimumDateTime != oldWidget.minimumDateTime ||
        widget.maximumDateTime != oldWidget.maximumDateTime) {
      _selectedDateTime = _clamp(_selectedDateTime);
    }
  }

  DateTime _initialDateTime() {
    return _clamp(
      widget.initialDateTime ?? widget.minimumDateTime.nowInSameZone(),
    );
  }

  DateTime _clamp(DateTime dateTime) {
    return dateTime.clampTo(widget.minimumDateTime, widget.maximumDateTime);
  }

  Future<DateTime?> _showPicker(RenderBox? renderBox) async {
    final DateTime? result = await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: widget.minimumDateTime,
      initialDateTime: _selectedDateTime,
      currentDateTime: widget.currentDateTime,
      mainColor: widget.mainColor,
      headerDecoration: widget.headerDecoration,
      containerDecoration: widget.containerDecoration,
      monthPickerDecoration: widget.monthPickerDecoration,
      weekdayDecoration: widget.weekdayDecoration,
      footerDecoration: widget.footerDecoration,
      offset: widget.offset,
      maximumDateTime: widget.maximumDateTime,
      barrierColor: widget.barrierColor,
      verticalSpacing: widget.verticalSpacing,
      selectableDayPredicate: widget.selectableDayPredicate,
      horizontalSpacing: widget.horizontalSpacing,
      onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
      mode: widget.mode,
      onDateTimeChanged: _onDateTimeChanged,
      onDateSelected: widget.onDateSelected,
      timeLabel: widget.timeLabel,
      minuteInterval: widget.minuteInterval,
      dismissBehavior: widget.dismissBehavior,
      use24hFormat: widget.use24hFormat,
      firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
      actions: widget.actions,
      useRootNavigator: widget.useRootNavigator,
    );
    if (result != null && mounted) {
      setState(() => _selectedDateTime = result);
    }
    widget.onCompleted?.call(result);
    return result;
  }

  void _onDateTimeChanged(DateTime dateTime) {
    widget.onDateTimeChanged?.call(dateTime);
    if (_requiresConfirmation) return;

    setState(() => _selectedDateTime = dateTime);
  }

  String _format(BuildContext context, DateTime date) {
    final CalendarButtonFormatter? formatter = widget.formatter;
    if (formatter != null) return formatter(date);

    final String dateString = DateFormat.yMMMd(context.localeString)
        .format(date);
    if (widget.mode == CupertinoCalendarMode.date) return dateString;

    final String timeString = TimeOfDay.fromDateTime(date)
        .timeFormat(context, use24hFormat: widget.use24hFormat);
    return '$dateString $timeString';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPickerButton<DateTime?>(
      title: _format(context, _selectedDateTime),
      mainColor: widget.mainColor,
      decoration: widget.buttonDecoration,
      onPressed: widget.onPressed,
      showPickerFunction: _showPicker,
    );
  }
}
