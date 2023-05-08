import 'package:flutter/cupertino.dart';

class CalendarWeekday extends StatelessWidget {
  const CalendarWeekday({
    required this.weekday,
    this.style,
    this.textAlign,
    super.key,
  });

  final String weekday;
  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        weekday,
        textAlign: textAlign ?? TextAlign.center,
        style: style ??
            TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.tertiaryLabel,
                  darkColor: CupertinoColors.tertiaryLabel.darkColor,
                ),
                context,
              ),
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.08,
            ),
      ),
    );
  }
}
