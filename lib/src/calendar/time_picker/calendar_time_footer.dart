import 'package:cupertino_calendar_picker/src/extensions/day_period_extension.dart';
import 'package:cupertino_calendar_picker/src/extensions/time_of_day_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarTimeFooter extends StatefulWidget {
  const CalendarTimeFooter({
    required this.time,
    required this.onTimePickerStateChanged,
    required this.onDayPeriodChanged,
    super.key,
  });

  final TimeOfDay time;
  final ValueChanged<DayPeriod> onDayPeriodChanged;
  final ValueChanged<bool> onTimePickerStateChanged;

  @override
  State<CalendarTimeFooter> createState() => _CalendarTimeFooterState();
}

class _CalendarTimeFooterState extends State<CalendarTimeFooter> {
  bool _showTimePicker = false;

  void _handleTimePickerStateChange() {
    setState(() {
      _showTimePicker = !_showTimePicker;
      widget.onTimePickerStateChanged.call(_showTimePicker);
    });
  }

  void _onDayPeriodChanged(DayPeriod? dayPeriod) {
    if (dayPeriod != null) {
      widget.onDayPeriodChanged(dayPeriod);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimeOfDay time = widget.time;
    final bool use24HoursFormat = MediaQuery.alwaysUse24HourFormatOf(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Divider(
            height: 1.0,
            color: CupertinoColors.separator.resolveFrom(context),
            thickness: 0.3,
          ),
        ),
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
                width: 72.0,
                decoration: BoxDecoration(
                  color:
                      CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: Text(
                  time.customFormat(context),
                  style: TextStyle(
                    color: CupertinoColors.label.resolveFrom(context),
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            if (!use24HoursFormat)
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
