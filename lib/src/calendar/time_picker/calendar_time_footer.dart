import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarTimeFooter extends StatefulWidget {
  const CalendarTimeFooter({
    required this.time,
    required this.onTimePickerStateChanged,
    required this.onTimeChanged,
    required this.type,
    super.key,
  });

  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<bool> onTimePickerStateChanged;
  final CupertinoCalendarType type;

  @override
  State<CalendarTimeFooter> createState() => _CalendarTimeFooterState();
}

class _CalendarTimeFooterState extends State<CalendarTimeFooter> {
  late TimeOfDay _timeOfDay;
  bool _showTimePicker = false;

  @override
  void initState() {
    super.initState();
    _timeOfDay = widget.time;
  }

  @override
  void didUpdateWidget(covariant CalendarTimeFooter oldWidget) {
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
        final int newHour = dayPeriod == DayPeriod.pm ? 12 : -12;
        _timeOfDay = TimeOfDay(
          hour: _timeOfDay.hour + newHour,
          minute: _timeOfDay.minute,
        );
        widget.onTimeChanged(_timeOfDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimeOfDay time = _timeOfDay;
    final bool use24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);
    final bool shouldShowSegments =
        !use24HoursFormat && widget.type == CupertinoCalendarType.compact;

    return Column(
      children: <Widget>[
        const CupertinoPickerDivider(),
        const SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            const SizedBox(width: 16.0),
            const Spacer(),
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
                child: Text(
                  shouldShowSegments
                      ? time.customFormat(context)
                      : time.format(context),
                  style: TextStyle(
                    color: CupertinoColors.label.resolveFrom(context),
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            if (shouldShowSegments)
              CupertinoSlidingSegmentedControl<DayPeriod>(
                onValueChanged: _onDayPeriodChanged,
                groupValue: time.period,
                children:
                    DayPeriod.values.asMap().map((int index, DayPeriod period) {
                  final bool isActive = time.period == period;

                  return MapEntry<DayPeriod, Widget>(
                    period,
                    SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Center(
                        child: Text(
                          period.localizedString(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 7.0),
      ],
    );
  }
}
