// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CupertinoAnyDeviceScrollBehavior', () {
    test('includes every PointerDeviceKind value in dragDevices', () {
      const CupertinoAnyDeviceScrollBehavior behavior =
          CupertinoAnyDeviceScrollBehavior();

      final Set<PointerDeviceKind> devices = behavior.dragDevices;

      expect(devices, containsAll(PointerDeviceKind.values));
      expect(devices.length, PointerDeviceKind.values.length);
    });

    test('is a CupertinoScrollBehavior subclass', () {
      const CupertinoAnyDeviceScrollBehavior behavior =
          CupertinoAnyDeviceScrollBehavior();

      expect(behavior, isA<CupertinoScrollBehavior>());
    });
  });

  group('CupertinoFixedItemMouseScrolling', () {
    testWidgets('renders its child widget', (WidgetTester tester) async {
      const Key childKey = Key('child');
      final FixedExtentScrollController controller =
          FixedExtentScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoFixedItemMouseScrolling(
            scrollController: controller,
            child: const SizedBox(key: childKey, width: 10, height: 10),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('does nothing for non-scroll pointer events',
        (WidgetTester tester) async {
      final FixedExtentScrollController controller =
          FixedExtentScrollController(initialItem: 5);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        CupertinoApp(
          home: SizedBox(
            width: 200,
            height: 200,
            child: CupertinoFixedItemMouseScrolling(
              scrollController: controller,
              child: ListWheelScrollView(
                controller: controller,
                itemExtent: 32,
                children: List<Widget>.generate(
                  20,
                  (int i) => Text('$i'),
                ),
              ),
            ),
          ),
        ),
      );

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: const Offset(50, 50));
      addTearDown(gesture.removePointer);
      await tester.pump();

      expect(controller.selectedItem, 5);
    });

    testWidgets('accepts a null scroll controller without throwing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          home: CupertinoFixedItemMouseScrolling(
            scrollController: null,
            child: SizedBox(width: 10, height: 10),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'scroll-down mouse-wheel event advances selectedItem by one',
      (WidgetTester tester) async {
        final FixedExtentScrollController controller =
            FixedExtentScrollController(initialItem: 5);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          CupertinoApp(
            home: SizedBox(
              width: 200,
              height: 200,
              child: CupertinoFixedItemMouseScrolling(
                scrollController: controller,
                child: ListWheelScrollView(
                  controller: controller,
                  itemExtent: 32,
                  children: List<Widget>.generate(
                    20,
                    (int i) => Text('$i'),
                  ),
                ),
              ),
            ),
          ),
        );

        final TestPointer pointer = TestPointer(
          1,
          PointerDeviceKind.mouse,
        )..hover(const Offset(100, 100));
        await tester.sendEventToBinding(
          pointer.scroll(const Offset(0, 32)),
        );
        await tester.pumpAndSettle();

        expect(controller.selectedItem, greaterThanOrEqualTo(5));
      },
    );

    testWidgets(
      'scroll-up mouse-wheel event moves selectedItem back by one',
      (WidgetTester tester) async {
        final FixedExtentScrollController controller =
            FixedExtentScrollController(initialItem: 5);
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          CupertinoApp(
            home: SizedBox(
              width: 200,
              height: 200,
              child: CupertinoFixedItemMouseScrolling(
                scrollController: controller,
                child: ListWheelScrollView(
                  controller: controller,
                  itemExtent: 32,
                  children: List<Widget>.generate(
                    20,
                    (int i) => Text('$i'),
                  ),
                ),
              ),
            ),
          ),
        );

        final TestPointer pointer = TestPointer(
          2,
          PointerDeviceKind.mouse,
        )..hover(const Offset(100, 100));
        await tester.sendEventToBinding(
          pointer.scroll(const Offset(0, -32)),
        );
        await tester.pumpAndSettle();

        expect(controller.selectedItem, lessThanOrEqualTo(5));
      },
    );
  });
}
