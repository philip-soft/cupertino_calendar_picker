// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerButton', () {
    testWidgets('renders the title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Tap me',
            showPickerFunction: (RenderBox? _) async => 0,
            onPressed: null,
          ),
        ),
      );

      expect(find.text('Tap me'), findsOneWidget);
    });

    testWidgets('invokes onPressed and showPickerFunction when tapped', (
      WidgetTester tester,
    ) async {
      int pressedCount = 0;
      int showCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Open',
            onPressed: () => pressedCount++,
            showPickerFunction: (RenderBox? _) async {
              showCount++;
              return 42;
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(pressedCount, 1);
      expect(showCount, 1);
    });

    testWidgets('invokes onSelected with the picker result', (
      WidgetTester tester,
    ) async {
      int? selected;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Open',
            onPressed: null,
            onSelected: (int? value) => selected = value,
            showPickerFunction: (RenderBox? _) async => 7,
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(selected, 7);
    });

    testWidgets('uses the provided decoration text style', (
      WidgetTester tester,
    ) async {
      final PickerButtonDecoration decoration = PickerButtonDecoration(
        textStyle:
            const TextStyle(fontSize: 22.0, color: CupertinoColors.activeBlue),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Styled',
            decoration: decoration,
            onPressed: null,
            showPickerFunction: (RenderBox? _) async => 0,
          ),
        ),
      );

      final AnimatedDefaultTextStyle textStyle =
          tester.widget<AnimatedDefaultTextStyle>(
        find.byType(AnimatedDefaultTextStyle),
      );
      expect(textStyle.style.fontSize, 22.0);
    });

    testWidgets(
      'cancelling a tap-down still animates back via _handleTapCancel',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            CupertinoPickerButton<int?>(
              title: 'Cancel me',
              onPressed: null,
              showPickerFunction: (RenderBox? _) async => 0,
            ),
          ),
        );

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(find.text('Cancel me')),
        );
        await tester.pump();
        await gesture.moveBy(const Offset(0, 500));
        await tester.pump();
        await gesture.cancel();
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(FadeTransition), findsWidgets);
      },
    );

    testWidgets('animates opacity on tap-down', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Hold',
            onPressed: null,
            showPickerFunction: (RenderBox? _) async => 0,
          ),
        ),
      );

      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.text('Hold')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(FadeTransition), findsWidgets);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets(
      'completes fade-out animation cycle including .then callback (line 116)',
      (WidgetTester tester) async {
        final Completer<int?> completer = Completer<int?>();

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoPickerButton<int?>(
              title: 'Anim',
              onPressed: null,
              showPickerFunction: (RenderBox? _) => completer.future,
            ),
          ),
        );

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(find.text('Anim')),
        );
        await tester.pump(const Duration(milliseconds: 10));
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 1200));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(FadeTransition), findsWidgets);

        completer.complete(null);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'applies mainColor to text while picker is open (isCalendarOpened == true)',
      (WidgetTester tester) async {
        final Completer<int?> completer = Completer<int?>();

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoPickerButton<int?>(
              title: 'Open',
              mainColor: CupertinoColors.activeBlue,
              onPressed: null,
              showPickerFunction: (RenderBox? _) => completer.future,
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        final AnimatedDefaultTextStyle textWidget =
            tester.widget<AnimatedDefaultTextStyle>(
          find.byType(AnimatedDefaultTextStyle),
        );
        expect(
          textWidget.style.color,
          CupertinoColors.activeBlue,
        );

        completer.complete(null);
        await tester.pumpAndSettle();
      },
    );
  });
}
