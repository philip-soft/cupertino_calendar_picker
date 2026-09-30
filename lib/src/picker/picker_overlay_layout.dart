// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

/// The placement of a picker overlay relative to its anchor widget.
///
/// All coordinates are in the coordinate space of the overlay's bounds.
@immutable
class PickerOverlayLayout {
  const PickerOverlayLayout({
    required this.left,
    required this.top,
    required this.scale,
    required this.scaleAlignment,
  });

  /// Computes where a picker of [size] is displayed next to [anchor].
  ///
  /// The picker opens on the side of the anchor with more vertical space and
  /// is horizontally centered on the anchor unless it would cross the
  /// [horizontalSpacing] from the [bounds] edges, in which case it is pinned
  /// to that edge. When the available space is smaller than the picker, it is
  /// scaled down. An anchor partially or fully outside of the available area
  /// is treated as if it was at its edge.
  ///
  /// When [anchor] is `null`, or the space next to it only fits the picker
  /// scaled below [pickerMinimumAnchoredScale], the picker is centered within
  /// the [bounds].
  factory PickerOverlayLayout.compute({
    required Rect? anchor,
    required Size bounds,
    required EdgeInsets padding,
    required Size size,
    required double horizontalSpacing,
    required double verticalSpacing,
    required Offset offset,
  }) {
    final Rect availableArea = padding
        .deflateRect(Offset.zero & bounds)
        .deflateHorizontally(horizontalSpacing)
        .deflateVertically(verticalSpacing);

    if (anchor == null) {
      return PickerOverlayLayout._centered(size, availableArea);
    }

    final double aboveBottom = math.min(
      anchor.top - offset.dy,
      availableArea.bottom,
    );
    final double belowTop = math.max(
      anchor.bottom + offset.dy,
      availableArea.top,
    );
    final double spaceAbove = aboveBottom - availableArea.top;
    final double spaceBelow = availableArea.bottom - belowTop;
    final bool opensAbove = spaceAbove >= spaceBelow;
    final double verticalSpace = opensAbove ? spaceAbove : spaceBelow;

    if (verticalSpace < size.height * pickerMinimumAnchoredScale) {
      return PickerOverlayLayout._centered(size, availableArea);
    }

    final double halfWidth = size.width / 2;
    final bool fitsHorizontally = availableArea.width >= size.width;
    // A picker wider than the area is scaled around its center to fit it.
    final double left = fitsHorizontally
        ? (anchor.center.dx - halfWidth + offset.dx).clamp(
            availableArea.left,
            availableArea.right - size.width,
          )
        : availableArea.center.dx - halfWidth;
    final double xAlignment = fitsHorizontally
        ? ((anchor.center.dx - (left + halfWidth)) / halfWidth).clamp(-1.0, 1.0)
        : 0.0;

    return PickerOverlayLayout(
      left: left,
      top: opensAbove ? aboveBottom - size.height : belowTop,
      scale: _fitScale(size, Size(availableArea.width, verticalSpace)),
      scaleAlignment: Alignment(xAlignment, opensAbove ? 1.0 : -1.0),
    );
  }

  PickerOverlayLayout._centered(Size size, Rect availableArea)
    : this(
        left: availableArea.center.dx - size.width / 2,
        top: availableArea.center.dy - size.height / 2,
        scale: _fitScale(size, availableArea.size),
        scaleAlignment: Alignment.center,
      );

  static double _fitScale(Size size, Size available) {
    final double widthScale = available.width / size.width;
    final double heightScale = available.height / size.height;
    return math.max(0.0, math.min(1.0, math.min(widthScale, heightScale)));
  }

  /// The distance of the picker's left edge from the left of the bounds.
  final double left;

  /// The distance of the picker's top edge from the top of the bounds.
  final double top;

  /// The scale the picker is displayed with, at most `1.0`.
  final double scale;

  /// The origin of the picker's scale animation.
  final Alignment scaleAlignment;
}

extension on Rect {
  Rect deflateHorizontally(double delta) {
    return Rect.fromLTRB(left + delta, top, right - delta, bottom);
  }

  Rect deflateVertically(double delta) {
    return Rect.fromLTRB(left, top + delta, right, bottom - delta);
  }
}
