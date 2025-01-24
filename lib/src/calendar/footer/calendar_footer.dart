// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarFooter extends StatefulWidget {
  const CalendarFooter({
    required this.time,
    required this.onTimePickerStateChanged,
    required this.onTimeChanged,
    required this.type,
    required this.label,
    required this.mainColor,
    required this.decoration,
    required this.use24hFormat,
    super.key,
  });

  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<bool> onTimePickerStateChanged;
  final CupertinoCalendarType type;
  final String? label;
  final Color mainColor;
  final CalendarFooterDecoration decoration;
  final bool? use24hFormat;

  @override
  State<CalendarFooter> createState() => _CalendarFooterState();
}

class _CalendarFooterState extends State<CalendarFooter> {
  late TimeOfDay _timeOfDay;
  bool _showTimePicker = false;

  @override
  void initState() {
    super.initState();
    _timeOfDay = widget.time;
  }

  @override
  void didUpdateWidget(covariant CalendarFooter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.time != oldWidget.time) {
      _timeOfDay = widget.time;
    }
  }

  void _handleTimePickerStateChange() {
    setState(() {
      _showTimePicker = !_showTimePicker;
      widget.onTimePickerStateChanged.call(_showTimePicker);
    });
  }

  void _onDayPeriodChanged(DayPeriod? dayPeriod) {
    if (dayPeriod != null) {
      setState(() {
        final int newHour =
            _timeOfDay.hour % 12 + (dayPeriod == DayPeriod.pm ? 12 : 0);
        _timeOfDay = TimeOfDay(
          hour: newHour,
          minute: _timeOfDay.minute,
        );
        widget.onTimeChanged(_timeOfDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimeOfDay time = _timeOfDay;
    final bool use24HoursFormat =
        widget.use24hFormat ?? context.alwaysUse24hFormat;
    final bool shouldShowDayPeriodSwitcher =
        !use24HoursFormat && widget.type == CupertinoCalendarType.compact;

    return Column(
      children: <Widget>[
        const CupertinoPickerDivider(),
        const SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            if (widget.label != null) ...<Widget>[
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.label!,
                  maxLines: 1,
                  style: widget.decoration.timeLabelStyle,
                ),
              ),
            ] else
              const Spacer(),
            const SizedBox(width: 16.0),
            GestureDetector(
              onTap: _handleTimePickerStateChange,
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 34.0,
                decoration: BoxDecoration(
                  color:
                      CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: AnimatedDefaultTextStyle(
                  duration: innerPickersFadeDuration,
                  style: widget.decoration.timeStyle!.copyWith(
                    color: _showTimePicker
                        ? widget.mainColor
                        : widget.decoration.timeStyle?.color,
                  ),
                  child: Text(
                    shouldShowDayPeriodSwitcher
                        ? time.timeWithDayPeriodFormat(context)
                        : time.timeFormat(
                            context,
                            use24hFormat: widget.use24hFormat,
                          ),
                  ),
                ),
              ),
            ),
            if (shouldShowDayPeriodSwitcher) ...<Widget>[
              const SizedBox(width: 8.0),
              CupertinoSlidingSegmentedControl<DayPeriod>(
                onValueChanged: _onDayPeriodChanged,
                groupValue: time.period,
                children:
                    DayPeriod.values.asMap().map((int index, DayPeriod period) {
                  final bool isActive = time.period == period;

                  return MapEntry<DayPeriod, Widget>(
                    period,
                    SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: Center(
                        child: Text(
                          period.localizedString(context),
                          textAlign: TextAlign.center,
                          style: widget.decoration.dayPeriodTextStyle?.copyWith(
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 7.0),
      ],
    );
  }
}
