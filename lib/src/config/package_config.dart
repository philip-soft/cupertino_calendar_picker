// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

// CALENDAR

const double calendarMonthPickerIconSize = 20.0;
const double calendarMonthSwitcherIconSize = 26.5;
const double calendarMonthSwitcherSize = 44.0;
const double calendarMonthPickerDayMaxSize = 42.0;
const double calendarMonthPickerSixRowsSize = 38.0;
const double calendarMonthPickerOtherRowsSize = 46.0;
const double calendarMonthPickerHorizontalPadding = 11.0;
const double calendarWeekdaysHorizontalPadding = 12.0;
const double calendarWeekdaysHeight = 18.0;
const double calendarWidth = 320.0;
const double calendarDatePickerHeight = 332.0;
const double calendarDateTimePickerHeight = 378.0;
const double calendarBlurAmount = 40.0;
const int calendarBluredLightBackgroundColorAlpha = 180;
const int calendarBluredDarkBackgroundColorAlpha = 160;

// TIME PICKER
const double timePickerWidth = 231.0;
const double timePickerHeight = 203.0;
const double timePickerWheelHeight = 160.0;

// BUTTON
const Duration pickerButtonFadeOutDuration = Duration(milliseconds: 1000);
const Duration pickerButtonFadeInDuration = Duration(milliseconds: 800);
const Duration pickerButtonFadeDuration = Duration(milliseconds: 200);
const Duration pickerButtonTextStyleDuration = Duration(milliseconds: 100);

// ANIMATION

const Duration calendarAnimationDuration = Duration(milliseconds: 430);
const Duration calendarAnimationReverseDuration = Duration(milliseconds: 280);
const Duration monthScrollDuration = Duration(milliseconds: 400);
const Cubic calendarAnimationCurve = Curves.ease;
const Duration calendarHeaderFadeDuration = Duration(milliseconds: 300);
const Duration pickerFadeDuration = Duration(milliseconds: 250);
const Duration calendarYearPickerDuration = Duration(milliseconds: 500);

// Other

const String calendarPickerRouteName = 'CupertinoCalendarPicker';
const String calendarPickerBarrierLabel = 'CupertinoCalendarPickerBarrier';

const String timePickerRouteName = 'CupertinoTimePicker';
const String timePickerBarrierLabel = 'CupertinoTimePickerBarrier';
