// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('package_config dimensions', () {
    test('calendar icon and switcher sizes are positive', () {
      expect(calendarMonthPickerIconSize, greaterThan(0));
      expect(calendarMonthSwitcherIconSize, greaterThan(0));
      expect(calendarMonthSwitcherSize, greaterThan(0));
    });

    test('calendar day cell sizes are positive', () {
      expect(calendarMonthPickerDayMaxSize, greaterThan(0));
      expect(calendarMonthPickerSixRowsSize, greaterThan(0));
      expect(calendarMonthPickerOtherRowsSize, greaterThan(0));
    });

    test('weekday height and paddings are non-negative', () {
      expect(calendarMonthPickerHorizontalPadding, greaterThanOrEqualTo(0));
      expect(calendarWeekdaysHorizontalPadding, greaterThanOrEqualTo(0));
      expect(calendarWeekdaysHeight, greaterThan(0));
    });

    test('calendar container dimensions match documented values', () {
      expect(calendarWidth, 320.0);
      expect(calendarDatePickerHeight, 332.0);
      expect(calendarDateTimePickerHeight, 378.0);
      expect(calendarActionsHeight, 44.0);
    });

    test('blur amount and alpha values are positive and within byte range', () {
      expect(calendarBlurAmount, greaterThan(0));
      expect(pickerContainerBlur, greaterThan(0));
      expect(calendarBluredLightBackgroundColorAlpha, inInclusiveRange(0, 255));
      expect(calendarBluredDarkBackgroundColorAlpha, inInclusiveRange(0, 255));
    });

    test('text scale clamps are >= 1.0', () {
      expect(calendarMaxTextScaleFactor, greaterThanOrEqualTo(1.0));
      expect(calendarFormatChangeTextScaleFactor, greaterThanOrEqualTo(1.0));
    });

    test('time picker dimensions are positive', () {
      expect(timePickerWidth, greaterThan(0));
      expect(timePickerHeight, greaterThan(0));
      expect(timePickerWheelHeight, greaterThan(0));
    });
  });

  group('package_config durations', () {
    test('button durations are non-zero', () {
      expect(pickerButtonFadeOutDuration, isNot(Duration.zero));
      expect(pickerButtonFadeInDuration, isNot(Duration.zero));
      expect(pickerButtonFadeDuration, isNot(Duration.zero));
      expect(pickerButtonTextStyleDuration, isNot(Duration.zero));
    });

    test('button fade durations have the documented values', () {
      expect(
        pickerButtonFadeOutDuration,
        const Duration(milliseconds: 1000),
      );
      expect(pickerButtonFadeInDuration, const Duration(milliseconds: 800));
      expect(pickerButtonFadeDuration, const Duration(milliseconds: 200));
      expect(
        pickerButtonTextStyleDuration,
        const Duration(milliseconds: 100),
      );
    });

    test('calendar animation durations have the documented values', () {
      expect(calendarAnimationDuration, const Duration(milliseconds: 430));
      expect(
        calendarAnimationReverseDuration,
        const Duration(milliseconds: 280),
      );
      expect(monthScrollDuration, const Duration(milliseconds: 400));
      expect(innerPickersFadeDuration, const Duration(milliseconds: 250));
    });

    test('calendar animation curve is ease', () {
      expect(calendarAnimationCurve, Curves.ease);
    });
  });

  group('package_config route names', () {
    test('calendar picker route and barrier labels are non-empty', () {
      expect(calendarPickerRouteName, isNotEmpty);
      expect(calendarPickerBarrierLabel, isNotEmpty);
    });

    test('time picker route and barrier labels are non-empty', () {
      expect(timePickerRouteName, isNotEmpty);
      expect(timePickerBarrierLabel, isNotEmpty);
    });

    test('route names are distinct between calendar and time picker', () {
      expect(calendarPickerRouteName, isNot(timePickerRouteName));
      expect(calendarPickerBarrierLabel, isNot(timePickerBarrierLabel));
    });
  });
}
