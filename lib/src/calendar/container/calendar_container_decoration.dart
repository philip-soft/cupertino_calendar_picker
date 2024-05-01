import 'package:flutter/cupertino.dart';

const List<BoxShadow> calendarBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    offset: Offset(0.0, 10.0),
    blurRadius: 60.0,
  ),
];
final BorderRadius calendarBorderRadius = BorderRadius.circular(13.0);
final CupertinoDynamicColor calendarBackgroundColor =
    CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.systemBackground,
  darkColor: CupertinoColors.systemBackground.darkElevatedColor,
);

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
      backgroundColor:
          (backgroundColor ?? calendarBackgroundColor).resolveFrom(context),
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
