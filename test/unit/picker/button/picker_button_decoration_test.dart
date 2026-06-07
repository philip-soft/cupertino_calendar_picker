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
  group('PickerButtonDecoration', () {
    test('uses defaults when no params are provided', () {
      final PickerButtonDecoration decoration = PickerButtonDecoration();

      expect(decoration.textStyle, pickerButtonTextStyle);
      expect(decoration.backgroundColor, pickerButtonBackgroundColor);
    });

    test('uses supplied textStyle when provided', () {
      const TextStyle style = TextStyle(fontSize: 22.0);

      final PickerButtonDecoration decoration =
          PickerButtonDecoration(textStyle: style);

      expect(decoration.textStyle, style);
    });

    test('uses supplied backgroundColor when provided', () {
      const Color color = Color(0xFF112233);

      final PickerButtonDecoration decoration =
          PickerButtonDecoration(backgroundColor: color);

      expect(decoration.backgroundColor, color);
    });

    group('copyWith', () {
      test('returns identical values when no params are provided', () {
        final PickerButtonDecoration original = PickerButtonDecoration();

        final PickerButtonDecoration copy = original.copyWith();

        expect(copy.textStyle, original.textStyle);
        expect(copy.backgroundColor, original.backgroundColor);
      });

      test('overrides textStyle only', () {
        final PickerButtonDecoration original = PickerButtonDecoration();
        const TextStyle style = TextStyle(fontSize: 10.0);

        final PickerButtonDecoration copy = original.copyWith(textStyle: style);

        expect(copy.textStyle, style);
        expect(copy.backgroundColor, original.backgroundColor);
      });

      test('overrides backgroundColor only', () {
        final PickerButtonDecoration original = PickerButtonDecoration();
        const Color color = Color(0xFFAABBCC);

        final PickerButtonDecoration copy =
            original.copyWith(backgroundColor: color);

        expect(copy.backgroundColor, color);
        expect(copy.textStyle, original.textStyle);
      });
    });

    group('withDynamicColor', () {
      testWidgets('resolves textStyle color and backgroundColor for light mode',
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

        final PickerButtonDecoration decoration =
            PickerButtonDecoration.withDynamicColor(ctx);

        expect(decoration.textStyle?.color, isNotNull);
        expect(decoration.backgroundColor, isNotNull);
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
        final PickerButtonDecoration lightDecoration =
            PickerButtonDecoration.withDynamicColor(lightCtx);

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
        final PickerButtonDecoration darkDecoration =
            PickerButtonDecoration.withDynamicColor(darkCtx);

        expect(
          lightDecoration.backgroundColor,
          isNot(darkDecoration.backgroundColor),
        );
      });

      testWidgets('uses supplied textStyle when provided',
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

        const TextStyle inputStyle = TextStyle(fontSize: 25.0);
        final PickerButtonDecoration decoration =
            PickerButtonDecoration.withDynamicColor(
          ctx,
          textStyle: inputStyle,
        );

        expect(decoration.textStyle?.fontSize, 25.0);
        expect(decoration.textStyle?.color, isNotNull);
      });
    });
  });
}
