// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CupertinoPickerOverlay extends StatefulWidget {
  const CupertinoPickerOverlay({
    required this.widgetRenderBox,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.outsideTapDismissable,
    required this.height,
    required this.width,
    required this.containerDecoration,
    required this.onInitialized,
    required this.child,
    super.key,
  });

  final double height;
  final double width;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final bool outsideTapDismissable;
  final PickerContainerDecoration? containerDecoration;
  final void Function(AnimationController controller) onInitialized;
  final Widget child;

  @override
  State<CupertinoPickerOverlay> createState() => _CupertinoPickerOverlayState();
}

class _CupertinoPickerOverlayState extends State<CupertinoPickerOverlay> {
  AnimationController? _controller;
  Offset? _widgetPosition;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    widget.onInitialized.call(animationController);
  }

  void _onOutsideTap() {
    _closeOverlay();
  }

  void _closeOverlay() {
    if (_controller != null) {
      final bool isReverseInProgress =
          _controller!.status == AnimationStatus.reverse;
      if (!isReverseInProgress) {
        _controller?.reverse(from: 0.75);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final double height = widget.height;

    final RenderBox? renderBox = widget.widgetRenderBox;
    final double horizontalSpacing = widget.horizontalSpacing;
    final double verticalSpacing = widget.verticalSpacing;
    final Offset offset = widget.offset;

    final Size screenSize = MediaQuery.sizeOf(context);
    final EdgeInsets safeArea = MediaQuery.viewPaddingOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final bool isAttached = renderBox?.attached ?? false;
    if (isAttached) {
      _widgetPosition = renderBox?.localToGlobal(Offset.zero);
    }

    final Offset widgetPosition = _widgetPosition ?? Offset.zero;
    final Size widgetSize = renderBox?.size ?? Size.zero;
    final double widgetWidth = widgetSize.width;
    final double widgetHeight = widgetSize.height;
    final double widgetHalfWidth = widgetWidth / 2;
    final double widgetCenterX = widgetPosition.dx + widgetHalfWidth;
    final double widgetTopCenterY = widgetPosition.dy;
    final double widgetBottomCenterY = widgetPosition.dy + widgetHeight;

    final double spaceOnTop =
        widgetTopCenterY - offset.dy - verticalSpacing - safeArea.top;
    final double spaceOnLeft =
        widgetCenterX - horizontalSpacing - safeArea.left;
    final double spaceOnRight =
        screenWidth - widgetCenterX - horizontalSpacing - safeArea.right;
    final double spaceOnBottom = screenHeight -
        widgetBottomCenterY -
        offset.dy -
        verticalSpacing -
        safeArea.bottom;

    final double halfWidth = width / 2;
    final double neededSpaceOnRight =
        spaceOnLeft < halfWidth ? width - spaceOnLeft : halfWidth;
    final double neededSpaceOnLeft =
        spaceOnRight < halfWidth ? width - spaceOnRight : halfWidth;

    final bool fitsOnTop = spaceOnTop >= spaceOnBottom;
    final bool fitsOnLeft = spaceOnLeft >= neededSpaceOnLeft;
    final bool fitsOnRight = spaceOnRight >= neededSpaceOnRight;
    final bool fitsHorizontally = fitsOnLeft && fitsOnRight;

    double? top;
    double? left;
    double? right;
    double? bottom;

    if (fitsOnTop) {
      top = widgetTopCenterY - height - offset.dy;
    } else {
      top = widgetBottomCenterY + offset.dy;
    }

    if (fitsHorizontally) {
      left = widgetCenterX - halfWidth;
    } else if (fitsOnLeft) {
      left = screenWidth - width - horizontalSpacing;
    } else if (fitsOnRight) {
      left = horizontalSpacing;
    } else {
      left = 0;
      right = 0;
    }

    left += offset.dx;

    final double verticalSpace = fitsOnTop ? spaceOnTop : spaceOnBottom;

    double xAlignment;

    if (!fitsOnRight) {
      final double offsetOnRight = neededSpaceOnRight - spaceOnRight;
      xAlignment = offsetOnRight / halfWidth;
    } else if (!fitsOnLeft) {
      final double offsetOnLeft = neededSpaceOnLeft - spaceOnLeft;
      xAlignment = -offsetOnLeft / halfWidth;
    } else {
      xAlignment = 0.0;
    }

    final Alignment scaleAligment = Alignment(
      xAlignment,
      fitsOnTop ? 1.0 : -1.0,
    );

    double maxScale = 1.0;

    final double availableWidth =
        screenWidth - (horizontalSpacing * 2) - offset.dx;
    final double availableHeight = verticalSpace;
    if (availableHeight < height) {
      maxScale = availableHeight / height;
    }

    if (availableWidth < width) {
      final double newMaxScale = availableWidth / width;
      if (newMaxScale < maxScale) {
        maxScale = newMaxScale;
      }

      if (maxScale < 1.0) {
        if (left == right) {
          left = -width * 2;
          right = -width * 2;
        } else {
          left = 0;
          right = 0;
        }
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _closeOverlay(),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.outsideTapDismissable ? _onOutsideTap : null,
              behavior: HitTestBehavior.translucent,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: top,
            left: left,
            right: right,
            bottom: bottom,
            child: Material(
              color: Colors.transparent,
              child: CupertinoPickerContainer(
                height: height,
                width: width,
                onInitialized: _onInitialized,
                decoration: widget.containerDecoration ??
                    PickerContainerDecoration.withDynamicColor(context),
                maxScale: maxScale,
                scaleAlignment: scaleAligment,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
