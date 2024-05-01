import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarButton extends StatefulWidget {
  const CupertinoCalendarButton({
    required this.child,
    required this.onPressed,
    this.calendarHorizontalSpacing = 10.0,
    this.calendarOffset = const Offset(0.0, 30.0),
    super.key,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Offset calendarOffset;
  final double calendarHorizontalSpacing;

  @override
  State<CupertinoCalendarButton> createState() =>
      _CupertinoCalendarButtonState();
}

class _CupertinoCalendarButtonState extends State<CupertinoCalendarButton> {
  Future<void> _onTap() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      horizontalSpacing: widget.calendarHorizontalSpacing,
      offset: widget.calendarOffset,
      widgetRenderBox: renderBox,
      minimumDate: nowDate.subtract(const Duration(days: 15)),
      initialDate: nowDate,
      currentDate: nowDate,
      maximumDate: DateTime(2030, 5, 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
