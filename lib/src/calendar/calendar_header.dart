import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

typedef YearPickerCallback = void Function(bool shouldShowYearPicker);

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.currentMonth,
    required this.onYearPickerStateChanged,
    required this.onPreviousMonthIconTapped,
    required this.onNextMonthIconTapped,
    Key? key,
  }) : super(key: key);

  final DateTime currentMonth;
  final VoidCallback onPreviousMonthIconTapped;
  final VoidCallback onNextMonthIconTapped;
  final YearPickerCallback onYearPickerStateChanged;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _shouldShowYearPicker = false;

  void _handleYearPickerStateChange() {
    setState(() {
      _shouldShowYearPicker = !_shouldShowYearPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat monthFormat = DateFormat('MMMM yyyy');
    return Container(
      margin: const EdgeInsets.only(left: 16.0),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _handleYearPickerStateChange,
            child: SizedBox(
              height: 44.0,
              child: Row(
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
                      letterSpacing: -0.41,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    turns: _shouldShowYearPicker ? 1.25 : 1.0,
                    child: const Icon(
                      CupertinoIcons.chevron_forward,
                      // color: enabledColor,
                      size: 20.0,
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
              key: ValueKey<bool>(_shouldShowYearPicker),
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onPreviousMonthIconTapped,
                  child: const SizedBox(
                    height: 44.0,
                    width: 44.0,
                    child: Icon(
                      CupertinoIcons.chevron_back,
                      // color: backwardButtonColor,
                      size: 26.0,
                    ),
                  ),
                ),
                const SizedBox(width: 2.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onNextMonthIconTapped,
                  child: const SizedBox(
                    height: 44.0,
                    width: 44.0,
                    child: Icon(
                      CupertinoIcons.chevron_forward,
                      // color: forwardButtonColor,
                      size: 26.0,
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: _shouldShowYearPicker
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
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
