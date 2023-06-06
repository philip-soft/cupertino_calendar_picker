import 'dart:math';

import 'package:flutter/rendering.dart';

class CalendarMonthGridDelegate extends SliverGridDelegate {
  const CalendarMonthGridDelegate({
    required this.rowCount,
    required this.calendarDayRowHeight,
  });

  final int rowCount;
  final double calendarDayRowHeight;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = min(
      calendarDayRowHeight,
      constraints.viewportMainAxisExtent / (rowCount + 1),
    );
    late double factor;

    // TODO: Check factor
    if (rowCount > 5) {
      factor = 1.5;
    } else if (rowCount < 5) {
      factor = -1.5;
    } else {
      factor = 0.0;
    }
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: (tileHeight * 1.135) - factor,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(CalendarMonthGridDelegate oldDelegate) => false;
}
