import 'dart:ui';

import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';

class CalendarMonthPickerDay extends StatelessWidget {
  const CalendarMonthPickerDay({
    required this.dayDate,
    this.onDaySelected,
    required this.style,
    super.key,
  });

  final DateTime dayDate;
  final CalendarMonthPickerDayStyle style;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDaySelected != null ? () => onDaySelected?.call(dayDate) : null,
      child: SizedBox(
        height: 44.0,
        width: 44.0,
        child: CustomPaint(
          painter: CalendarMonthPickerDayPainter(
            day: '${dayDate.day}',
            style: style.textStyle,
            backgroundColor: style.backgroundColor,
          ),
        ),
      ),
    );
  }
}

class CalendarMonthPickerDayPainter extends CustomPainter {
  const CalendarMonthPickerDayPainter({
    required this.day,
    required this.style,
    this.backgroundColor,
  });

  final String day;
  final Color? backgroundColor;
  final TextStyle style;

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

    if (backgroundColor != null) {
      _drawBackgroundCircle(
        canvas,
        Offset(centerX, centerY),
        backgroundColor!,
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
        backgroundColor != oldPainter.backgroundColor;
  }

  void _drawDayParagraph(Canvas canvas, Offset offset, Paragraph day) {
    canvas.drawParagraph(day, offset);
  }

  void _drawBackgroundCircle(Canvas canvas, Offset offset, Color color) {
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(
      offset,
      calendarMonthPickerDayHeight / 2,
      paint,
    );
  }
}
