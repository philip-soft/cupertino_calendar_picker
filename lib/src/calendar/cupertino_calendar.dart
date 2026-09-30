// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

/// A widget that displays an inline Cupertino-style calendar.
///
/// This widget provides a calendar interface that allows users to select dates or date-time
/// combinations, depending on the mode.
class CupertinoCalendar extends StatefulWidget {
  /// Creates a `CupertinoCalendar` widget.
  ///
  /// [maximumDateTime] must be on or after [minimumDateTime], and
  /// [initialDateTime], when provided, must be within that range.
  ///
  /// [actions] must contain one or two actions and are only available in the
  /// [CupertinoCalendarType.compact] type.
  const CupertinoCalendar({
    required this.minimumDateTime,
    required this.maximumDateTime,
    this.mainColor = calendarDefaultMainColor,
    this.mode = CupertinoCalendarMode.date,
    this.type = CupertinoCalendarType.inline,
    this.onDateTimeChanged,
    this.onDateSelected,
    this.initialDateTime,
    this.selectableDayPredicate,
    this.currentDateTime,
    this.onDisplayedMonthChanged,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.footerDecoration,
    this.timeLabel,
    this.minuteInterval = 1,
    this.maxWidth = double.infinity,
    this.use24hFormat,
    this.firstDayOfWeekIndex,
    this.actions,
    super.key,
  });

  /// The initially selected [DateTime] that the calendar should display.
  ///
  /// This date is highlighted in the picker and the default date when the picker
  /// is first displayed.
  ///
  /// Defaults to the current date, limited to the
  /// [minimumDateTime]...[maximumDateTime] range.
  final DateTime? initialDateTime;

  /// The earliest selectable [DateTime] in the picker.
  ///
  /// This date must be on or before the [maximumDateTime].
  final DateTime minimumDateTime;

  /// The latest selectable [DateTime] in the picker.
  ///
  /// This date must be on or after the [minimumDateTime].
  final DateTime maximumDateTime;

  /// A predicate that determines whether a day is selectable.
  ///
  /// Days for which it returns `false` are displayed as disabled.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The date highlighted as today.
  ///
  /// Defaults to [DateTime.now].
  final DateTime? currentDateTime;

  /// A callback that is triggered whenever the selected [DateTime] changes
  /// in the calendar, including changes of the month, the year and the time,
  /// and when a changed range limits the selection.
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// A callback that is triggered when the user taps a day in the calendar.
  final ValueChanged<DateTime>? onDateSelected;

  /// A callback that is triggered when the user navigates to a different month in the calendar.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Custom decoration for the weekdays' row in the calendar.
  final CalendarWeekdayDecoration? weekdayDecoration;

  /// Custom decoration for the month picker view.
  final CalendarMonthPickerDecoration? monthPickerDecoration;

  /// Custom decoration for the header of the calendar.
  final CalendarHeaderDecoration? headerDecoration;

  /// Custom decoration for the footer of the calendar.
  ///
  /// Applied for the [CupertinoCalendarMode.dateTime] mode only.
  final CalendarFooterDecoration? footerDecoration;

  /// The primary color used in the calendar picker, typically for highlighting
  /// the selected date and other important elements.
  ///
  /// The default color is [CupertinoColors.systemRed].
  final Color mainColor;

  /// The mode in which the picker operates.
  ///
  /// This defines whether the picker allows selection of just the date or both date and time.
  final CupertinoCalendarMode mode;

  /// The type of the calendar.
  ///
  /// Only the [CupertinoCalendarType.compact] type displays [actions] and
  /// the AM/PM switcher in the 12-hour format.
  ///
  /// The default type is [CupertinoCalendarType.inline].
  final CupertinoCalendarType type;

  /// The maximum width of the calendar widget.
  ///
  /// The default value is [double.infinity], meaning the widget can expand
  /// to fill available space. The calendar is never narrower than `320.0`.
  final double maxWidth;

  /// An optional label displayed next to the time in the
  /// [CupertinoCalendarMode.dateTime] mode.
  ///
  /// This label typically indicates what the selected time is for or provides additional context.
  final String? timeLabel;

  /// The interval of minutes that the time picker should allow, applicable
  /// when the calendar is in a mode that includes time selection.
  final int minuteInterval;

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
  /// Outside of an overlay, pressing an action only calls its `onPressed`.
  final List<CupertinoCalendarAction>? actions;

  @override
  State<CupertinoCalendar> createState() => _CupertinoCalendarState();
}

class _CupertinoCalendarState extends State<CupertinoCalendar> {
  late DateTime _selectedDateTime;

  /// The month the month pages are asked to display.
  ///
  /// It follows the user's swipes without a rebuild, and a rebuild with
  /// a different month makes the month pages jump to it.
  late DateTime _requestedMonth;

  @override
  void initState() {
    super.initState();
    _debugAssertIsValid();
    _debugAssertValidInitialDateTime();
    _initializeSelection();
  }

  @override
  void didUpdateWidget(CupertinoCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debugAssertIsValid();

    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _debugAssertValidInitialDateTime();
      _initializeSelection();
    } else if (oldWidget.minimumDateTime != widget.minimumDateTime ||
        oldWidget.maximumDateTime != widget.maximumDateTime) {
      _clampSelectionToRange();
    }
  }

  /// Limits the selection to a changed range and reports it if it moved.
  ///
  /// The displayed month is kept, the month pages limit it to the new range.
  void _clampSelectionToRange() {
    final DateTime selected = _clamp(_selectedDateTime);
    if (selected == _selectedDateTime) return;

    _selectedDateTime = selected;
    // Listeners may call setState, which is not allowed during this build.
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) widget.onDateTimeChanged?.call(selected);
    });
  }

  void _debugAssertIsValid() {
    assert(
      !widget.maximumDateTime.isBefore(widget.minimumDateTime),
      'maximumDateTime ${widget.maximumDateTime} must be on or after '
      'minimumDateTime ${widget.minimumDateTime}.',
    );
    final List<CupertinoCalendarAction>? actions = widget.actions;
    assert(
      actions == null || (actions.isNotEmpty && actions.length <= 2),
      'The actions list must contain one or two actions.',
    );
    assert(
      actions == null || widget.type == CupertinoCalendarType.compact,
      'Actions are only available in the compact calendar type.',
    );
  }

  /// The initial date is only validated when it is applied, so that the range
  /// can later shrink past it; the selection is then limited to the range.
  void _debugAssertValidInitialDateTime() {
    final DateTime? initialDateTime = widget.initialDateTime;
    assert(
      initialDateTime == null ||
          !initialDateTime.isBefore(widget.minimumDateTime),
      'initialDateTime $initialDateTime must be on or after '
      'minimumDateTime ${widget.minimumDateTime}.',
    );
    assert(
      initialDateTime == null ||
          !initialDateTime.isAfter(widget.maximumDateTime),
      'initialDateTime $initialDateTime must be on or before '
      'maximumDateTime ${widget.maximumDateTime}.',
    );
  }

  void _initializeSelection() {
    _selectedDateTime = _clamp(
      widget.initialDateTime ?? widget.minimumDateTime.nowInSameZone(),
    );
    _requestedMonth = PackageDateUtils.monthDateOnly(_selectedDateTime);
  }

  DateTime _clamp(DateTime dateTime) {
    return dateTime.clampTo(widget.minimumDateTime, widget.maximumDateTime);
  }

  void _select(DateTime dateTime) {
    final DateTime selected = _clamp(dateTime);
    setState(() => _selectedDateTime = selected);
    widget.onDateTimeChanged?.call(selected);
  }

  void _onDisplayedMonthChanged(DateTime month) {
    // A jump requested by this state has already been reported.
    if (DateUtils.isSameMonth(month, _requestedMonth)) return;
    _requestedMonth = month;
    widget.onDisplayedMonthChanged?.call(month);
  }

  void _onYearPickerChanged(DateTime monthDate) {
    final DateTime selected = _clamp(
      _selectedDateTime.withMonth(monthDate.year, monthDate.month),
    );
    _onDisplayedMonthChanged(PackageDateUtils.monthDateOnly(selected));
    _select(selected);
  }

  void _onDateChanged(DateTime dateTime) {
    _select(dateTime);
    widget.onDateSelected?.call(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final bool withActions = widget.actions?.isNotEmpty ?? false;
    final double height =
        widget.mode.calendarHeight +
        (withActions ? calendarActionsHeight : 0.0);
    final double maxWidth = max(widget.maxWidth, calendarWidth);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height,
        maxHeight: height,
        minWidth: calendarWidth,
        maxWidth: maxWidth,
      ),
      child: CupertinoCalendarPicker(
        initialMonth: _requestedMonth,
        currentDateTime: widget.currentDateTime ?? DateTime.now(),
        minimumDateTime: widget.minimumDateTime,
        maximumDateTime: widget.maximumDateTime,
        selectableDayPredicate: widget.selectableDayPredicate,
        selectedDateTime: _selectedDateTime,
        firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
        onDateChanged: _onDateChanged,
        onTimeChanged: _select,
        onDisplayedMonthChanged: _onDisplayedMonthChanged,
        onYearPickerChanged: _onYearPickerChanged,
        mainColor: widget.mainColor,
        weekdayDecoration:
            widget.weekdayDecoration ??
            CalendarWeekdayDecoration.withDynamicColor(context),
        monthPickerDecoration:
            widget.monthPickerDecoration ??
            CalendarMonthPickerDecoration.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            ),
        headerDecoration:
            widget.headerDecoration ??
            CalendarHeaderDecoration.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            ),
        footerDecoration:
            widget.footerDecoration ??
            CalendarFooterDecoration.withDynamicColor(context),
        mode: widget.mode,
        type: widget.type,
        timeLabel: widget.timeLabel,
        minuteInterval: widget.minuteInterval,
        use24hFormat: widget.use24hFormat ?? context.alwaysUse24hFormat,
        actions: widget.actions,
      ),
    );
  }
}
