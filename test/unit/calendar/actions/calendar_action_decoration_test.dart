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
  group('CalendarActionDecoration', () {
    test('default factory falls back to calendarActionLabelStyle', () {
      final CalendarActionDecoration decoration = CalendarActionDecoration();

      expect(decoration.labelStyle, calendarActionLabelStyle);
      expect(decoration.pressedColor, calendarActionPressedColor);
    });

    test('uses supplied labelStyle and pressedColor', () {
      const TextStyle style = TextStyle(fontSize: 13.0);
      const Color color = Color(0xFFABCDEF);

      final CalendarActionDecoration decoration = CalendarActionDecoration(
        labelStyle: style,
        pressedColor: color,
      );

      expect(decoration.labelStyle, style);
      expect(decoration.pressedColor, color);
    });

    group('copyWith', () {
      test('returns identical fields when no params are provided', () {
        final CalendarActionDecoration original = CalendarActionDecoration();

        final CalendarActionDecoration copy = original.copyWith();

        expect(copy.labelStyle, original.labelStyle);
        expect(copy.pressedColor, original.pressedColor);
      });

      test('overrides only the supplied fields', () {
        final CalendarActionDecoration original = CalendarActionDecoration();
        const Color override = Color(0xFF010203);

        final CalendarActionDecoration copy =
            original.copyWith(pressedColor: override);

        expect(copy.pressedColor, override);
        expect(copy.labelStyle, original.labelStyle);
      });
    });

    group('withDynamicColor', () {
      testWidgets('resolves labelStyle color in light mode',
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

        final CalendarActionDecoration decoration =
            CalendarActionDecoration.withDynamicColor(ctx);

        expect(decoration.labelStyle?.color, isNotNull);
        expect(decoration.pressedColor, isNotNull);
      });

      testWidgets('uses provided pressedColor verbatim when supplied',
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

        const Color pressed = Color(0xFF112233);
        final CalendarActionDecoration decoration =
            CalendarActionDecoration.withDynamicColor(
          ctx,
          pressedColor: pressed,
        );

        expect(decoration.pressedColor, pressed);
      });

      testWidgets('produces different colors in dark mode',
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
        final CalendarActionDecoration light =
            CalendarActionDecoration.withDynamicColor(lightCtx);

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
        final CalendarActionDecoration dark =
            CalendarActionDecoration.withDynamicColor(darkCtx);

        expect(light.labelStyle?.color, isNot(dark.labelStyle?.color));
      });
    });
  });
}
