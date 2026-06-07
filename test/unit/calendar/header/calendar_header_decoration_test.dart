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
  group('CalendarHeaderDecoration', () {
    test('defaults to calendarMonthDateStyle when no style is provided', () {
      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration();

      expect(decoration.monthDateStyle, calendarMonthDateStyle);
    });

    test('falls back to mainColor for unspecified arrow and button colors', () {
      const Color main = Color(0xFF123456);

      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration(
        mainColor: main,
      );

      expect(decoration.monthDateArrowColor, main);
      expect(decoration.forwardButtonColor, main);
      expect(decoration.backwardButtonColor, main);
    });

    test('uses calendar disabled fallback for disabled button colors', () {
      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration();

      expect(
        decoration.forwardDisabledButtonColor,
        calendarForwardDisabledButtonColor,
      );
      expect(
        decoration.backwardDisabledButtonColor,
        calendarForwardDisabledButtonColor,
      );
    });

    test('uses explicit overrides for individual colors', () {
      const Color forward = Color(0xFF111111);
      const Color backward = Color(0xFF222222);
      const Color forwardDisabled = Color(0xFF333333);
      const Color backwardDisabled = Color(0xFF444444);

      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration(
        forwardButtonColor: forward,
        backwardButtonColor: backward,
        forwardDisabledButtonColor: forwardDisabled,
        backwardDisabledButtonColor: backwardDisabled,
      );

      expect(decoration.forwardButtonColor, forward);
      expect(decoration.backwardButtonColor, backward);
      expect(decoration.forwardDisabledButtonColor, forwardDisabled);
      expect(decoration.backwardDisabledButtonColor, backwardDisabled);
    });

    group('copyWith', () {
      test('preserves all fields when no params are provided', () {
        final CalendarHeaderDecoration original = CalendarHeaderDecoration(
          mainColor: const Color(0xFF000000),
        );

        final CalendarHeaderDecoration copy = original.copyWith();

        expect(copy.monthDateStyle, original.monthDateStyle);
        expect(copy.monthDateArrowColor, original.monthDateArrowColor);
        expect(copy.forwardButtonColor, original.forwardButtonColor);
        expect(copy.backwardButtonColor, original.backwardButtonColor);
      });

      test('overrides only the supplied fields', () {
        final CalendarHeaderDecoration original = CalendarHeaderDecoration();
        const Color override = Color(0xFFFF00FF);

        final CalendarHeaderDecoration copy =
            original.copyWith(forwardButtonColor: override);

        expect(copy.forwardButtonColor, override);
        expect(copy.backwardButtonColor, original.backwardButtonColor);
      });
    });

    group('withDynamicColor', () {
      testWidgets('resolves dynamic colors in light mode',
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

        final CalendarHeaderDecoration decoration =
            CalendarHeaderDecoration.withDynamicColor(ctx);

        expect(decoration.monthDateStyle?.color, isNotNull);
        expect(decoration.forwardDisabledButtonColor, isNotNull);
        expect(decoration.backwardDisabledButtonColor, isNotNull);
      });

      testWidgets('uses mainColor when other colors are not provided',
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

        const Color main = Color(0xFFABCDEF);
        final CalendarHeaderDecoration decoration =
            CalendarHeaderDecoration.withDynamicColor(ctx, mainColor: main);

        expect(decoration.monthDateArrowColor, main);
        expect(decoration.forwardButtonColor, main);
        expect(decoration.backwardButtonColor, main);
      });
    });
  });
}
