// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a compact [CupertinoCalendar] in a [CupertinoPickerOverlay].
///
/// The route completes with:
/// - the selected date when a [ConfirmCupertinoCalendarAction] is pressed or
///   when the overlay closes on date selection;
/// - `null` when a [CancelCupertinoCalendarAction] is pressed;
/// - on an outside tap or the system back gesture, `null` if a
///   [ConfirmCupertinoCalendarAction] is present, otherwise the last changed
///   date (or `null` if nothing changed).
class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.firstDayOfWeekIndex,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    required this.dismissBehavior,
    required this.mode,
    required this.minuteInterval,
    required this.use24hFormat,
    required this.actions,
    this.widgetRenderBox,
    this.selectableDayPredicate,
    this.onDateTimeChanged,
    this.onDateSelected,
    this.currentDateTime,
    this.initialDateTime,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.footerDecoration,
    this.timeLabel,
    super.key,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final DateTime? initialDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
  final SelectableDayPredicate? selectableDayPredicate;
  final DateTime? currentDateTime;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final PickerContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? headerDecoration;
  final CalendarFooterDecoration? footerDecoration;
  final CalendarDismissBehavior dismissBehavior;
  final Color mainColor;
  final CupertinoCalendarMode mode;
  final String? timeLabel;
  final int minuteInterval;
  final bool use24hFormat;
  final int? firstDayOfWeekIndex;
  final List<CupertinoCalendarAction>? actions;

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  DateTime? _changedDateTime;

  @override
  void initState() {
    super.initState();
    assert(
      widget.dismissBehavior != CalendarDismissBehavior.onActionTap ||
          (widget.actions?.isNotEmpty ?? false),
      'CalendarDismissBehavior.onActionTap requires at least one action, '
      'otherwise the calendar can only be closed by the system back gesture.',
    );
  }

  Object? _dismissResult() =>
      widget.actions.requiresConfirmation ? null : _changedDateTime;

  void _onDateTimeChanged(DateTime date) {
    _changedDateTime = date;
    widget.onDateTimeChanged?.call(date);
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    widget.onDateSelected?.call(date);

    if (widget.dismissBehavior.hasDateSelectDismiss) {
      CupertinoPickerOverlayScope.maybeOf(context)?.close(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool withActions = widget.actions?.isNotEmpty ?? false;
    final double height =
        widget.mode.calendarHeight +
        (withActions ? calendarActionsHeight : 0.0);

    return CupertinoPickerOverlay(
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: height,
      width: calendarWidth,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      outsideTapDismissable: widget.dismissBehavior.hasOutsideTapDismiss,
      dismissResult: _dismissResult,
      semanticsLabel: context.materialLocalization.datePickerHelpText,
      child: Builder(
        builder: (BuildContext context) {
          return CupertinoCalendar(
            weekdayDecoration: widget.weekdayDecoration,
            monthPickerDecoration: widget.monthPickerDecoration,
            footerDecoration: widget.footerDecoration,
            headerDecoration: widget.headerDecoration,
            minimumDateTime: widget.minimumDateTime,
            initialDateTime: widget.initialDateTime,
            currentDateTime: widget.currentDateTime,
            maximumDateTime: widget.maximumDateTime,
            selectableDayPredicate: widget.selectableDayPredicate,
            onDateTimeChanged: _onDateTimeChanged,
            onDateSelected: (DateTime date) => _onDateSelected(context, date),
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
            mainColor: widget.mainColor,
            mode: widget.mode,
            timeLabel: widget.timeLabel,
            type: CupertinoCalendarType.compact,
            minuteInterval: widget.minuteInterval,
            use24hFormat: widget.use24hFormat,
            firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
            actions: widget.actions,
          );
        },
      ),
    );
  }
}
