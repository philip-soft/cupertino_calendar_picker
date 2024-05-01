import 'package:cupertino_calendar/src/src.dart';
import 'package:flutter/cupertino.dart';

class CalendarContainerDecoration {
  factory CalendarContainerDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration._(
      backgroundColor: backgroundColor ?? calendarBackgroundColor,
      boxShadow: boxShadow ?? calendarBoxShadow,
      borderRadius: borderRadius ?? calendarBorderRadius,
    );
  }

  const CalendarContainerDecoration._({
    required this.borderRadius,
    required this.backgroundColor,
    required this.boxShadow,
  });

  factory CalendarContainerDecoration.withDynamicColor(
    BuildContext context, {
    BorderRadius? borderRadius,
    CupertinoDynamicColor? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration(
      backgroundColor: (backgroundColor ?? calendarBackgroundDynamicColor)
          .resolveFrom(context),
      boxShadow: boxShadow ?? boxShadow,
      borderRadius: borderRadius ?? calendarBorderRadius,
    );
  }

  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;

  CalendarContainerDecoration copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration._(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}
