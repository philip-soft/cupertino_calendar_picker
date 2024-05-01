import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

typedef YearPickerCallback = void Function(bool shouldShowYearPicker);

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.currentMonth,
    required this.onYearPickerStateChanged,
    required this.onPreviousMonthIconTapped,
    required this.onNextMonthIconTapped,
    required this.decoration,
    super.key,
  });

  final DateTime currentMonth;
  final VoidCallback? onPreviousMonthIconTapped;
  final VoidCallback? onNextMonthIconTapped;
  final YearPickerCallback onYearPickerStateChanged;
  final CalendarHeaderDecoration decoration;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _shouldShowYearPicker = false;

  void _handleYearPickerStateChange() {
    setState(() {
      _shouldShowYearPicker = !_shouldShowYearPicker;
      widget.onYearPickerStateChanged.call(_shouldShowYearPicker);
    });
  }

  CalendarHeaderDecoration get _decoration => widget.decoration;
  bool get _isBackwardDisabled => widget.onPreviousMonthIconTapped == null;
  bool get _isForwardDisabled => widget.onNextMonthIconTapped == null;

  @override
  Widget build(BuildContext context) {
    final DateFormat monthFormat = DateFormat('MMMM yyyy');

    return Row(
      children: <Widget>[
        const SizedBox(width: 20.0),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _handleYearPickerStateChange,
          child: SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                Text(
                  monthFormat.format(widget.currentMonth),
                  style: widget.decoration.monthDateStyle,
                ),
                const SizedBox(width: 5.0),
                AnimatedRotation(
                  duration: calendarHeaderFadeDuration,
                  curve: Curves.easeInOut,
                  turns: _shouldShowYearPicker ? 1.25 : 1.0,
                  child: SizedBox(
                    width: 11.0,
                    height: 22.0,
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      color: widget.decoration.monthDateArrowColor,
                      size: calendarMonthPickerIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onPreviousMonthIconTapped,
                child: SizedBox(
                  height: calendarMonthSwitcherSize,
                  width: calendarMonthSwitcherSize,
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: _isBackwardDisabled
                        ? _decoration.backwardDisabledButtonColor
                        : _decoration.backwardButtonColor,
                    size: calendarMonthSwitcherIconSize,
                  ),
                ),
              ),
              const SizedBox(width: 2.0),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onNextMonthIconTapped,
                child: SizedBox(
                  height: calendarMonthSwitcherSize,
                  width: calendarMonthSwitcherSize,
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    color: _isForwardDisabled
                        ? _decoration.forwardDisabledButtonColor
                        : _decoration.forwardButtonColor,
                    size: calendarMonthSwitcherIconSize,
                  ),
                ),
              ),
            ],
          ),
          crossFadeState: _shouldShowYearPicker
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: calendarHeaderFadeDuration,
          layoutBuilder: (
            Widget topChild,
            Key topChildKey,
            Widget bottomChild,
            Key bottomChildKey,
          ) {
            return Stack(
              children: <Widget>[
                bottomChild,
                topChild,
              ],
            );
          },
        ),
      ],
    );
  }
}
