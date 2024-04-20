import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/material.dart';

const String _barrierLabel = 'CupertinoCalendarPickerBarrier';

Future<void> showCupertinoCalendarPicker(
  BuildContext context, {
  required Alignment scaleAligment,
  double? top,
  double? left,
  double? right,
  double? bottom,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: _barrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return child;
    },
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return CupertinoCalendarOverlay(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        scaleAligment: scaleAligment,
      );
    },
  );
}
