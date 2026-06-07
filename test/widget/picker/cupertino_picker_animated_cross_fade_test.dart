// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerAnimatedCrossFade', () {
    testWidgets('renders firstChild visible when crossFadeState is showFirst', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerAnimatedCrossFade(
            firstChild: Text('first-child'),
            secondChild: Text('second-child'),
            crossFadeState: CrossFadeState.showFirst,
          ),
        ),
      );

      expect(find.text('first-child'), findsOneWidget);
      expect(find.text('second-child'), findsOneWidget);
    });

    testWidgets('renders secondChild visible when crossFadeState is showSecond',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerAnimatedCrossFade(
            firstChild: Text('first-child'),
            secondChild: Text('second-child'),
            crossFadeState: CrossFadeState.showSecond,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('first-child'), findsOneWidget);
      expect(find.text('second-child'), findsOneWidget);
    });

    testWidgets('renders empty SizedBox when secondChild is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerAnimatedCrossFade(
            firstChild: Text('only-first'),
            crossFadeState: CrossFadeState.showFirst,
          ),
        ),
      );

      expect(find.text('only-first'), findsOneWidget);
    });

    testWidgets('cross-fades when crossFadeState changes between rebuilds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerAnimatedCrossFade(
            firstChild: Text('first-child'),
            secondChild: Text('second-child'),
            crossFadeState: CrossFadeState.showFirst,
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerAnimatedCrossFade(
            firstChild: Text('first-child'),
            secondChild: Text('second-child'),
            crossFadeState: CrossFadeState.showSecond,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('first-child'), findsOneWidget);
      expect(find.text('second-child'), findsOneWidget);
    });
  });
}
