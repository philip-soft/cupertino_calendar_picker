// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleExtension', () {
    group('scale', () {
      testWidgets('returns the same value when text scale factor is 1.0',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final double result = 20.0.scale(capturedContext);

        expect(result, 20.0);
      });

      testWidgets('multiplies the value by the text scale factor',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.5),
            ),
            child: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final double result = 10.0.scale(capturedContext);

        expect(result, 15.0);
      });

      testWidgets('returns zero when the value is zero regardless of scaler',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final double result = 0.0.scale(capturedContext);

        expect(result, 0.0);
      });

      testWidgets('scales negative values correctly',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final double result = (-5.0).scale(capturedContext);

        expect(result, -10.0);
      });
    });
  });
}
