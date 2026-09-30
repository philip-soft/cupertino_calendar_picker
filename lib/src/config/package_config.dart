// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

// CALENDAR

const double calendarMonthPickerIconSize = 20.0;
const double calendarMonthSwitcherIconSize = 26.5;
const double calendarMonthSwitcherSize = 44.0;
const double calendarMonthSwitcherSpacing = 2.0;
const double calendarMonthPickerDayMaxSize = 42.0;
const double calendarMonthPickerSixRowsSize = 38.0;
const double calendarMonthPickerOtherRowsSize = 46.0;
const double calendarMonthPickerHorizontalPadding = 11.0;
const double calendarWeekdaysHorizontalPadding = 12.0;
const double calendarWeekdaysHeight = 18.0;
const double calendarWeekdayWidth = 40.0;
const double calendarWidth = 320.0;
const double calendarDatePickerHeight = 332.0;
const double calendarDateTimePickerHeight = 378.0;
const int calendarBlurredLightBackgroundColorAlpha = 180;
const int calendarBlurredDarkBackgroundColorAlpha = 160;
const int calendarSelectedDayBackgroundAlpha = 30;
const double calendarActionsHeight = 44.0;
const double calendarMaxTextScaleFactor = 1.3;
const double calendarFormatChangeTextScaleFactor = 1.24;
const Color calendarDefaultMainColor = CupertinoColors.systemRed;

// CALENDAR LAYOUT

const double calendarHeaderTopSpacing = 13.0;
const double calendarHeaderLeadingSpacing = 20.0;
const double calendarHeaderTitleArrowSpacing = 5.0;
const double calendarHeaderArrowWidth = 11.0;
const double calendarHeaderArrowHeight = 22.0;
const double calendarWeekdaysTopSpacing = 11.0;
const EdgeInsets calendarInnerPickerPadding = EdgeInsets.only(
  left: 7.0,
  right: 7.0,
  top: 10.0,
  bottom: 38.0,
);

// CALENDAR FOOTER

const double calendarFooterHorizontalSpacing = 16.0;
const double calendarFooterTopSpacing = 5.0;
const double calendarFooterBottomSpacing = 7.0;
const double calendarFooterTimeButtonHeight = 34.0;
const double calendarFooterTimeButtonRadius = 6.0;
const double calendarFooterTimeButtonHorizontalPadding = 11.0;
const double calendarFooterDayPeriodSpacing = 8.0;
const double calendarFooterDayPeriodItemSize = 30.0;

// PICKER CONTAINER

const double pickerContainerBlur = 40.0;

// PICKER OVERLAY

const double pickerDefaultHorizontalSpacing = 15.0;
const double pickerDefaultVerticalSpacing = 15.0;
const Offset pickerDefaultOffset = Offset(0.0, 10.0);

/// The animation value the dismiss animation starts from, so that the overlay
/// closes with a short bounce-less shrink rather than replaying the overshoot.
const double pickerDismissAnimationStartValue = 0.75;

// TIME PICKER

const double timePickerWidth = 231.0;
const double timePickerHeight = 203.0;
const double timePickerWheelHeight = 160.0;
const double timePickerHorizontalPadding = 7.5;

// BUTTON

const double pickerButtonHeight = 34.0;
const double pickerButtonBorderRadius = 8.0;
const double pickerButtonHorizontalPadding = 12.0;
const double pickerButtonPressedOpacity = 0.4;
const Duration pickerButtonFadeOutDuration = Duration(milliseconds: 1000);
const Duration pickerButtonFadeInDuration = Duration(milliseconds: 800);
const Duration pickerButtonFadeDuration = Duration(milliseconds: 200);
const Duration pickerButtonTextStyleDuration = Duration(milliseconds: 100);

// ANIMATION

const Duration calendarAnimationDuration = Duration(milliseconds: 430);
const Duration calendarAnimationReverseDuration = Duration(milliseconds: 280);
const Duration monthScrollDuration = Duration(milliseconds: 400);
const Cubic calendarAnimationCurve = Curves.ease;
const Duration innerPickersFadeDuration = Duration(milliseconds: 250);

// Other

const String calendarPickerRouteName = 'CupertinoCalendarPicker';
const String calendarPickerBarrierLabel = 'CupertinoCalendarPickerBarrier';

const String timePickerRouteName = 'CupertinoTimePicker';
const String timePickerBarrierLabel = 'CupertinoTimePickerBarrier';
