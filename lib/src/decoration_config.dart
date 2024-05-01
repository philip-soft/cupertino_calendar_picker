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

const CupertinoDynamicColor calendarMonthPickerDisabledDayColor =
    CupertinoColors.tertiaryLabel;
const TextStyle calendarMonthPickerDisabledDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDisabledDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerDefaultDayColor =
    CupertinoColors.label;
const TextStyle calendarMonthPickerDefaultDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerDefaultDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);

const CupertinoDynamicColor calendarMonthPickerSelectedDayColor =
    CupertinoColors.systemRed;

final Color calendarMonthPickerSelectedDayBackgroundColor =
    CupertinoColors.systemRed.withOpacity(0.12);

const TextStyle calendarMonthPickerSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  color: calendarMonthPickerSelectedDayColor,
  fontWeight: FontWeight.w500,
);
const CupertinoDynamicColor calendarMonthPickerCurrentAndSelectedDayColor =
    CupertinoColors.systemRed;
final TextStyle calendarMonthPickerCurrentAndSelectedDayStyle = TextStyle(
  fontSize: 22.0,
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.label.darkColor,
    darkColor: CupertinoColors.label.darkColor,
  ),
  fontWeight: FontWeight.w500,
);
const CupertinoDynamicColor calendarMonthPickerCurrentDayColor =
    CupertinoColors.systemRed;

const TextStyle calendarMonthPickerCurrentDayStyle = TextStyle(
  fontSize: 20.0,
  color: calendarMonthPickerCurrentDayColor,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.4,
);
