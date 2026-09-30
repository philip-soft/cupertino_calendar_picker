// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Pumps a minimal tree under [textScaler] and returns its [BuildContext].
Future<BuildContext> _pumpScaledContext(
  WidgetTester tester, {
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Builder(
        builder: (BuildContext context) {
          capturedContext = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return capturedContext;
}

void main() {
  group('DoubleExtension', () {
    group('scale', () {
      testWidgets('returns the same value when text scale factor is 1.0', (
        WidgetTester tester,
      ) async {
        final BuildContext context = await _pumpScaledContext(tester);

        expect(20.0.scale(context), 20.0);
      });

      testWidgets('multiplies the value by the text scale factor', (
        WidgetTester tester,
      ) async {
        final BuildContext context = await _pumpScaledContext(
          tester,
          textScaler: const TextScaler.linear(1.5),
        );

        expect(10.0.scale(context), 15.0);
      });

      testWidgets('returns zero when the value is zero regardless of scaler', (
        WidgetTester tester,
      ) async {
        final BuildContext context = await _pumpScaledContext(
          tester,
          textScaler: const TextScaler.linear(2.0),
        );

        expect(0.0.scale(context), 0.0);
      });

      testWidgets('scales negative values correctly', (
        WidgetTester tester,
      ) async {
        final BuildContext context = await _pumpScaledContext(
          tester,
          textScaler: const TextScaler.linear(2.0),
        );

        expect((-5.0).scale(context), -10.0);
      });

      testWidgets('scales down when the text scale factor is below 1.0', (
        WidgetTester tester,
      ) async {
        final BuildContext context = await _pumpScaledContext(
          tester,
          textScaler: const TextScaler.linear(0.5),
        );

        expect(24.0.scale(context), 12.0);
      });
    });
  });
}
