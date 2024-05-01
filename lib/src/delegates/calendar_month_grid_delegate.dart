import 'package:flutter/rendering.dart';

class CalendarMonthGridDelegate extends SliverGridDelegate {
  const CalendarMonthGridDelegate({
    required this.rowCount,
    required this.rowSize,
  });

  final int rowCount;
  final double rowSize;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = rowSize;

    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(CalendarMonthGridDelegate oldDelegate) => false;
}
