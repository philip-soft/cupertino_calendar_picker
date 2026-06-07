// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

SliverConstraints _constraints({
  double crossAxisExtent = 280.0,
  AxisDirection crossAxisDirection = AxisDirection.right,
}) {
  return SliverConstraints(
    axisDirection: AxisDirection.down,
    growthDirection: GrowthDirection.forward,
    userScrollDirection: ScrollDirection.idle,
    scrollOffset: 0.0,
    precedingScrollExtent: 0.0,
    overlap: 0.0,
    remainingPaintExtent: 600.0,
    crossAxisExtent: crossAxisExtent,
    crossAxisDirection: crossAxisDirection,
    viewportMainAxisExtent: 600.0,
    remainingCacheExtent: 600.0,
    cacheOrigin: 0.0,
  );
}

void main() {
  group('CalendarMonthPickerGridDelegate', () {
    test('produces 7 columns matching DateTime.daysPerWeek', () {
      const CalendarMonthPickerGridDelegate delegate =
          CalendarMonthPickerGridDelegate(rowSize: 40.0);
      final SliverConstraints constraints = _constraints();

      final SliverGridRegularTileLayout layout =
          delegate.getLayout(constraints) as SliverGridRegularTileLayout;

      expect(layout.crossAxisCount, DateTime.daysPerWeek);
      expect(layout.crossAxisCount, 7);
    });

    test('tileWidth equals crossAxisExtent divided by columns', () {
      const CalendarMonthPickerGridDelegate delegate =
          CalendarMonthPickerGridDelegate(rowSize: 40.0);
      final SliverConstraints constraints = _constraints();

      final SliverGridRegularTileLayout layout =
          delegate.getLayout(constraints) as SliverGridRegularTileLayout;

      expect(layout.childCrossAxisExtent, 40.0);
      expect(layout.crossAxisStride, 40.0);
    });

    test('tileHeight matches the supplied rowSize', () {
      const CalendarMonthPickerGridDelegate delegate =
          CalendarMonthPickerGridDelegate(rowSize: 50.0);
      final SliverConstraints constraints = _constraints();

      final SliverGridRegularTileLayout layout =
          delegate.getLayout(constraints) as SliverGridRegularTileLayout;

      expect(layout.childMainAxisExtent, 50.0);
      expect(layout.mainAxisStride, 50.0);
    });

    test('reverseCrossAxis is false for AxisDirection.right', () {
      const CalendarMonthPickerGridDelegate delegate =
          CalendarMonthPickerGridDelegate(rowSize: 40.0);

      final SliverGridRegularTileLayout layout =
          delegate.getLayout(_constraints()) as SliverGridRegularTileLayout;

      expect(layout.reverseCrossAxis, isFalse);
    });

    test('reverseCrossAxis is true for AxisDirection.left', () {
      const CalendarMonthPickerGridDelegate delegate =
          CalendarMonthPickerGridDelegate(rowSize: 40.0);

      final SliverGridRegularTileLayout layout = delegate.getLayout(
        _constraints(crossAxisDirection: AxisDirection.left),
      ) as SliverGridRegularTileLayout;

      expect(layout.reverseCrossAxis, isTrue);
    });

    test('shouldRelayout always returns false', () {
      const CalendarMonthPickerGridDelegate a =
          CalendarMonthPickerGridDelegate(rowSize: 40.0);
      const CalendarMonthPickerGridDelegate b =
          CalendarMonthPickerGridDelegate(rowSize: 50.0);

      expect(a.shouldRelayout(b), isFalse);
      expect(a.shouldRelayout(a), isFalse);
    });
  });
}
