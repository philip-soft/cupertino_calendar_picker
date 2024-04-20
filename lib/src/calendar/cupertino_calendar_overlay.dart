import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
    required this.scaleAligment,
    super.key,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Alignment scaleAligment;

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  AnimationController? _controller;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller!.forward();
    _controller!.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        Navigator.of(context).pop();
      }
    });
  }

  void _onOutsideTap() {
    if (_controller != null) {
      final bool isReverseInProgress =
          _controller!.status == AnimationStatus.reverse;
      if (!isReverseInProgress) {
        _controller?.reverse(from: 0.75);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime nowDate = DateTime.now();

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          child: GestureDetector(
            onTap: _onOutsideTap,
            behavior: HitTestBehavior.translucent,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        Positioned(
          top: widget.top,
          left: widget.left,
          right: widget.right,
          bottom: widget.bottom,
          child: Material(
            color: Colors.transparent,
            child: CupertinoCalendar(
              onInitialized: _onInitialized,
              minimumDate: nowDate.subtract(const Duration(days: 15)),
              initialDate: nowDate,
              currentDate: nowDate,
              maximumDate: DateTime(2030, 02, 14),
              onDateChanged: (_) {},
              scaleAlignment: widget.scaleAligment,
            ),
          ),
        ),
      ],
    );
  }
}
