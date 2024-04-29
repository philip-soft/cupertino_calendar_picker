import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor calendarBackgroundColor =
    CupertinoColors.systemBackground;
const List<BoxShadow> calendarBoxShadow = <BoxShadow>[
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    offset: Offset(0.0, 10.0),
    blurRadius: 60.0,
  ),
];
final BorderRadius calendarBorderRadius = BorderRadius.circular(13.0);
final CupertinoDynamicColor calendarBackgroundDynamicColor =
    CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.systemBackground,
  darkColor: CupertinoColors.systemBackground.darkElevatedColor,
);

const CupertinoDynamicColor calendarWeekdayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarWeekdayStyle = TextStyle(
  color: calendarWeekdayColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

const CupertinoDynamicColor calendarMontDateColor = CupertinoColors.label;
const TextStyle calendarMonthDateStyle = TextStyle(
  color: calendarMontDateColor,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  letterSpacing: -0.5,
);
const CupertinoDynamicColor calendarMonthDateArrowColor =
    CupertinoColors.systemRed;
const CupertinoDynamicColor calendarForwardButtonColor =
    CupertinoColors.systemRed;
const CupertinoDynamicColor calendarBackwardButtonColor =
    CupertinoColors.systemRed;
const CupertinoDynamicColor calendarForwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;
const CupertinoDynamicColor calendarBackwardDisabledButtonColor =
    CupertinoColors.opaqueSeparator;
