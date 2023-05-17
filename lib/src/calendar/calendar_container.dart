import 'package:flutter/cupertino.dart';

import '../decoration/decoration.dart';

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
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: decoration.borderRadius,
        color: decoration.backgroundColor,
        boxShadow: decoration.boxShadow,
      ),
      child: child,
    );
  }
}
