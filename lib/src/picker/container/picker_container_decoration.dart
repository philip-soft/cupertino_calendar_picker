// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

const List<BoxShadow> pickerBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.145),
    blurRadius: 85.0,
    spreadRadius: 9.0,
  ),
];
final BorderRadius pickerBorderRadius = BorderRadius.circular(13.0);
final CupertinoDynamicColor pickerBackgroundColor =
    CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.systemBackground,
  darkColor: CupertinoColors.tertiarySystemBackground.darkColor,
);
const PickerBackgroundType pickerBackgroundType =
    PickerBackgroundType.transparentAndBlured;

/// A decoration class for the picker's background container.
class PickerContainerDecoration {
  /// Creates a picker's container decoration class with default values
  /// for non-provided parameters.
  factory PickerContainerDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    PickerBackgroundType backgroundType = pickerBackgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    Color color = backgroundColor ?? pickerBackgroundColor;

    if (backgroundType == PickerBackgroundType.transparentAndBlured) {
      color = color.a > calendarBluredLightBackgroundColorAlpha
          ? color.withAlpha(calendarBluredLightBackgroundColorAlpha)
          : color;
    }

    return PickerContainerDecoration._(
      borderRadius: borderRadius ?? pickerBorderRadius,
      backgroundColor: color,
      backgroundType: backgroundType,
      boxShadow: boxShadow ?? pickerBoxShadow,
    );
  }

  const PickerContainerDecoration._({
    required this.borderRadius,
    required this.backgroundColor,
    required this.backgroundType,
    required this.boxShadow,
  });

  /// Creates a picker's container decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory PickerContainerDecoration.withDynamicColor(
    BuildContext context, {
    BorderRadius? borderRadius,
    CupertinoDynamicColor? backgroundColor,
    PickerBackgroundType backgroundType = pickerBackgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    CupertinoDynamicColor color = backgroundColor ?? pickerBackgroundColor;

    if (backgroundType == PickerBackgroundType.transparentAndBlured) {
      color = CupertinoDynamicColor.withBrightness(
        color: color.withAlpha(calendarBluredLightBackgroundColorAlpha),
        darkColor: color.darkColor.withAlpha(
          calendarBluredDarkBackgroundColorAlpha,
        ),
      );
    }

    return PickerContainerDecoration(
      backgroundColor: CupertinoDynamicColor.resolve(color, context),
      backgroundType: backgroundType,
      boxShadow: boxShadow,
      borderRadius: borderRadius ?? pickerBorderRadius,
    );
  }

  /// The [borderRadius] of the calendar container.
  final BorderRadius borderRadius;

  /// The [backgroundColor] of the calendar container.
  final Color backgroundColor;

  /// The [PickerBackgroundType] of the calendar container.
  final PickerBackgroundType backgroundType;

  /// The [boxShadow] of the calendar container.
  final List<BoxShadow> boxShadow;

  /// Creates a copy of the class with the provided parameters.
  PickerContainerDecoration copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
  }) {
    return PickerContainerDecoration(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}
