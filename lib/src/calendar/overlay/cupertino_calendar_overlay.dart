import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.minimumDate,
    required this.maximumDate,
    required this.horizontalSpacing,
    required this.offset,
    this.onDateChanged,
    this.currentDate,
    this.initialDate,
    super.key,
    this.widgetRenderBox,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.calendarHeaderDecoration,
  });

  final double horizontalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final DateTime? initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final CalendarContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? calendarHeaderDecoration;

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  AnimationController? _controller;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    _controller?.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop();
    }
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
    final double spaceOnRight = screenWidth - spaceOnLeft;
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
    double xAlignment = ((space / calendarWidth) - 0.5) * 2;

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
              weekdayDecoration: widget.weekdayDecoration,
              monthPickerDecoration: widget.monthPickerDecoration,
              calendarHeaderDecoration: widget.calendarHeaderDecoration,
              minimumDate: widget.minimumDate,
              initialDate: widget.initialDate,
              currentDate: widget.currentDate,
              maximumDate: widget.maximumDate,
              onDateChanged: widget.onDateChanged,
              onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
              scaleAlignment: scaleAligment,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
