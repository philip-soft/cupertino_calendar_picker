import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../lib.dart';

typedef YearPickerCallback = void Function(bool shouldShowYearPicker);

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.currentMonth,
    required this.onYearPickerStateChanged,
    required this.onPreviousMonthIconTapped,
    required this.onNextMonthIconTapped,
    required this.decoration,
    Key? key,
  }) : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.only(
        top: 9.0,
        bottom: 11.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _handleYearPickerStateChange,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  monthFormat.format(widget.currentMonth),
                  style: TextStyle(
                    color: CupertinoDynamicColor.resolve(
                      _shouldShowYearPicker
                          ? CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.systemRed,
                              darkColor: CupertinoColors.systemRed.darkColor,
                            )
                          : CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.label,
                              darkColor: CupertinoColors.label.darkColor,
                            ),
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4.0),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  turns: _shouldShowYearPicker ? 1.25 : 1.0,
                  child: SizedBox(
                    width: 11.0,
                    height: 22.0,
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      color: widget.decoration.monthDateArrowColor,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onPreviousMonthIconTapped,
                  child: SizedBox(
                    child: Icon(
                      CupertinoIcons.chevron_back,
                      color: _isBackwardDisabled
                          ? _decoration.backwardDisabledButtonColor
                          : _decoration.backwardButtonColor,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onNextMonthIconTapped,
                  child: SizedBox(
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      color: _isForwardDisabled
                          ? _decoration.forwardDisabledButtonColor
                          : _decoration.forwardButtonColor,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: _shouldShowYearPicker
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
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
      ),
    );
  }
}
