// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.widgetRenderBox,
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    required this.dismissBehavior,
    required this.mode,
    required this.minuteInterval,
    required this.use24hFormat,
    this.onDateTimeChanged,
    this.onDateSelected,
    this.currentDateTime,
    this.initialDateTime,
    super.key,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.footerDecoration,
    this.timeLabel,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final DateTime? initialDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
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

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  AnimationController? _controller;
  DateTime? _selectedDateTime;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    _controller?.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop(_selectedDateTime);
    }
  }

  void _closeOverlay() {
    if (_controller != null) {
      final bool isReverseInProgress =
          _controller!.status == AnimationStatus.reverse;
      if (!isReverseInProgress) {
        _controller?.reverse(from: 0.75);
      }
    }
  }

  void _onDateTimeChanged(DateTime date) {
    _selectedDateTime = date;
    widget.onDateTimeChanged?.call(date);
  }

  void _onDateSelected(DateTime date) {
    _selectedDateTime = date;
    widget.onDateSelected?.call(date);

    if (widget.dismissBehavior.hasDateSelectDismiss) {
      _closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = switch (widget.mode) {
      CupertinoCalendarMode.date => calendarDatePickerHeight,
      CupertinoCalendarMode.dateTime => calendarDateTimePickerHeight,
    };

    return CupertinoPickerOverlay(
      onInitialized: _onInitialized,
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: height,
      width: calendarWidth,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      outsideTapDismissable: widget.dismissBehavior.hasOusideTapDismiss,
      child: CupertinoCalendar(
        weekdayDecoration: widget.weekdayDecoration,
        monthPickerDecoration: widget.monthPickerDecoration,
        footerDecoration: widget.footerDecoration,
        headerDecoration: widget.headerDecoration,
        minimumDateTime: widget.minimumDateTime,
        initialDateTime: widget.initialDateTime,
        currentDateTime: widget.currentDateTime,
        maximumDateTime: widget.maximumDateTime,
        onDateTimeChanged: _onDateTimeChanged,
        onDateSelected: _onDateSelected,
        onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
        mainColor: widget.mainColor,
        mode: widget.mode,
        timeLabel: widget.timeLabel,
        type: CupertinoCalendarType.compact,
        minuteInterval: widget.minuteInterval,
        use24hFormat: widget.use24hFormat,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
