// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

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
  /// centered and scaled down.
  ///
  /// When [anchor] is `null`, the picker is centered within the [bounds].
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
      final double scale = _fitScale(size, availableArea.size);
      return PickerOverlayLayout(
        left: availableArea.center.dx - size.width / 2,
        top: availableArea.center.dy - size.height / 2,
        scale: scale,
        scaleAlignment: Alignment.center,
      );
    }

    final double spaceAbove = anchor.top - offset.dy - availableArea.top;
    final double spaceBelow = availableArea.bottom - anchor.bottom - offset.dy;
    final bool opensAbove = spaceAbove >= spaceBelow;
    final double top = opensAbove
        ? anchor.top - size.height - offset.dy
        : anchor.bottom + offset.dy;

    final double availableWidth = availableArea.width - offset.dx.abs();
    final double halfWidth = size.width / 2;
    final double left;
    if (availableWidth < size.width) {
      left = availableArea.center.dx - halfWidth;
    } else {
      left = (anchor.center.dx - halfWidth).clamp(
        availableArea.left,
        availableArea.right - size.width,
      );
    }

    final double xAlignment =
        ((anchor.center.dx - (left + halfWidth)) / halfWidth).clamp(-1.0, 1.0);

    return PickerOverlayLayout(
      left: left + offset.dx,
      top: top,
      scale: _fitScale(
        size,
        Size(availableWidth, opensAbove ? spaceAbove : spaceBelow),
      ),
      scaleAlignment: Alignment(xAlignment, opensAbove ? 1.0 : -1.0),
    );
  }

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
