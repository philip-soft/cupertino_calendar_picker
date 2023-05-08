import 'package:flutter/cupertino.dart';

class Day extends StatelessWidget {
  const Day({
    required this.day,
    this.isToday = false,
    super.key,
  });

  final String day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: isToday
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: CupertinoDynamicColor.resolve(
                CupertinoDynamicColor.withBrightness(
                  color: CupertinoColors.systemRed,
                  darkColor: CupertinoColors.systemRed.darkColor,
                ),
                context,
              ),
            )
          : const BoxDecoration(),
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isToday
                ? CupertinoColors.white
                : CupertinoDynamicColor.resolve(
                    CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.label,
                      darkColor: CupertinoColors.label.darkColor,
                    ),
                    context,
                  ),
            fontSize: 20.0,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 0.38,
          ),
        ),
      ),
    );
  }
}
