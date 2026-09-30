// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

PickerOverlayLayout _compute({
  required Rect? anchor,
  Size bounds = const Size(400.0, 800.0),
  EdgeInsets padding = EdgeInsets.zero,
  Size size = const Size(320.0, 332.0),
  Offset offset = const Offset(0.0, 10.0),
}) {
  return PickerOverlayLayout.compute(
    anchor: anchor,
    bounds: bounds,
    padding: padding,
    size: size,
    horizontalSpacing: 15.0,
    verticalSpacing: 15.0,
    offset: offset,
  );
}

void main() {
  group('PickerOverlayLayout.compute', () {
    test('centers on the anchor when there is room on both sides', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(160.0, 100.0, 80.0, 40.0),
      );

      expect(layout.left, 40.0);
      expect(layout.top, 150.0);
      expect(layout.scale, 1.0);
      expect(layout.scaleAlignment, Alignment.topCenter);
    });

    test('opens above when there is more space above', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(160.0, 700.0, 80.0, 40.0),
      );

      expect(layout.top, 700.0 - 332.0 - 10.0);
      expect(layout.scaleAlignment.y, 1.0);
    });

    test('respects the right safe area when pinned to the right edge', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(300.0, 100.0, 80.0, 40.0),
        padding: const EdgeInsets.only(right: 20.0),
      );

      expect(layout.left, 400.0 - 20.0 - 15.0 - 320.0);
    });

    test('respects the left safe area when pinned to the left edge', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(0.0, 100.0, 40.0, 40.0),
        padding: const EdgeInsets.only(left: 20.0),
      );

      expect(layout.left, 35.0);
    });

    test(
      'scales down and grows from the anchor when narrower than the picker',
      () {
        final PickerOverlayLayout layout = _compute(
          anchor: const Rect.fromLTWH(10.0, 100.0, 40.0, 40.0),
          bounds: const Size(230.0, 800.0),
        );

        expect(layout.scale, closeTo(200.0 / 320.0, 0.0001));
        // Grows from the anchor's center.
        final Rect box =
            Offset(layout.left, layout.top) & const Size(320.0, 332.0);
        expect(layout.scaleAlignment.withinRect(box).dx, closeTo(30.0, 0.0001));
      },
    );

    test('applies the horizontal offset', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(160.0, 100.0, 80.0, 40.0),
        offset: const Offset(5.0, 10.0),
      );

      expect(layout.left, 45.0);
    });

    test('keeps the horizontal spacing when the offset pushes past it', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(300.0, 100.0, 80.0, 40.0),
        offset: const Offset(10.0, 10.0),
      );

      expect(layout.left, 400.0 - 15.0 - 320.0);
    });

    test('scales down when the vertical space is not enough', () {
      final PickerOverlayLayout layout = _compute(
        anchor: const Rect.fromLTWH(160.0, 300.0, 80.0, 40.0),
        bounds: const Size(400.0, 600.0),
      );

      // Above: 300 - 10 - 15 = 275 is more than below: 585 - 340 - 10 = 235.
      expect(layout.scale, closeTo(275.0 / 332.0, 0.0001));
    });

    test('stays finite when the spacing leaves no width', () {
      final PickerOverlayLayout layout = PickerOverlayLayout.compute(
        anchor: const Rect.fromLTWH(160.0, 100.0, 80.0, 40.0),
        bounds: const Size(400.0, 800.0),
        padding: EdgeInsets.zero,
        size: const Size(320.0, 332.0),
        horizontalSpacing: 200.0,
        verticalSpacing: 15.0,
        offset: const Offset(0.0, 10.0),
      );

      expect(layout.scale, 0.0);
      expect(layout.left.isFinite, isTrue);
      expect(layout.scaleAlignment.x.isFinite, isTrue);
    });

    test('centers within the bounds without an anchor', () {
      final PickerOverlayLayout layout = _compute(anchor: null);

      expect(layout.left, 40.0);
      expect(layout.top, 234.0);
      expect(layout.scaleAlignment, Alignment.center);
    });
  });
}
