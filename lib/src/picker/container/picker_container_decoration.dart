// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';

const List<BoxShadow> pickerBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.145),
    blurRadius: 85.0,
    spreadRadius: 9.0,
  ),
];
const BorderRadius pickerBorderRadius = BorderRadius.all(Radius.circular(13.0));
final CupertinoDynamicColor pickerBackgroundColor =
    CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemBackground,
      darkColor: CupertinoColors.tertiarySystemBackground.darkColor,
    );
const PickerBackgroundType pickerBackgroundType =
    PickerBackgroundType.transparentAndBlurred;

/// A decoration class for the picker's background container.
@immutable
class PickerContainerDecoration {
  /// Creates a picker's container decoration class with default values
  /// for non-provided parameters.
  ///
  /// With [PickerBackgroundType.transparentAndBlurred], the alpha of
  /// [backgroundColor] is capped so that the blur stays visible.
  ///
  /// [CupertinoDynamicColor]s are resolved against the ambient brightness
  /// when the container is built.
  factory PickerContainerDecoration({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    PickerBackgroundType backgroundType = pickerBackgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    final Color color = backgroundColor ?? pickerBackgroundColor;

    return PickerContainerDecoration._(
      borderRadius: borderRadius ?? pickerBorderRadius,
      backgroundColor: switch (backgroundType) {
        PickerBackgroundType.plainColor => color,
        PickerBackgroundType.transparentAndBlurred => _capAlpha(color),
      },
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
    final PickerContainerDecoration decoration = PickerContainerDecoration(
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      backgroundType: backgroundType,
      boxShadow: boxShadow,
    );
    return PickerContainerDecoration._(
      borderRadius: decoration.borderRadius,
      backgroundColor: CupertinoDynamicColor.resolve(
        decoration.backgroundColor,
        context,
      ),
      backgroundType: decoration.backgroundType,
      boxShadow: decoration.boxShadow,
    );
  }

  /// Caps the alpha of [color] so that the blur stays visible, keeping
  /// a [CupertinoDynamicColor] dynamic.
  static Color _capAlpha(Color color) {
    if (color is! CupertinoDynamicColor) {
      return _capLightAlpha(color);
    }
    return CupertinoDynamicColor(
      color: _capLightAlpha(color.color),
      darkColor: _capDarkAlpha(color.darkColor),
      highContrastColor: _capLightAlpha(color.highContrastColor),
      darkHighContrastColor: _capDarkAlpha(color.darkHighContrastColor),
      elevatedColor: _capLightAlpha(color.elevatedColor),
      darkElevatedColor: _capDarkAlpha(color.darkElevatedColor),
      highContrastElevatedColor: _capLightAlpha(
        color.highContrastElevatedColor,
      ),
      darkHighContrastElevatedColor: _capDarkAlpha(
        color.darkHighContrastElevatedColor,
      ),
    );
  }

  static Color _capLightAlpha(Color color) {
    return _capAlphaTo(color, calendarBlurredLightBackgroundColorAlpha);
  }

  static Color _capDarkAlpha(Color color) {
    return _capAlphaTo(color, calendarBlurredDarkBackgroundColorAlpha);
  }

  static Color _capAlphaTo(Color color, int maxAlpha) {
    final int alpha = (color.a * 255.0).round().clamp(0, 255);
    if (alpha <= maxAlpha) return color;
    return color.withAlpha(maxAlpha);
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
    PickerBackgroundType? backgroundType,
    List<BoxShadow>? boxShadow,
  }) {
    return PickerContainerDecoration(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundType: backgroundType ?? this.backgroundType,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickerContainerDecoration &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.backgroundType == backgroundType &&
        listEquals(other.boxShadow, boxShadow);
  }

  @override
  int get hashCode {
    return Object.hash(
      borderRadius,
      backgroundColor,
      backgroundType,
      Object.hashAll(boxShadow),
    );
  }
}
