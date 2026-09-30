// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

class CalendarFooter extends StatelessWidget {
  const CalendarFooter({
    required this.time,
    required this.isTimePickerVisible,
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
  final bool isTimePickerVisible;

  /// Called with the time after switching the day period.
  final ValueChanged<TimeOfDay> onTimeChanged;

  /// Called with the requested visibility of the time picker.
  final ValueChanged<bool> onTimePickerStateChanged;
  final CupertinoCalendarType type;
  final String? label;
  final Color mainColor;
  final CalendarFooterDecoration decoration;
  final bool? use24hFormat;

  void _onDayPeriodChanged(DayPeriod? dayPeriod) {
    if (dayPeriod == null || dayPeriod == time.period) return;

    final int hourOfPeriod = time.hour % TimeOfDay.hoursPerPeriod;
    final int periodOffset = dayPeriod == DayPeriod.pm
        ? TimeOfDay.hoursPerPeriod
        : 0;
    onTimeChanged(
      TimeOfDay(hour: hourOfPeriod + periodOffset, minute: time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool use24HoursFormat = use24hFormat ?? context.alwaysUse24hFormat;
    final bool shouldShowDayPeriodSwitcher =
        !use24HoursFormat && type == CupertinoCalendarType.compact;
    final TextStyle timeStyle = decoration.timeStyle.resolveDynamic(context);
    final String timeText = shouldShowDayPeriodSwitcher
        ? time.timeWithDayPeriodFormat(context)
        : time.timeFormat(context, use24hFormat: use24hFormat);
    final String? label = this.label;

    return Column(
      children: <Widget>[
        const CupertinoPickerDivider(),
        const SizedBox(height: calendarFooterTopSpacing),
        Row(
          children: <Widget>[
            if (label != null) ...<Widget>[
              const SizedBox(width: calendarFooterHorizontalSpacing),
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    label,
                    maxLines: 1,
                    style: decoration.timeLabelStyle.resolveDynamic(context),
                  ),
                ),
              ),
            ] else
              const Spacer(),
            const SizedBox(width: calendarFooterHorizontalSpacing),
            CupertinoPickerTapTarget(
              onTap: () => onTimePickerStateChanged(!isTimePickerVisible),
              semanticsLabel:
                  label ??
                  MaterialLocalizations.of(context).timePickerDialHelpText,
              semanticsValue: time.timeFormat(
                context,
                use24hFormat: use24hFormat,
              ),
              isExpanded: isTimePickerVisible,
              child: Container(
                height: calendarFooterTimeButtonHeight,
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(
                    context,
                  ),
                  borderRadius: BorderRadius.circular(
                    calendarFooterTimeButtonRadius,
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: calendarFooterTimeButtonHorizontalPadding,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: innerPickersFadeDuration,
                  style: isTimePickerVisible
                      ? timeStyle.copyWith(
                          color: mainColor.resolveDynamic(context),
                        )
                      : timeStyle,
                  child: Text(timeText),
                ),
              ),
            ),
            if (shouldShowDayPeriodSwitcher) ...<Widget>[
              const SizedBox(width: calendarFooterDayPeriodSpacing),
              CupertinoSlidingSegmentedControl<DayPeriod>(
                onValueChanged: _onDayPeriodChanged,
                groupValue: time.period,
                children: <DayPeriod, Widget>{
                  for (final DayPeriod period in DayPeriod.values)
                    period: _DayPeriodSegment(
                      period: period,
                      isActive: time.period == period,
                      style: decoration.dayPeriodTextStyle.resolveDynamic(
                        context,
                      ),
                    ),
                },
              ),
            ],
            const SizedBox(width: calendarFooterHorizontalSpacing),
          ],
        ),
        const SizedBox(height: calendarFooterBottomSpacing),
      ],
    );
  }
}

class _DayPeriodSegment extends StatelessWidget {
  const _DayPeriodSegment({
    required this.period,
    required this.isActive,
    required this.style,
  });

  final DayPeriod period;
  final bool isActive;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: calendarFooterDayPeriodItemSize,
      height: calendarFooterDayPeriodItemSize,
      child: Center(
        child: Text(
          period.localizedString(context),
          textAlign: TextAlign.center,
          style: style.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
