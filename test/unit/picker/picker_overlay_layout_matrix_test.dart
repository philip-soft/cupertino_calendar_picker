// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/picker_screens.dart';

const double _epsilon = 0.01;
const Size _anchorSize = Size(120.0, 34.0);

const Map<String, Size> _pickers = <String, Size>{
  'date calendar': Size(calendarWidth, calendarDatePickerHeight),
  'dateTime calendar with actions': Size(
    calendarWidth,
    calendarDateTimePickerHeight + calendarActionsHeight,
  ),
  'time picker': Size(timePickerWidth, timePickerHeight),
};

PickerOverlayLayout _compute(TestScreen screen, Rect? anchor, Size size) {
  return PickerOverlayLayout.compute(
    anchor: anchor,
    bounds: screen.size,
    padding: screen.padding,
    size: size,
    horizontalSpacing: pickerDefaultHorizontalSpacing,
    verticalSpacing: pickerDefaultVerticalSpacing,
    offset: pickerDefaultOffset,
  );
}

void _expectWithin(Rect inner, Rect outer) {
  expect(inner.left, greaterThanOrEqualTo(outer.left - _epsilon));
  expect(inner.top, greaterThanOrEqualTo(outer.top - _epsilon));
  expect(inner.right, lessThanOrEqualTo(outer.right + _epsilon));
  expect(inner.bottom, lessThanOrEqualTo(outer.bottom + _epsilon));
}

void _expectInvariants(TestScreen screen, Rect anchor, Size size) {
  final PickerOverlayLayout layout = _compute(screen, anchor, size);
  final Rect area = screen.pickerArea;
  final Rect visual = pickerVisualRect(layout, size);
  final double dy = pickerDefaultOffset.dy;
  final double spaceAbove = anchor.top - dy - area.top;
  final double spaceBelow = area.bottom - anchor.bottom - dy;
  final double bestSpace = spaceAbove > spaceBelow ? spaceAbove : spaceBelow;

  // Visible and never larger than designed.
  expect(layout.scale, greaterThan(0.0));
  expect(layout.scale, lessThanOrEqualTo(1.0));

  // Stays within the safe area and the spacing.
  _expectWithin(visual, area);

  // Full size whenever it fits next to the anchor.
  if (bestSpace >= size.height && area.width >= size.width) {
    expect(layout.scale, 1.0);
  }

  final bool isAnchored = layout.scaleAlignment != Alignment.center;
  // Only covers the anchor when there is not enough room next to it.
  expect(
    isAnchored,
    bestSpace >= size.height * pickerMinimumAnchoredScale,
    reason: 'space next to the anchor: $bestSpace',
  );
  if (!isAnchored) return;

  // Opens on the side with more space, without covering the anchor.
  if (spaceAbove >= spaceBelow) {
    expect(visual.bottom, closeTo(anchor.top - dy, _epsilon));
  } else {
    expect(visual.top, closeTo(anchor.bottom + dy, _epsilon));
  }

  // Centered on the anchor unless pinned to an edge.
  final double halfWidth = size.width * layout.scale / 2;
  final bool hasRoomToCenter =
      anchor.center.dx - halfWidth >= area.left &&
      anchor.center.dx + halfWidth <= area.right;
  if (hasRoomToCenter && layout.scale == 1.0) {
    expect(visual.center.dx, closeTo(anchor.center.dx, _epsilon));
  }
}

void main() {
  for (final TestScreen screen in testScreens) {
    group('PickerOverlayLayout on ${screen.name}', () {
      for (final MapEntry<String, Size> picker in _pickers.entries) {
        for (final MapEntry<String, Alignment> position
            in anchorPositions.entries) {
          test('places the ${picker.key} for an anchor '
              'at the ${position.key}', () {
            final Rect anchor = screen.anchorRect(position.value, _anchorSize);

            _expectInvariants(screen, anchor, picker.value);
          });
        }
      }
    });
  }

  group('PickerOverlayLayout edge cases', () {
    const Size size = Size(calendarWidth, calendarDatePickerHeight);
    final TestScreen phone = testScreens.firstWhere(
      (TestScreen screen) => screen.name == 'phone',
    );

    test('opens above when the space above and below is equal', () {
      final double centerY = phone.pickerArea.center.dy;
      final Rect anchor = Rect.fromCenter(
        center: Offset(195.0, centerY),
        width: 120.0,
        height: 34.0,
      );

      final PickerOverlayLayout layout = _compute(phone, anchor, size);

      expect(layout.scaleAlignment.y, 1.0);
    });

    test('stays below the safe area for an anchor partially under it', () {
      const Rect anchor = Rect.fromLTWH(100.0, 20.0, 120.0, 34.0);

      final PickerOverlayLayout layout = _compute(phone, anchor, size);

      final Rect visual = pickerVisualRect(layout, size);
      expect(visual.top, greaterThanOrEqualTo(phone.pickerArea.top));
      expect(layout.scale, 1.0);
    });

    test('stays on the screen for an anchor scrolled above it', () {
      const Rect anchor = Rect.fromLTWH(100.0, -200.0, 120.0, 34.0);

      final PickerOverlayLayout layout = _compute(phone, anchor, size);

      _expectWithin(pickerVisualRect(layout, size), phone.pickerArea);
      expect(layout.scale, 1.0);
    });

    test('stays on the screen for an anchor scrolled below it', () {
      const Rect anchor = Rect.fromLTWH(100.0, 1000.0, 120.0, 34.0);

      final PickerOverlayLayout layout = _compute(phone, anchor, size);

      _expectWithin(pickerVisualRect(layout, size), phone.pickerArea);
      expect(layout.scale, 1.0);
    });

    test('centers on the screen for an anchor covering the screen', () {
      final Rect anchor = Offset.zero & phone.size;

      final PickerOverlayLayout layout = _compute(phone, anchor, size);

      expect(layout.scaleAlignment, Alignment.center);
      expect(layout.scale, 1.0);
      _expectWithin(pickerVisualRect(layout, size), phone.pickerArea);
    });

    test('stays within the spacing when narrower than the picker', () {
      const TestScreen narrow = TestScreen(
        name: 'narrow',
        size: Size(230.0, 800.0),
        padding: EdgeInsets.zero,
      );
      const Rect anchor = Rect.fromLTWH(10.0, 100.0, 40.0, 40.0);

      final PickerOverlayLayout layout = _compute(narrow, anchor, size);

      _expectWithin(pickerVisualRect(layout, size), narrow.pickerArea);
      expect(layout.scale, closeTo(200.0 / 320.0, _epsilon));
    });
  });
}
