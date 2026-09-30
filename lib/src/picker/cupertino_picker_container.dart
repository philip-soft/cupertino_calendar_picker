// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

/// The decorated container of a picker overlay that scales and expands
/// along with [animation].
class CupertinoPickerContainer extends StatelessWidget {
  const CupertinoPickerContainer({
    required this.animation,
    required this.child,
    required this.decoration,
    required this.scaleAlignment,
    required this.maxScale,
    required this.height,
    required this.width,
    super.key,
  });

  final Animation<double> animation;
  final Widget child;
  final PickerContainerDecoration decoration;
  final Alignment scaleAlignment;
  final double maxScale;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final Animatable<double> scale = CalendarAnimations.scaleAnimation(
      maxScale: maxScale,
    );
    final Animatable<double> expandedHeight =
        CalendarAnimations.heightAnimation(height: height);

    return AnimatedBuilder(
      animation: animation,
      child: SizedBox(
        width: width,
        height: height,
        child: _DecoratedBackground(
          decoration: decoration,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.none,
            child: SizedBox(width: width, height: height, child: child),
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: scale.evaluate(animation),
          alignment: scaleAlignment,
          child: Container(
            height: height * (CalendarAnimations.maxHeightPercentage / 100),
            alignment: scaleAlignment,
            child: SizedBox(
              height: expandedHeight.evaluate(animation),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _DecoratedBackground extends StatelessWidget {
  const _DecoratedBackground({required this.decoration, required this.child});

  final PickerContainerDecoration decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = decoration.backgroundColor.resolveDynamic(
      context,
    );

    return switch (decoration.backgroundType) {
      PickerBackgroundType.transparentAndBlurred => DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: decoration.boxShadow,
          borderRadius: decoration.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: decoration.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: pickerContainerBlur,
              sigmaY: pickerContainerBlur,
            ),
            child: ColoredBox(color: backgroundColor, child: child),
          ),
        ),
      ),
      PickerBackgroundType.plainColor => Container(
        decoration: BoxDecoration(
          borderRadius: decoration.borderRadius,
          color: backgroundColor,
          boxShadow: decoration.boxShadow,
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    };
  }
}
