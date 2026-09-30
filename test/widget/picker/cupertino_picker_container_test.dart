// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

Widget _buildContainer({
  Animation<double> animation = kAlwaysCompleteAnimation,
  PickerContainerDecoration? decoration,
  double maxScale = 1.0,
  Widget child = const SizedBox.expand(),
}) {
  return CupertinoPickerContainer(
    animation: animation,
    decoration: decoration ?? PickerContainerDecoration(),
    scaleAlignment: Alignment.center,
    maxScale: maxScale,
    height: 100.0,
    width: 200.0,
    child: child,
  );
}

void main() {
  group('CupertinoPickerContainer', () {
    testWidgets('renders its child', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithApp(_buildContainer(child: const Text('container-child'))),
      );

      expect(find.text('container-child'), findsOneWidget);
    });

    testWidgets('renders frosted-glass variant with BackdropFilter', (
      WidgetTester tester,
    ) async {
      final PickerContainerDecoration decoration = PickerContainerDecoration();

      await tester.pumpWidget(
        wrapWithApp(_buildContainer(decoration: decoration)),
      );

      expect(
        decoration.backgroundType,
        PickerBackgroundType.transparentAndBlurred,
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders solid-color variant without BackdropFilter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          _buildContainer(
            decoration: PickerContainerDecoration(
              backgroundType: PickerBackgroundType.plainColor,
              backgroundColor: const Color(0xFFFF0000),
            ),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('scales to maxScale when the animation completes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrapWithApp(_buildContainer(maxScale: 0.5)));

      final Transform transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(CupertinoPickerContainer),
          matching: find.byType(Transform),
        ),
      );
      expect(transform.transform.storage.first, closeTo(0.5, 0.001));
    });

    testWidgets('follows the provided animation', (WidgetTester tester) async {
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrapWithApp(_buildContainer(animation: controller)),
      );
      double scale() => tester
          .widget<Transform>(
            find.descendant(
              of: find.byType(CupertinoPickerContainer),
              matching: find.byType(Transform),
            ),
          )
          .transform
          .storage
          .first;

      expect(scale(), 0.0);

      controller.value = 1.0;
      await tester.pump();

      expect(scale(), closeTo(1.0, 0.001));
    });

    testWidgets('resolves a dynamic background color for dark mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          _buildContainer(
            decoration: PickerContainerDecoration(
              backgroundType: PickerBackgroundType.plainColor,
              backgroundColor: CupertinoColors.systemBackground,
            ),
          ),
          brightness: Brightness.dark,
        ),
      );

      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(CupertinoPickerContainer),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final BoxDecoration decoration = box.decoration as BoxDecoration;
      expect(
        decoration.color?.toARGB32(),
        CupertinoColors.systemBackground.darkColor.toARGB32(),
      );
    });
  });
}
