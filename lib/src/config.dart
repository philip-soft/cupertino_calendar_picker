import 'package:flutter/material.dart';

const double calendarMonthPickerDaySize = 42.0;
const double calendarWidth = 320.0;
const double calendarHeight = calendarWidth / calendarAspectRatio;
const double calendarAspectRatio = 960 / 945;
const double calendarMonthPickerFiveRowsPadding = 5.0;
const double calendarMonthPickerOtherRowsAmountPadding = 3.0;

const Duration calendarAnimationDuration = Duration(milliseconds: 430);
const Duration calendarAnimationReverseDuration = Duration(milliseconds: 280);
const Duration monthScrollDuration = Duration(milliseconds: 400);
const Cubic calendarAnimationCurve = Curves.ease;
