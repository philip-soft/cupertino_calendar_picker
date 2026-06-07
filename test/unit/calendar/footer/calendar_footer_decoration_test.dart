// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return CupertinoApp(
    theme: CupertinoThemeData(brightness: brightness),
    home: child,
  );
}

void main() {
  group('CalendarFooterDecoration', () {
    test('defaults are applied when no params are provided', () {
      final CalendarFooterDecoration decoration = CalendarFooterDecoration();

      expect(decoration.timeLabelStyle, calendarFooterTimeLabelStyle);
      expect(decoration.timeStyle, calendarTimeStyle);
      expect(decoration.dayPeriodTextStyle, calendarDayPeriodTextStyle);
    });

    test('uses supplied styles when provided', () {
      const TextStyle label = TextStyle(fontSize: 11.0);
      const TextStyle time = TextStyle(fontSize: 12.0);
      const TextStyle period = TextStyle(fontSize: 13.0);

      final CalendarFooterDecoration decoration = CalendarFooterDecoration(
        timeLabelStyle: label,
        timeStyle: time,
        dayPeriodTextStyle: period,
      );

      expect(decoration.timeLabelStyle, label);
      expect(decoration.timeStyle, time);
      expect(decoration.dayPeriodTextStyle, period);
    });

    group('copyWith', () {
      test('returns identical values when no params are provided', () {
        final CalendarFooterDecoration original = CalendarFooterDecoration();

        final CalendarFooterDecoration copy = original.copyWith();

        expect(copy.timeLabelStyle, original.timeLabelStyle);
        expect(copy.timeStyle, original.timeStyle);
        expect(copy.dayPeriodTextStyle, original.dayPeriodTextStyle);
      });

      test('overrides only the supplied fields', () {
        const TextStyle override = TextStyle(fontSize: 7.0);
        final CalendarFooterDecoration original = CalendarFooterDecoration();

        final CalendarFooterDecoration copy =
            original.copyWith(timeStyle: override);

        expect(copy.timeStyle, override);
        expect(copy.timeLabelStyle, original.timeLabelStyle);
        expect(copy.dayPeriodTextStyle, original.dayPeriodTextStyle);
      });
    });

    group('withDynamicColor', () {
      testWidgets('resolves all three style colors in light mode',
          (WidgetTester tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                ctx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final CalendarFooterDecoration decoration =
            CalendarFooterDecoration.withDynamicColor(ctx);

        expect(decoration.timeLabelStyle?.color, isNotNull);
        expect(decoration.timeStyle?.color, isNotNull);
        expect(decoration.dayPeriodTextStyle?.color, isNotNull);
      });

      testWidgets('produces different colors in dark vs light brightness',
          (WidgetTester tester) async {
        late BuildContext lightCtx;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                lightCtx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        final CalendarFooterDecoration light =
            CalendarFooterDecoration.withDynamicColor(lightCtx);

        late BuildContext darkCtx;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                darkCtx = context;
                return const SizedBox.shrink();
              },
            ),
            brightness: Brightness.dark,
          ),
        );
        final CalendarFooterDecoration dark =
            CalendarFooterDecoration.withDynamicColor(darkCtx);

        expect(light.timeStyle?.color, isNot(dark.timeStyle?.color));
      });
    });
  });
}
