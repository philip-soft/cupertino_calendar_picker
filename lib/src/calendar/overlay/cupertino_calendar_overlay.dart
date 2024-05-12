import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarOverlay extends StatefulWidget {
  const CupertinoCalendarOverlay({
    required this.widgetRenderBox,
    required this.minimumDate,
    required this.maximumDate,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    this.onDateChanged,
    this.currentDate,
    this.initialDate,
    super.key,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
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
  final CalendarHeaderDecoration? headerDecoration;
  final Color mainColor;

  @override
  State<CupertinoCalendarOverlay> createState() =>
      _CupertinoCalendarOverlayState();
}

class _CupertinoCalendarOverlayState extends State<CupertinoCalendarOverlay> {
  AnimationController? _controller;
  Offset? _widgetPosition;

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
    final double verticalSpacing = widget.verticalSpacing;
    final Offset offset = widget.offset;

    final Size screenSize = MediaQuery.sizeOf(context);
    final EdgeInsets safeArea = MediaQuery.viewPaddingOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final bool isAttached = renderBox?.attached ?? false;
    if (isAttached) {
      _widgetPosition = renderBox?.localToGlobal(Offset.zero);
    }

    final Offset widgetPosition = _widgetPosition ?? Offset.zero;
    final Size widgetSize = renderBox?.size ?? Size.zero;
    final double widgetWidth = widgetSize.width;
    final double widgetHeight = widgetSize.height;
    final double widgetHalfWidth = widgetWidth / 2;
    final double widgetCenterX = widgetPosition.dx + widgetHalfWidth;
    final double widgetTopCenterY = widgetPosition.dy;
    final double widgetBottomCenterY = widgetPosition.dy + widgetHeight;

    final double spaceOnTop = widgetTopCenterY - offset.dy - verticalSpacing;
    final double spaceOnLeft =
        widgetCenterX - horizontalSpacing - safeArea.left;
    final double spaceOnRight =
        screenWidth - widgetCenterX - horizontalSpacing - safeArea.right;
    final double spaceOnBottom = screenHeight -
        widgetBottomCenterY +
        offset.dy -
        verticalSpacing -
        safeArea.bottom;

    const double calendarHalfWidth = calendarWidth / 2;
    final double neededSpaceOnRight = spaceOnLeft < calendarHalfWidth
        ? calendarWidth - spaceOnLeft
        : calendarHalfWidth;
    final double neededSpaceOnLeft = spaceOnRight < calendarHalfWidth
        ? calendarWidth - spaceOnRight
        : calendarHalfWidth;

    final bool fitsOnTop = spaceOnTop >= spaceOnBottom;
    final bool fitsOnLeft = spaceOnLeft >= neededSpaceOnLeft;
    final bool fitsOnRight = spaceOnRight >= neededSpaceOnRight;
    final bool fitsHorizontally = fitsOnLeft && fitsOnRight;

    double? top;
    double? left;
    double? right;
    double? bottom;

    if (fitsOnTop) {
      top = widgetTopCenterY - calendarHeight - offset.dy;
    } else {
      top = widgetBottomCenterY + offset.dy;
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

    final double verticalSpace = fitsOnTop ? spaceOnTop : spaceOnBottom;
    final double horizontalSpace = fitsOnLeft ? spaceOnLeft : spaceOnRight;

    /// [horizontalSpace / calendarWidth] is in range from [0] to [1]
    /// Decreased by [0.5] because we need a half of the value
    /// Multiplied by [2] because [Alignment] range is from [-1] to [1]
    double xAlignment = ((horizontalSpace / calendarWidth) - 0.5) * 2;

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

    double maxScale = 1.0;

    final double availableWidth =
        screenWidth - (horizontalSpacing * 2) - offset.dx;
    final double availableHeight = verticalSpace - verticalSpacing;
    if (availableHeight < calendarHeight) {
      maxScale = availableHeight / calendarHeight;
    }

    if (availableWidth < calendarWidth) {
      final double newMaxScale = availableWidth / calendarWidth;
      if (newMaxScale < maxScale) {
        maxScale = newMaxScale;
      }

      if (maxScale < 1.0) {
        if (left == right) {
          left = -calendarWidth * 2;
          right = -calendarWidth * 2;
        } else {
          left = 0;
          right = 0;
        }
      }
    }

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
              headerDecoration: widget.headerDecoration,
              minimumDate: widget.minimumDate,
              initialDate: widget.initialDate,
              currentDate: widget.currentDate,
              maximumDate: widget.maximumDate,
              onDateChanged: widget.onDateChanged,
              onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
              scaleAlignment: scaleAligment,
              maxScale: maxScale,
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
