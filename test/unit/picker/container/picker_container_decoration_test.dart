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
  group('PickerContainerDecoration', () {
    test('default factory populates borderRadius, backgroundType and shadow',
        () {
      final PickerContainerDecoration decoration = PickerContainerDecoration();

      expect(decoration.borderRadius, BorderRadius.circular(13.0));
      expect(
        decoration.backgroundType,
        PickerBackgroundType.transparentAndBlured,
      );
      expect(decoration.boxShadow, isNotEmpty);
    });

    test('clamps alpha for transparentAndBlured when above threshold', () {
      const Color opaque = Color(0xFFFFFFFF);

      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundColor: opaque,
      );

      expect(
        (decoration.backgroundColor.a * 255.0).round().clamp(0, 255),
        calendarBluredLightBackgroundColorAlpha,
      );
    });

    test('keeps backgroundColor untouched when alpha is below threshold', () {
      const Color faint = Color.fromARGB(100, 255, 255, 255);

      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundColor: faint,
      );

      expect(decoration.backgroundColor, faint);
    });

    test('does not clamp alpha for plainColor backgroundType', () {
      const Color opaque = Color(0xFFFFFFFF);

      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundColor: opaque,
        backgroundType: PickerBackgroundType.plainColor,
      );

      expect(decoration.backgroundColor, opaque);
    });

    test('uses supplied borderRadius and boxShadow when provided', () {
      final BorderRadius radius = BorderRadius.circular(8.0);
      const List<BoxShadow> shadow = <BoxShadow>[
        BoxShadow(blurRadius: 1.0),
      ];

      final PickerContainerDecoration decoration = PickerContainerDecoration(
        borderRadius: radius,
        boxShadow: shadow,
      );

      expect(decoration.borderRadius, radius);
      expect(decoration.boxShadow, shadow);
    });

    group('copyWith', () {
      test('returns identical values when no params are provided', () {
        final PickerContainerDecoration original = PickerContainerDecoration();

        final PickerContainerDecoration copy = original.copyWith();

        expect(copy.borderRadius, original.borderRadius);
        expect(copy.backgroundColor, original.backgroundColor);
        expect(copy.backgroundType, original.backgroundType);
        expect(copy.boxShadow, original.boxShadow);
      });

      test('overrides only the supplied fields', () {
        final PickerContainerDecoration original = PickerContainerDecoration();
        final BorderRadius newRadius = BorderRadius.circular(4.0);

        final PickerContainerDecoration copy =
            original.copyWith(borderRadius: newRadius);

        expect(copy.borderRadius, newRadius);
        expect(copy.backgroundColor, original.backgroundColor);
      });
    });

    group('withDynamicColor', () {
      testWidgets('produces a non-null backgroundColor in light mode',
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

        final PickerContainerDecoration decoration =
            PickerContainerDecoration.withDynamicColor(ctx);

        expect(decoration.backgroundColor, isNotNull);
      });

      testWidgets(
          'resolves a different backgroundColor in dark mode versus light',
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
        final PickerContainerDecoration lightDecoration =
            PickerContainerDecoration.withDynamicColor(lightCtx);

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
        final PickerContainerDecoration darkDecoration =
            PickerContainerDecoration.withDynamicColor(darkCtx);

        expect(
          lightDecoration.backgroundColor,
          isNot(darkDecoration.backgroundColor),
        );
      });

      testWidgets('keeps plainColor backgroundType when requested',
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

        final PickerContainerDecoration decoration =
            PickerContainerDecoration.withDynamicColor(
          ctx,
          backgroundType: PickerBackgroundType.plainColor,
        );

        expect(
          decoration.backgroundType,
          PickerBackgroundType.plainColor,
        );
      });
    });
  });
}
