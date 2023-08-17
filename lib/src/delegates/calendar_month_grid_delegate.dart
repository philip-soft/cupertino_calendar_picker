import 'dart:math';

import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/rendering.dart';

class CalendarMonthGridDelegate extends SliverGridDelegate {
  const CalendarMonthGridDelegate({
    required this.rowCount,
    required this.calendarDayRowSize,
  });

  final int rowCount;
  final double calendarDayRowSize;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = min(
      calendarDayRowSize,
      constraints.viewportMainAxisExtent / (rowCount + 1),
    );
    late double rowPadding;

    if (rowCount == 5) {
      rowPadding = calendarMonthPickerFiveRowsPadding;
    } else if (rowCount > 5 || rowCount < 5) {
      rowPadding = calendarMonthPickerOtherRowsAmountPadding;
    }

    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight + rowPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(CalendarMonthGridDelegate oldDelegate) => false;
}
