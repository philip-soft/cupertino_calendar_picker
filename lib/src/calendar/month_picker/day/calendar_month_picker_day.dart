// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class CalendarMonthPickerDay extends StatelessWidget {
  const CalendarMonthPickerDay({
    required this.dayDate,
    required this.style,
    required this.backgroundCircleSize,
    this.isSelected = false,
    this.isToday = false,
    this.onDaySelected,
    super.key,
  });

  final DateTime dayDate;
  final CalendarMonthPickerDayStyle style;
  final double backgroundCircleSize;
  final bool isSelected;
  final bool isToday;
  final ValueChanged<DateTime>? onDaySelected;

  String _semanticsLabel(BuildContext context) {
    final String date = DateFormat.yMMMMEEEEd(context.localeString)
        .format(dayDate);
    if (!isToday) return date;
    return '${context.materialLocalization.currentDateLabel}, $date';
  }

  @override
  Widget build(BuildContext context) {
    final CalendarMonthPickerDayStyle dayStyle = style;
    final ValueChanged<DateTime>? onDaySelected = this.onDaySelected;

    return CupertinoPickerTapTarget(
      onTap: onDaySelected == null ? null : () => onDaySelected(dayDate),
      semanticsLabel: _semanticsLabel(context),
      isSelected: isSelected,
      child: CustomPaint(
        painter: CalendarMonthPickerDayPainter(
          day: '${dayDate.day}',
          textScaler: context.textScaler,
          style: dayStyle.textStyle.resolveDynamic(context),
          backgroundCircleColor:
              dayStyle is CalendarMonthPickerBackgroundCircledDayStyle
              ? dayStyle.backgroundCircleColor.resolveDynamic(context)
              : null,
          backgroundCircleSize: backgroundCircleSize,
        ),
      ),
    );
  }
}

class CalendarMonthPickerDayPainter extends CustomPainter {
  const CalendarMonthPickerDayPainter({
    required this.day,
    required this.textScaler,
    required this.style,
    required this.backgroundCircleSize,
    this.backgroundCircleColor,
  });

  final TextScaler textScaler;
  final String day;
  final TextStyle style;
  final Color? backgroundCircleColor;
  final double backgroundCircleSize;

  @override
  void paint(Canvas canvas, Size size) {
    final ParagraphBuilder paragraphBuilder =
        ParagraphBuilder(style.getParagraphStyle(textAlign: TextAlign.center))
          ..pushStyle(style.getTextStyle(textScaler: textScaler))
          ..addText(day);

    final Paragraph dayParagraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width));

    final Offset center = size.center(Offset.zero);
    final Color? backgroundCircleColor = this.backgroundCircleColor;

    if (backgroundCircleColor != null) {
      _drawBackgroundCircle(canvas, center, backgroundCircleColor);
    }

    final double dayTopY = center.dy - dayParagraph.height / 2;
    canvas.drawParagraph(dayParagraph, Offset(0.0, dayTopY));
  }

  @override
  bool shouldRepaint(CalendarMonthPickerDayPainter oldDelegate) {
    return style != oldDelegate.style ||
        backgroundCircleColor != oldDelegate.backgroundCircleColor ||
        day != oldDelegate.day ||
        backgroundCircleSize != oldDelegate.backgroundCircleSize ||
        textScaler != oldDelegate.textScaler;
  }

  void _drawBackgroundCircle(Canvas canvas, Offset center, Color color) {
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(center, backgroundCircleSize / 2, paint);
  }
}
