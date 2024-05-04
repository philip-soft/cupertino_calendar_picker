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

/// A decoration class for the calendar's background container.
class CalendarContainerDecoration {
  /// Creates a calendar's container decoration class with default values
  /// for non-provided parameters.
  factory CalendarContainerDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration._(
      borderRadius: borderRadius ?? calendarBorderRadius,
      backgroundColor: backgroundColor ?? calendarBackgroundColor,
      boxShadow: boxShadow ?? calendarBoxShadow,
    );
  }

  const CalendarContainerDecoration._({
    required this.borderRadius,
    required this.backgroundColor,
    required this.boxShadow,
  });

  /// Creates a calendar's container decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory CalendarContainerDecoration.withDynamicColor(
    BuildContext context, {
    BorderRadius? borderRadius,
    CupertinoDynamicColor? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration(
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ?? calendarBackgroundColor,
        context,
      ),
      boxShadow: boxShadow ?? boxShadow,
      borderRadius: borderRadius ?? calendarBorderRadius,
    );
  }

  /// The [borderRadius] of the calendar container.
  final BorderRadius borderRadius;

  /// The [backgroundColor] of the calendar container.
  final Color backgroundColor;

  /// The [boxShadow] of the calendar container.
  final List<BoxShadow> boxShadow;

  /// Creates a copy of the class with the provided parameters.
  CalendarContainerDecoration copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return CalendarContainerDecoration(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}
