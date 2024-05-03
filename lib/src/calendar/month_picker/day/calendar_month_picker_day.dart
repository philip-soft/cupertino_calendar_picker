import 'dart:ui';

import 'package:cupertino_calendar/src/src.dart';
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
          style: style.textStyle,
          backgroundCircleColor:
              dayStyle is CalendarMonthPickerBackgroundCircledDayStyle
                  ? dayStyle.backgroundCircleColor
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
    required this.style,
    required this.backgroundCircleSize,
    this.backgroundCircleColor,
  });

  final String day;
  final TextStyle style;
  final Color? backgroundCircleColor;
  final double backgroundCircleSize;

  @override
  void paint(Canvas canvas, Size size) {
    final ParagraphBuilder paragraphBuilder = ParagraphBuilder(
      style.getParagraphStyle(textAlign: TextAlign.center),
    )
      ..pushStyle(style.getTextStyle())
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
        backgroundCircleColor != oldPainter.backgroundCircleColor;
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
}
