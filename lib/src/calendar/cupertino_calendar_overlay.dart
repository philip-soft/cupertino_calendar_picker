import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    this.horizontalSpacing = 10.0,
    this.offset = const Offset(0.0, 30.0),
    this.widgetRenderBox,
    super.key,
  });

  final double horizontalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;

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
    final RenderBox? renderBox = widget.widgetRenderBox;
    final double horizontalSpacing = widget.horizontalSpacing;
    final Offset offset = widget.offset;

    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final Offset position =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Size widgetSize = renderBox?.size ?? Size.zero;
    final double widgetWidth = widgetSize.width;
    final double widgetHeight = widgetSize.height;
    final double widgetHalfWidth = widgetWidth / 2;
    final double widgetHalfHeight = widgetHeight / 2;
    final double widgetCenterY = position.dy + widgetHalfHeight;
    final double widgetCenterX = position.dx + widgetHalfWidth;

    final double spaceOnTop = widgetCenterY;
    final double spaceOnLeft = widgetCenterX - horizontalSpacing;
    final double spaceOnRight = screenWidth - widgetCenterX - horizontalSpacing;
    final double spaceOnBottom = screenHeight - widgetCenterY;
    final bool moreSpaceOnTop = spaceOnTop >= spaceOnBottom;
    final bool moreSpaceOnLeft = spaceOnLeft >= spaceOnRight;

    double? top;
    double? left;
    double? right;
    double? bottom;

    if (moreSpaceOnTop) {
      top = widgetCenterY - calendarHeight - offset.dy;
    } else {
      top = widgetCenterY + offset.dy;
    }

    if (moreSpaceOnLeft) {
      left = widgetCenterX - calendarWidth;
      left = left < horizontalSpacing ? horizontalSpacing : left;
    } else {
      final bool isNotFitOnRight = spaceOnRight <= calendarWidth;
      if (isNotFitOnRight) {
        right = horizontalSpacing;
      } else {
        left = widgetCenterX;
      }
    }

    final double space = moreSpaceOnLeft ? spaceOnLeft : spaceOnRight;
    double xAlignment = space / calendarWidth;

    if (moreSpaceOnLeft) {
      xAlignment = xAlignment > 1 ? 1.0 : xAlignment;
    } else {
      xAlignment = xAlignment > 1 ? -1.0 : -xAlignment;
    }

    final Alignment scaleAligment = Alignment(
      xAlignment,
      moreSpaceOnTop ? 1.0 : -1.0,
    );

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
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Material(
            color: Colors.transparent,
            child: CupertinoCalendar(
              onInitialized: _onInitialized,
              minimumDate: nowDate.subtract(const Duration(days: 15)),
              initialDate: nowDate,
              currentDate: nowDate,
              maximumDate: DateTime(2030, 02, 14),
              onDateChanged: (_) {},
              scaleAlignment: scaleAligment,
            ),
          ),
        ),
      ],
    );
  }
}
