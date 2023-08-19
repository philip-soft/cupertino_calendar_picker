import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';

class CalendarContainer extends StatelessWidget {
  const CalendarContainer({
    required this.child,
    required this.decoration,
    super.key,
  });

  final Widget child;
  final CalendarContainerDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: calendarWidth,
      height: calendarHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: decoration.borderRadius,
          color: decoration.backgroundColor,
          boxShadow: decoration.boxShadow,
        ),
        clipBehavior: Clip.hardEdge,
        child: FittedBox(
          alignment: Alignment.topCenter,
          fit: BoxFit.none,
          child: SizedBox(
            width: calendarWidth,
            height: calendarHeight,
            child: child,
          ),
        ),
      ),
    );
  }
}
