import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    required this.child,
    required this.decoration,
    required this.scaleAlignment,
    super.key,
  });

  final Widget child;
  final CalendarContainerDecoration decoration;
  final Alignment scaleAlignment;

  @override
  State<CalendarContainer> createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> scale;
  late Animation<double> height;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
      reverseDuration: const Duration(milliseconds: 280),
    );

    scale = CalendarAnimations.scaleAnimation.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    height = CalendarAnimations.heightAnimation.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isExpanded = false;

  void _toggleAnimation() {
    if (_isExpanded) {
      _controller.reverse(from: 0.75);
    } else {
      _controller.forward();
    }

    _isExpanded = !_isExpanded;
  }

  Offset get originFromScaleAlignment {
    return switch (widget.scaleAlignment) {
      Alignment.topCenter => const Offset(0, -calendarHeight),
      Alignment.topRight => const Offset(calendarWidth, -calendarHeight),
      Alignment.topLeft => const Offset(-calendarWidth, -calendarHeight),
      Alignment.bottomRight => const Offset(calendarWidth, 0),
      Alignment.bottomLeft => const Offset(-calendarWidth, 0),
      Alignment.bottomCenter => Offset.zero,
      Alignment.center => Offset.zero,
      _ => Offset.zero,
    };
  }

  Alignment get innerAlignment {
    return switch (widget.scaleAlignment) {
      Alignment.topCenter => Alignment.bottomCenter,
      Alignment.topRight => Alignment.bottomRight,
      Alignment.topLeft => Alignment.bottomLeft,
      Alignment.bottomRight => Alignment.topRight,
      Alignment.bottomLeft => Alignment.topLeft,
      Alignment.bottomCenter => Alignment.topCenter,
      Alignment.center => Alignment.center,
      _ => Alignment.topCenter,
    };
  }

  @override
  Widget build(BuildContext context) {
    final Offset origin = originFromScaleAlignment;

    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          child: SizedBox(
            width: calendarWidth,
            height: calendarHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.decoration.borderRadius,
                color: widget.decoration.backgroundColor,
                boxShadow: widget.decoration.boxShadow,
              ),
              clipBehavior: Clip.hardEdge,
              child: FittedBox(
                alignment: innerAlignment,
                fit: BoxFit.none,
                child: SizedBox(
                  width: calendarWidth,
                  height: calendarHeight,
                  child: widget.child,
                ),
              ),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: scale.value,
              alignment: Alignment.bottomCenter,
              origin: origin,
              child: Container(
                height: 319.0,
                alignment: widget.scaleAlignment,
                child: SizedBox(
                  height: height.value,
                  child: child,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
