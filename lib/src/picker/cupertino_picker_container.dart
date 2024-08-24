// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPickerContainer extends StatefulWidget {
  const CupertinoPickerContainer({
    required this.child,
    required this.decoration,
    required this.scaleAlignment,
    required this.onInitialized,
    required this.maxScale,
    required this.height,
    required this.width,
    super.key,
  });

  final Widget child;
  final PickerContainerDecoration decoration;
  final Alignment scaleAlignment;
  final double maxScale;
  final void Function(AnimationController controller) onInitialized;
  final double height;
  final double width;

  @override
  State<CupertinoPickerContainer> createState() =>
      _CupertinoPickerContainerState();
}

class _CupertinoPickerContainerState extends State<CupertinoPickerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _height;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: calendarAnimationDuration,
      reverseDuration: calendarAnimationReverseDuration,
    );

    _scale = CalendarAnimations.scaleAnimation(
      maxScale: widget.maxScale,
    ).animate(_curvedAnimation);
    _height = CalendarAnimations.heightAnimation(
      height: widget.height,
    ).animate(_curvedAnimation);

    widget.onInitialized(_controller);
  }

  CurvedAnimation get _curvedAnimation {
    return CurvedAnimation(
      parent: _controller,
      curve: calendarAnimationCurve,
    );
  }

  @override
  void didUpdateWidget(covariant CupertinoPickerContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.maxScale != oldWidget.maxScale) {
      _scale = CalendarAnimations.scaleAnimation(
        maxScale: widget.maxScale,
      ).animate(_curvedAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PickerContainerDecoration decoration = widget.decoration;

    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Builder(
              builder: (BuildContext context) {
                final FittedBox child = FittedBox(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.none,
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: widget.child,
                  ),
                );

                return switch (decoration.backgroundType) {
                  PickerBackgroundType.transparentAndBlured => DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: decoration.boxShadow,
                        borderRadius: decoration.borderRadius,
                      ),
                      child: ClipRRect(
                        borderRadius: decoration.borderRadius,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: calendarBlurAmount,
                            sigmaY: calendarBlurAmount,
                          ),
                          child: ColoredBox(
                            color: decoration.backgroundColor,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  PickerBackgroundType.plainColor => Container(
                      decoration: BoxDecoration(
                        borderRadius: decoration.borderRadius,
                        color: decoration.backgroundColor,
                        boxShadow: decoration.boxShadow,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: child,
                    ),
                };
              },
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _scale.value,
              alignment: widget.scaleAlignment,
              child: Container(
                height: widget.height *
                    (CalendarAnimations.maxHeightPercentage / 100),
                alignment: widget.scaleAlignment,
                child: SizedBox(
                  height: _height.value,
                  child: child,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
