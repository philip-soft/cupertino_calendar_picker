// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CalendarMonthPickerDay extends StatelessWidget {
  const CalendarMonthPickerDay({
    required this.dayDate,
    required this.style,
    required this.backgroundCircleSize,
    this.onDaySelected,
    super.key,
  });

  final DateTime dayDate;
  final CalendarMonthPickerDayStyle style;
  final double backgroundCircleSize;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  Widget build(BuildContext context) {
    final CalendarMonthPickerDayStyle dayStyle = style;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDaySelected != null ? () => onDaySelected?.call(dayDate) : null,
      child: CustomPaint(
        painter: CalendarMonthPickerDayPainter(
          day: '${dayDate.day}',
          textScaler: context.textScaler,
          style: style.textStyle,
          backgroundCircleColor:
              dayStyle is CalendarMonthPickerBackgroundCircledDayStyle
                  ? dayStyle.backgroundCircleColor
                  : null,
          backgroundCircleSize: backgroundCircleSize,
          borderColor: dayStyle is CalendarMonthPickerCurrentDayStyle
              ? dayStyle.borderColor
              : null,
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
    this.borderColor,
  });

  final TextScaler textScaler;
  final String day;
  final TextStyle style;
  final Color? backgroundCircleColor;
  final Color? borderColor;
  final double backgroundCircleSize;
  @override
  void paint(Canvas canvas, Size size) {
    final ParagraphBuilder paragraphBuilder = ParagraphBuilder(
      style.getParagraphStyle(textAlign: TextAlign.center),
    )
      ..pushStyle(style.getTextStyle(textScaler: textScaler))
      ..addText(day);

    final Paragraph dayPragrapth = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width));

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double dayHalfHeight = dayPragrapth.height / 2;

    if (backgroundCircleColor != null) {
      _drawBackgroundCircle(
        canvas,
        Offset(centerX, centerY),
        backgroundCircleColor!,
      );
    }

    if (borderColor != null) {
      _drawBorder(canvas, Offset(centerX, centerY), borderColor!);
    }

    final double dayBottomY = centerY - dayHalfHeight;
    _drawDayParagraph(
      canvas,
      Offset(0.0, dayBottomY),
      dayPragrapth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final CalendarMonthPickerDayPainter oldPainter =
        oldDelegate as CalendarMonthPickerDayPainter;
    return style != oldPainter.style ||
        backgroundCircleColor != oldPainter.backgroundCircleColor ||
        day != oldPainter.day ||
        backgroundCircleSize != oldPainter.backgroundCircleSize ||
        textScaler != oldPainter.textScaler;
  }

  void _drawDayParagraph(Canvas canvas, Offset offset, Paragraph day) {
    canvas.drawParagraph(day, offset);
  }

  void _drawBackgroundCircle(Canvas canvas, Offset offset, Color color) {
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(
      offset,
      backgroundCircleSize / 2,
      paint,
    );
  }

  void _drawBorder(Canvas canvas, Offset offset, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(
      offset,
      backgroundCircleSize / 2,
      paint,
    );
  }
}
