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
      child: AspectRatio(
        aspectRatio: calendarAspectRatio,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: decoration.borderRadius,
            color: decoration.backgroundColor,
            boxShadow: decoration.boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
