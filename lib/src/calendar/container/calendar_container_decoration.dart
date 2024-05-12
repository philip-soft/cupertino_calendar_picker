import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

const List<BoxShadow> calendarBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.145),
    blurRadius: 85.0,
    spreadRadius: 9.0,
  ),
];
final BorderRadius calendarBorderRadius = BorderRadius.circular(13.0);
final CupertinoDynamicColor calendarBackgroundColor =
    CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.systemBackground,
  darkColor: CupertinoColors.tertiarySystemBackground.darkColor,
);
const CalendarBackgroundType calendarBackgroundType =
    CalendarBackgroundType.transparentAndBlured;

/// A decoration class for the calendar's background container.
class CalendarContainerDecoration {
  /// Creates a calendar's container decoration class with default values
  /// for non-provided parameters.
  factory CalendarContainerDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    CalendarBackgroundType backgroundType = calendarBackgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    Color color = backgroundColor ?? calendarBackgroundColor;

    if (backgroundType == CalendarBackgroundType.transparentAndBlured) {
      color = color.alpha > calendarBluredLightBackgroundColorAlpha
          ? color.withAlpha(calendarBluredLightBackgroundColorAlpha)
          : color;
    }

    return CalendarContainerDecoration._(
      borderRadius: borderRadius ?? calendarBorderRadius,
      backgroundColor: color,
      backgroundType: backgroundType,
      boxShadow: boxShadow ?? calendarBoxShadow,
    );
  }

  const CalendarContainerDecoration._({
    required this.borderRadius,
    required this.backgroundColor,
    required this.backgroundType,
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
    CalendarBackgroundType backgroundType = calendarBackgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    CupertinoDynamicColor color = backgroundColor ?? calendarBackgroundColor;

    if (backgroundType == CalendarBackgroundType.transparentAndBlured) {
      color = CupertinoDynamicColor.withBrightness(
        color: color.withAlpha(calendarBluredLightBackgroundColorAlpha),
        darkColor: color.darkColor.withAlpha(
          calendarBluredDarkBackgroundColorAlpha,
        ),
      );
    }

    return CalendarContainerDecoration(
      backgroundColor: CupertinoDynamicColor.resolve(color, context),
      backgroundType: backgroundType,
      boxShadow: boxShadow,
      borderRadius: borderRadius ?? calendarBorderRadius,
    );
  }

  /// The [borderRadius] of the calendar container.
  final BorderRadius borderRadius;

  /// The [backgroundColor] of the calendar container.
  final Color backgroundColor;

  /// The [CalendarBackgroundType] of the calendar container.
  final CalendarBackgroundType backgroundType;

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
