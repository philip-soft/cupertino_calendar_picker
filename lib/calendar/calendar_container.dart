import 'package:flutter/cupertino.dart';

class CalendarContainer extends StatelessWidget {
  const CalendarContainer({
    required this.child,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(13.0)),
    this.clipBehavior = Clip.antiAlias,
    this.boxShadow,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final Clip clipBehavior;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor ??
            CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.systemBackground,
                darkColor: CupertinoColors.systemBackground.darkElevatedColor,
              ),
              context,
            ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: CupertinoDynamicColor.resolve(
                  CupertinoDynamicColor.withBrightness(
                    color: CupertinoColors.systemBackground,
                    darkColor:
                        CupertinoColors.systemBackground.darkElevatedColor,
                  ),
                  context,
                ),
                offset: const Offset(0, 10),
                blurRadius: 60.0,
              ),
            ],
      ),
      child: child,
    );
  }
}
