import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    required this.child,
    required this.decoration,
    required this.scaleAlignment,
    required this.onInitialized,
    super.key,
  });

  final Widget child;
  final CalendarContainerDecoration decoration;
  final Alignment scaleAlignment;
  final void Function(AnimationController controller) onInitialized;

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
      duration: calendarAnimationDuration,
      reverseDuration: calendarAnimationReverseDuration,
    );

    scale = scaleAnimation.animate(_curvedAnimation);
    height = heightAnimation.animate(_curvedAnimation);

    widget.onInitialized(_controller);
  }

  CurvedAnimation get _curvedAnimation {
    return CurvedAnimation(
      parent: _controller,
      curve: calendarAnimationCurve,
    );
  }

  Alignment get innerAlignment {
    return switch (widget.scaleAlignment) {
      Alignment.bottomRight => Alignment.topRight,
      Alignment.bottomLeft => Alignment.topLeft,
      Alignment.bottomCenter => Alignment.topCenter,
      _ => widget.scaleAlignment,
    };
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
              alignment: widget.scaleAlignment,
              child: Container(
                height: calendarMaxHeight,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
