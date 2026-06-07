// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerVerticalDivider', () {
    testWidgets('renders a VerticalDivider with thin metrics', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                Expanded(child: SizedBox()),
                CupertinoPickerVerticalDivider(),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      );

      final VerticalDivider divider = tester.widget<VerticalDivider>(
        find.byType(VerticalDivider),
      );
      expect(divider.width, 0.33);
      expect(divider.thickness, 0.33);
    });

    testWidgets('color resolves from the current Cupertino theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                Expanded(child: SizedBox()),
                CupertinoPickerVerticalDivider(),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      );

      final VerticalDivider divider = tester.widget<VerticalDivider>(
        find.byType(VerticalDivider),
      );
      expect(divider.color, isNotNull);
    });
  });
}
