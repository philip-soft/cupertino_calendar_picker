// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerMediaQuery', () {
    testWidgets('clamps a large text scaler down to the max factor', (
      WidgetTester tester,
    ) async {
      TextScaler? capturedScaler;

      await tester.pumpWidget(
        wrapWithApp(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(3.0),
            ),
            child: CupertinoPickerMediaQuery(
              child: Builder(
                builder: (BuildContext context) {
                  capturedScaler = MediaQuery.textScalerOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      expect(capturedScaler, isNotNull);
      expect(
        capturedScaler?.scale(10.0),
        lessThanOrEqualTo(10.0 * calendarMaxTextScaleFactor + 0.0001),
      );
    });

    testWidgets('passes through smaller scale factors unchanged', (
      WidgetTester tester,
    ) async {
      TextScaler? capturedScaler;

      await tester.pumpWidget(
        wrapWithApp(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.noScaling,
            ),
            child: CupertinoPickerMediaQuery(
              child: Builder(
                builder: (BuildContext context) {
                  capturedScaler = MediaQuery.textScalerOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      expect(capturedScaler?.scale(10.0), 10.0);
    });

    testWidgets('renders the provided child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerMediaQuery(
            child: Text('hello-media-query'),
          ),
        ),
      );

      expect(find.text('hello-media-query'), findsOneWidget);
    });
  });
}
