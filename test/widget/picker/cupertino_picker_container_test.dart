// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoPickerContainer', () {
    testWidgets('invokes onInitialized with an AnimationController', (
      WidgetTester tester,
    ) async {
      AnimationController? captured;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerContainer(
            decoration: PickerContainerDecoration(),
            scaleAlignment: Alignment.center,
            onInitialized: (AnimationController c) => captured = c,
            maxScale: 1.0,
            height: 100.0,
            width: 200.0,
            child: const Text('container-child'),
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(find.text('container-child'), findsOneWidget);
    });

    testWidgets('renders frosted-glass variant with BackdropFilter', (
      WidgetTester tester,
    ) async {
      final PickerContainerDecoration decoration = PickerContainerDecoration();

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerContainer(
            decoration: decoration,
            scaleAlignment: Alignment.topCenter,
            onInitialized: (_) {},
            maxScale: 1.0,
            height: 200.0,
            width: 320.0,
            child: const SizedBox.expand(),
          ),
        ),
      );

      expect(
          decoration.backgroundType, PickerBackgroundType.transparentAndBlured);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders solid-color variant without BackdropFilter', (
      WidgetTester tester,
    ) async {
      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundType: PickerBackgroundType.plainColor,
        backgroundColor: const Color(0xFFFF0000),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerContainer(
            decoration: decoration,
            scaleAlignment: Alignment.center,
            onInitialized: (_) {},
            maxScale: 1.0,
            height: 100.0,
            width: 100.0,
            child: const SizedBox.expand(),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('animates scale via Transform.scale once controller runs', (
      WidgetTester tester,
    ) async {
      AnimationController? controller;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerContainer(
            decoration: PickerContainerDecoration(),
            scaleAlignment: Alignment.center,
            onInitialized: (AnimationController c) => controller = c,
            maxScale: 1.0,
            height: 100.0,
            width: 100.0,
            child: const SizedBox.expand(),
          ),
        ),
      );

      unawaited(controller?.forward());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('updates scale animation when maxScale changes', (
      WidgetTester tester,
    ) async {
      Widget build(double maxScale) {
        return wrapWithApp(
          CupertinoPickerContainer(
            decoration: PickerContainerDecoration(),
            scaleAlignment: Alignment.center,
            onInitialized: (_) {},
            maxScale: maxScale,
            height: 100.0,
            width: 100.0,
            child: const SizedBox.expand(),
          ),
        );
      }

      await tester.pumpWidget(build(1.0));

      await tester.pumpWidget(build(0.5));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(CupertinoPickerContainer), findsOneWidget);
    });

    testWidgets('disposes the AnimationController when removed from tree', (
      WidgetTester tester,
    ) async {
      AnimationController? controller;
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerContainer(
            decoration: PickerContainerDecoration(),
            scaleAlignment: Alignment.center,
            onInitialized: (AnimationController c) => controller = c,
            maxScale: 1.0,
            height: 100.0,
            width: 100.0,
            child: const SizedBox.expand(),
          ),
        ),
      );

      await tester.pumpWidget(wrapWithApp(const SizedBox.shrink()));

      expect(
        () => controller?.forward(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
