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
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  Future<void> _onTap() {
    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    return showCupertinoCalendarPicker(
      context,
      horizontalSpacing: widget.calendarHorizontalSpacing,
      offset: widget.calendarOffset,
      widgetRenderBox: renderBox,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
