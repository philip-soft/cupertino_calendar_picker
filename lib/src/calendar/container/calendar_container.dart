import 'dart:ui';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({
    required this.child,
    required this.decoration,
    required this.scaleAlignment,
    required this.onInitialized,
    required this.maxScale,
    super.key,
  });

  final Widget child;
  final CalendarContainerDecoration decoration;
  final Alignment scaleAlignment;
  final double maxScale;
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

    scale = CalendarAnimations.scaleAnimation(
      maxScale: widget.maxScale,
    ).animate(_curvedAnimation);
    height = CalendarAnimations.heightAnimation(
      height: calendarHeight,
    ).animate(_curvedAnimation);

    widget.onInitialized(_controller);
  }

  CurvedAnimation get _curvedAnimation {
    return CurvedAnimation(
      parent: _controller,
      curve: calendarAnimationCurve,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.maxScale != oldWidget.maxScale) {
      scale = CalendarAnimations.scaleAnimation(
        maxScale: widget.maxScale,
      ).animate(_curvedAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CalendarContainerDecoration decoration = widget.decoration;

    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          child: SizedBox(
            width: calendarWidth,
            height: calendarHeight,
            child: Builder(
              builder: (BuildContext context) {
                final FittedBox child = FittedBox(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.none,
                  child: SizedBox(
                    width: calendarWidth,
                    height: calendarHeight,
                    child: widget.child,
                  ),
                );

                return switch (decoration.backgroundType) {
                  CalendarBackgroundType.transparentAndBlured => DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: decoration.boxShadow,
                        borderRadius: decoration.borderRadius,
                      ),
                      child: ClipRRect(
                        borderRadius: decoration.borderRadius,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: calendarBlurAmount,
                            sigmaY: calendarBlurAmount,
                          ),
                          child: ColoredBox(
                            color: decoration.backgroundColor,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  CalendarBackgroundType.plainColor => Container(
                      decoration: BoxDecoration(
                        borderRadius: decoration.borderRadius,
                        color: decoration.backgroundColor,
                        boxShadow: decoration.boxShadow,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: child,
                    ),
                };
              },
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: scale.value,
              alignment: widget.scaleAlignment,
              child: Container(
                height: calendarHeight *
                    (CalendarAnimations.maxHeightPercentage / 100),
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
