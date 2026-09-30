// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../footer/test_helpers.dart';

Future<void> _pumpTarget(WidgetTester tester, VoidCallback? onTap) {
  return tester.pumpWidget(
    wrapWithApp(
      Center(
        child: CupertinoPickerTapTarget(
          onTap: onTap,
          child: const Text('target'),
        ),
      ),
    ),
  );
}

Future<void> _focusTarget(WidgetTester tester) async {
  Focus.of(tester.element(find.text('target'))).requestFocus();
  await tester.pump();
}

void main() {
  group('CupertinoPickerTapTarget', () {
    for (final LogicalKeyboardKey key in <LogicalKeyboardKey>[
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.space,
    ]) {
      testWidgets('is activated with ${key.keyLabel} when focused', (
        WidgetTester tester,
      ) async {
        int taps = 0;
        await _pumpTarget(tester, () => taps++);
        await _focusTarget(tester);

        await tester.sendKeyEvent(key);

        expect(taps, 1);
      });
    }

    testWidgets('cannot be focused when disabled', (WidgetTester tester) async {
      await _pumpTarget(tester, null);
      await _focusTarget(tester);

      expect(Focus.of(tester.element(find.text('target'))).hasFocus, isFalse);
    });
  });
}
