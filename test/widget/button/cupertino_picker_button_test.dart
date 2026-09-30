// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

double _titleOpacity(WidgetTester tester) {
  return tester
      .widget<FadeTransition>(
        find.descendant(
          of: find.byType(CupertinoPickerTapTarget),
          matching: find.byType(FadeTransition),
        ),
      )
      .opacity
      .value;
}

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

    testWidgets('hugs its title when centered', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Tap me',
            showPickerFunction: (RenderBox? _) async => 0,
            onPressed: null,
          ),
        ),
      );

      // Assert
      final double buttonWidth = tester
          .getSize(find.byType(CupertinoPickerButton<int?>))
          .width;
      final double titleWidth = tester.getSize(find.text('Tap me')).width;
      expect(
        buttonWidth,
        closeTo(titleWidth + pickerButtonHorizontalPadding * 2, 0.01),
      );
    });

    testWidgets('fills a width forced by its parent', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            width: 300.0,
            child: CupertinoPickerButton<int?>(
              title: 'Tap me',
              showPickerFunction: (RenderBox? _) async => 0,
              onPressed: null,
            ),
          ),
        ),
      );

      // Assert
      final Finder button = find.byType(CupertinoPickerButton<int?>);
      expect(tester.getSize(button).width, 300.0);
      expect(
        tester.getCenter(find.text('Tap me')).dx,
        closeTo(tester.getCenter(button).dx, 0.01),
      );
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

    testWidgets('ignores taps while the picker is open', (
      WidgetTester tester,
    ) async {
      final Completer<int?> completer = Completer<int?>();
      int showCount = 0;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerButton<int?>(
            title: 'Open',
            onPressed: null,
            showPickerFunction: (RenderBox? _) {
              showCount++;
              return completer.future;
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(showCount, 1);

      completer.complete(7);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(showCount, 2);
    });

    testWidgets('uses the provided decoration text style', (
      WidgetTester tester,
    ) async {
      final PickerButtonDecoration decoration = PickerButtonDecoration(
        textStyle: const TextStyle(
          fontSize: 22.0,
          color: CupertinoColors.activeBlue,
        ),
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

      final AnimatedDefaultTextStyle textStyle = tester
          .widget<AnimatedDefaultTextStyle>(
            find.byType(AnimatedDefaultTextStyle),
          );
      expect(textStyle.style.fontSize, 22.0);
    });

    testWidgets('cancelling a tap-down restores the title opacity', (
      WidgetTester tester,
    ) async {
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

      expect(_titleOpacity(tester), 1.0);
    });

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

      expect(_titleOpacity(tester), lessThan(1.0));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets(
      'restores the title opacity after release while the picker opens',
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

        expect(_titleOpacity(tester), 1.0);

        completer.complete(null);
        await tester.pumpAndSettle();
      },
    );

    testWidgets('applies mainColor to the title while the picker is open', (
      WidgetTester tester,
    ) async {
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

      final AnimatedDefaultTextStyle textWidget = tester
          .widget<AnimatedDefaultTextStyle>(
            find.byType(AnimatedDefaultTextStyle),
          );
      expect(textWidget.style.color, CupertinoColors.activeBlue);

      completer.complete(null);
      await tester.pumpAndSettle();
    });
  });
}
