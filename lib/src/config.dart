import 'package:flutter/cupertino.dart';

// APPEARANCE

const double calendarMonthPickerIconSize = 20.0;
const double calendarMonthSwitcherIconSize = 26.5;
const double calendarMonthSwitcherSize = 44.0;
const double calendarMonthPickerDaySize = 42.0;
const double calendarWidth = 320.0;
const double calendarHeight = calendarWidth / calendarAspectRatio;
const double calendarAspectRatio = 960 / 945;
const double calendarMonthPickerFiveRowsPadding = 5.0;
const double calendarMonthPickerOtherRowsAmountPadding = 3.0;

// ANIMATION

const Duration calendarAnimationDuration = Duration(milliseconds: 430);
const Duration calendarAnimationReverseDuration = Duration(milliseconds: 280);
const Duration monthScrollDuration = Duration(milliseconds: 400);
const Cubic calendarAnimationCurve = Curves.ease;
const double calendarMaxAnimationHeight = 319.0;
