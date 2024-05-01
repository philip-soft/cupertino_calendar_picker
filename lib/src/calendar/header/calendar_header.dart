import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

typedef YearPickerCallback = void Function(bool showYearPicker);

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
  bool _showYearPicker = false;

  CalendarHeaderDecoration get _decoration => widget.decoration;
  bool get _isBackwardDisabled => widget.onPreviousMonthIconTapped == null;
  bool get _isForwardDisabled => widget.onNextMonthIconTapped == null;

  void _handleYearPickerStateChange() {
    setState(() {
      _showYearPicker = !_showYearPicker;
      widget.onYearPickerStateChanged.call(_showYearPicker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final DateTime date = widget.currentMonth;
    final String monthString = localization.datePickerStandaloneMonth(
      date.month,
    );
    final String yearString = localization.datePickerYear(
      date.year,
    );
    final String headerString = '$monthString $yearString';

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
                  headerString,
                  style: _showYearPicker
                      ? _decoration.monthDateStyle?.copyWith(
                          color: _decoration.monthDateArrowColor,
                        )
                      : _decoration.monthDateStyle,
                ),
                const SizedBox(width: 5.0),
                AnimatedRotation(
                  duration: calendarHeaderFadeDuration,
                  curve: Curves.easeInOut,
                  turns: _showYearPicker ? 1.25 : 1.0,
                  child: SizedBox(
                    width: 11.0,
                    height: 22.0,
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      color: _decoration.monthDateArrowColor,
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
          crossFadeState: _showYearPicker
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
