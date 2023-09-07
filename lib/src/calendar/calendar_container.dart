import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    required this.child,
    required this.decoration,
    super.key,
  });

  final Widget child;
  final CalendarContainerDecoration decoration;

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

  @override
  Widget build(BuildContext context) {
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
                alignment: Alignment.topCenter,
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
              alignment: const Alignment(0.6, 1.0),
              child: SizedBox(
                height: height.value,
                child: child,
              ),
            );
          },
        ),
        const SizedBox(height: 50.0),
        FloatingActionButton(onPressed: _toggleAnimation)
      ],
    );
  }
}
