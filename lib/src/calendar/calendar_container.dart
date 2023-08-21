import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';

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
  late AnimationController _mainController;

  late Animation<double> opacity;
  late Animation<double> scale;
  late Animation<double> height;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 410),
      reverseDuration: const Duration(milliseconds: 250),
    );

    opacity = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ),
        weight: 1.0,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.ease,
      ),
    );

    scale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.22,
          end: 0.39,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.29,
          end: 0.39,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.39,
          end: 0.5,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.5,
          end: 0.61,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.61,
          end: 0.7,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.7,
          end: 0.785,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.785,
          end: 0.85,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.85,
          end: 0.9,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.9,
          end: 0.94,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.94,
          end: 0.965,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.965,
          end: 0.985,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.985,
          end: 0.997,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.997,
          end: 1.005,
        ),
        weight: 0.03846,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 1.005,
          end: 1.01,
        ),
        weight: 0.25,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 1.01,
          end: 1.0,
        ),
        weight: 0.25,
      ),
    ]).animate(_mainController);

    height = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 70.0,
          end: 110.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 75.0,
          end: 110.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 110.0,
          end: 150.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 150.0,
          end: 185.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 185.0,
          end: 220.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 220.0,
          end: 245.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 245.0,
          end: 265.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 265.0,
          end: 283.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 283.0,
          end: 295.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 295.0,
          end: 305.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 305.0,
          end: 310.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 310.0,
          end: 315.0,
        ),
        weight: 0.04166,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 315.0,
          end: 319.0,
        ),
        weight: 0.25,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 319.0,
          end: calendarHeight,
        ),
        weight: 0.25,
      ),
    ]).animate(_mainController);
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  bool _isExpanded = false;

  void _toggleAnimation() {
    if (_isExpanded) {
      _mainController.reverse();
    } else {
      _mainController.forward();
    }

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: AnimatedBuilder(
        animation: _mainController,
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
    );
  }
}
