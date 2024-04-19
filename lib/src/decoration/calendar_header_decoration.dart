import 'package:flutter/cupertino.dart';

class CalendarHeaderDecoration {
  const CalendarHeaderDecoration({
    this.monthDateArrowColor,
    this.forwardButtonColor,
    this.backwardButtonColor,
    this.backwardDisabledButtonColor,
    this.forwardDisabledButtonColor,
  });

  factory CalendarHeaderDecoration.defaultDecoration(
    BuildContext context, {
    Color? monthDateArrowColor,
    Color? forwardButtonColor,
    Color? backwardButtonColor,
    Color? backwardDisabledButtonColor,
    Color? forwardDisabledButtonColor,
  }) {
    return CalendarHeaderDecoration(
      monthDateArrowColor: monthDateArrowColor ??
          CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
            context,
          ),
      forwardButtonColor: forwardButtonColor ??
          CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
            context,
          ),
      backwardButtonColor: backwardButtonColor ??
          CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemRed,
              darkColor: CupertinoColors.systemRed.darkColor,
            ),
            context,
          ),
      forwardDisabledButtonColor: forwardDisabledButtonColor ??
          CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.opaqueSeparator,
              darkColor: CupertinoColors.opaqueSeparator.darkColor,
            ),
            context,
          ),
      backwardDisabledButtonColor: backwardDisabledButtonColor ??
          CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.opaqueSeparator,
              darkColor: CupertinoColors.opaqueSeparator.darkColor,
            ),
            context,
          ),
    );
  }

  final Color? monthDateArrowColor;
  final Color? forwardButtonColor;
  final Color? backwardButtonColor;
  final Color? backwardDisabledButtonColor;
  final Color? forwardDisabledButtonColor;
}
