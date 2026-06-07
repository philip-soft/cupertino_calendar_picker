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
  group('CalendarWeekdayDecoration', () {
    test('defaults to calendarWeekdayStyle when no style is provided', () {
      final CalendarWeekdayDecoration decoration = CalendarWeekdayDecoration();

      expect(decoration.textStyle, calendarWeekdayStyle);
    });

    test('uses supplied textStyle', () {
      const TextStyle style = TextStyle(fontSize: 15.0);

      final CalendarWeekdayDecoration decoration =
          CalendarWeekdayDecoration(textStyle: style);

      expect(decoration.textStyle, style);
    });

    group('copyWith', () {
      test('returns identical values when no params are provided', () {
        final CalendarWeekdayDecoration original = CalendarWeekdayDecoration();

        final CalendarWeekdayDecoration copy = original.copyWith();

        expect(copy.textStyle, original.textStyle);
      });

      test('overrides textStyle when provided', () {
        const TextStyle style = TextStyle(fontSize: 9.0);
        final CalendarWeekdayDecoration original = CalendarWeekdayDecoration();

        final CalendarWeekdayDecoration copy =
            original.copyWith(textStyle: style);

        expect(copy.textStyle, style);
      });
    });

    group('withDynamicColor', () {
      testWidgets('resolves the textStyle color in light mode',
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

        final CalendarWeekdayDecoration decoration =
            CalendarWeekdayDecoration.withDynamicColor(ctx);

        expect(decoration.textStyle.color, isNotNull);
      });

      testWidgets('produces different resolved colors in dark vs light',
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
        final CalendarWeekdayDecoration light =
            CalendarWeekdayDecoration.withDynamicColor(lightCtx);

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
        final CalendarWeekdayDecoration dark =
            CalendarWeekdayDecoration.withDynamicColor(darkCtx);

        expect(light.textStyle.color, isNot(dark.textStyle.color));
      });
    });
  });
}
