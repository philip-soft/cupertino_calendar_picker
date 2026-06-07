// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerDivider', () {
    testWidgets('renders a Divider with default horizontalIndent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerDivider(),
        ),
      );

      final Divider divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, 16.0);
      expect(divider.endIndent, 16.0);
      expect(divider.height, 0.33);
      expect(divider.thickness, 0.33);
    });

    testWidgets('applies custom horizontalIndent to indent and endIndent', (
      WidgetTester tester,
    ) async {
      const double customIndent = 42.0;

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerDivider(horizontalIndent: customIndent),
        ),
      );

      final Divider divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, customIndent);
      expect(divider.endIndent, customIndent);
    });

    testWidgets('allows zero indent', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerDivider(horizontalIndent: 0.0),
        ),
      );

      final Divider divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.indent, 0.0);
      expect(divider.endIndent, 0.0);
    });
  });
}
