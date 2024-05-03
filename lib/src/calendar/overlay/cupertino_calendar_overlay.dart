import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.minimumDate,
    required this.maximumDate,
    required this.horizontalSpacing,
    required this.offset,
    required this.mainColor,
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
  final Color mainColor;

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

    final Offset widgetPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Size widgetSize = renderBox?.size ?? Size.zero;
    final double widgetWidth = widgetSize.width;
    final double widgetHeight = widgetSize.height;
    final double widgetHalfWidth = widgetWidth / 2;
    final double widgetHalfHeight = widgetHeight / 2;
    final double widgetCenterY = widgetPosition.dy + widgetHalfHeight;
    final double widgetCenterX = widgetPosition.dx + widgetHalfWidth;

    final double spaceOnTop = widgetCenterY;
    final double spaceOnLeft = widgetCenterX - horizontalSpacing;
    final double spaceOnRight = screenWidth - widgetCenterX - horizontalSpacing;
    final double spaceOnBottom = screenHeight - widgetCenterY;

    const double calendarHalfWidth = calendarWidth / 2;
    final bool fitsOnTop = spaceOnTop >= spaceOnBottom;
    final bool fitsOnLeft = spaceOnLeft >= calendarHalfWidth;
    final bool fitsOnRight = spaceOnRight >= calendarHalfWidth;
    final bool fitsHorizontally = fitsOnLeft && fitsOnRight;

    double? top;
    double? left;
    double? right;
    double? bottom;

    if (fitsOnTop) {
      top = widgetCenterY - calendarHeight - widgetHalfHeight - offset.dy;
    } else {
      top = widgetCenterY + widgetHalfHeight + offset.dy;
    }

    if (fitsHorizontally) {
      left = widgetCenterX - calendarHalfWidth;
    } else if (fitsOnLeft) {
      left = screenWidth - calendarWidth - horizontalSpacing;
    } else if (fitsOnRight) {
      left = horizontalSpacing;
    } else {
      left = 0;
      right = 0;
    }

    left += offset.dx;

    final double space = fitsOnLeft ? spaceOnLeft : spaceOnRight;
    double xAlignment = ((space / calendarWidth) - 0.5) * 2;

    if (fitsHorizontally) {
      xAlignment = 0.0;
    } else if (fitsOnLeft) {
      xAlignment = xAlignment > 1 ? 1.0 : xAlignment;
    } else if (fitsOnRight) {
      xAlignment = xAlignment > 1 ? -1.0 : -xAlignment;
    } else {
      xAlignment = 0.0;
    }

    final Alignment scaleAligment = Alignment(
      xAlignment,
      fitsOnTop ? 1.0 : -1.0,
    );
    final Alignment innerAlignment =
        fitsOnTop ? Alignment.topCenter : Alignment.bottomCenter;

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
              innerAlignment: innerAlignment,
              mainColor: widget.mainColor,
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
