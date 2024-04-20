import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoCalendarButton extends StatefulWidget {
  const CupertinoCalendarButton({
    required this.child,
    required this.onPressed,
    required this.calendarOffset,
    required this.calendarHorizontalSpacing,
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

  void _onTap() {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final double horizontalSpacing = widget.calendarHorizontalSpacing;
    final Offset offset = widget.calendarOffset;

    final RenderBox? box =
        _key.currentContext?.findRenderObject() as RenderBox?;
    final Offset position = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Size widgetSize = box?.size ?? Size.zero;
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

    late Alignment scaleAligment;

    final double widgetPercentageX = widgetCenterX / screenWidth;
    final bool isInCenter =
        widgetPercentageX >= 0.4 && widgetPercentageX <= 0.6;

    if (moreSpaceOnTop) {
      if (isInCenter) {
        scaleAligment = Alignment.bottomCenter;
      } else {
        scaleAligment =
            moreSpaceOnLeft ? Alignment.bottomRight : Alignment.bottomLeft;
      }
    } else {
      if (isInCenter) {
        scaleAligment = Alignment.topCenter;
      } else {
        scaleAligment =
            moreSpaceOnLeft ? Alignment.topRight : Alignment.topLeft;
      }
    }

    showCupertinoCalendarPicker(
      context,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scaleAligment: scaleAligment,
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
