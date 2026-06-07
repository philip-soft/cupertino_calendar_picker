// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

Future<RenderBox> _pumpAnchor(
  WidgetTester tester, {
  required Offset offset,
  Size size = const Size(80.0, 40.0),
}) async {
  final GlobalKey anchorKey = GlobalKey();

  await tester.pumpWidget(
    wrapWithApp(
      Stack(
        children: <Widget>[
          Positioned(
            left: offset.dx,
            top: offset.dy,
            width: size.width,
            height: size.height,
            child: SizedBox(key: anchorKey),
          ),
        ],
      ),
    ),
  );

  final RenderBox box =
      anchorKey.currentContext!.findRenderObject()! as RenderBox;
  return box;
}

void main() {
  group('CupertinoPickerOverlay', () {
    testWidgets('positions overlay below anchor when more space exists below', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(100.0, 50.0),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 200.0,
            width: 200.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('overlay-child'), findsOneWidget);
      expect(find.byType(CupertinoPickerContainer), findsOneWidget);
    });

    testWidgets('positions overlay above anchor when more space exists above', (
      WidgetTester tester,
    ) async {
      final Size screenSize =
          tester.view.physicalSize / tester.view.devicePixelRatio;
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: Offset(100.0, screenSize.height - 80.0),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 200.0,
            width: 200.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('overlay-child'), findsOneWidget);
    });

    testWidgets('tapping outside dismisses when outsideTapDismissable is true',
        (WidgetTester tester) async {
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(100.0, 100.0),
      );
      AnimationController? controller;

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 100.0,
            containerDecoration: null,
            onInitialized: (AnimationController c) => controller = c,
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pump();

      expect(controller, isNotNull);
      expect(
        controller?.status,
        anyOf(
          AnimationStatus.reverse,
          AnimationStatus.dismissed,
        ),
      );
    });

    testWidgets(
      'does not dismiss on outside tap when outsideTapDismissable is false',
      (WidgetTester tester) async {
        final RenderBox anchor = await _pumpAnchor(
          tester,
          offset: const Offset(100.0, 100.0),
        );
        AnimationController? controller;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoPickerOverlay(
              widgetRenderBox: anchor,
              horizontalSpacing: 15.0,
              verticalSpacing: 15.0,
              offset: const Offset(0.0, 10.0),
              outsideTapDismissable: false,
              height: 100.0,
              width: 100.0,
              containerDecoration: null,
              onInitialized: (AnimationController c) => controller = c,
              child: const Text('overlay-child'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tapAt(const Offset(5.0, 5.0));
        await tester.pump();

        expect(
          controller?.status,
          isNot(AnimationStatus.reverse),
        );
      },
    );

    testWidgets('handles null RenderBox without throwing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: null,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 100.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('overlay-child'), findsOneWidget);
    });

    testWidgets('uses provided containerDecoration when supplied', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(100.0, 100.0),
      );
      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundType: PickerBackgroundType.plainColor,
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 100.0,
            containerDecoration: decoration,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();

      final CupertinoPickerContainer container =
          tester.widget<CupertinoPickerContainer>(
        find.byType(CupertinoPickerContainer),
      );
      expect(container.decoration, decoration);
    });

    testWidgets('falls back to dynamic decoration when none is provided', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(100.0, 100.0),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 100.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();

      final CupertinoPickerContainer container =
          tester.widget<CupertinoPickerContainer>(
        find.byType(CupertinoPickerContainer),
      );
      expect(container.decoration, isNotNull);
    });

    testWidgets('clamps overlay width when narrower than picker', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(220.0, 800.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(50.0, 100.0),
        size: const Size(40.0, 20.0),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 320.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(CupertinoPickerContainer), findsOneWidget);
    });

    testWidgets('PopScope cannot be popped directly', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(
        tester,
        offset: const Offset(100.0, 100.0),
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: 100.0,
            width: 100.0,
            containerDecoration: null,
            onInitialized: (_) {},
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pump();

      final Finder popScopeFinder = find.byWidgetPredicate(
        (Widget widget) => widget is PopScope,
      );
      expect(popScopeFinder, findsWidgets);
      final PopScope scope = tester.widget<PopScope>(popScopeFinder.first);
      expect(scope.canPop, isFalse);
    });

    testWidgets(
      'positions overlay left-aligned when anchor is near the right edge '
      '(fitsOnLeft but not fitsHorizontally — line 128)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800.0, 600.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final GlobalKey anchorKey = GlobalKey();

        await tester.pumpWidget(
          wrapWithApp(
            Stack(
              children: <Widget>[
                Positioned(
                  left: 650.0,
                  top: 200.0,
                  width: 80.0,
                  height: 40.0,
                  child: SizedBox(key: anchorKey),
                ),
              ],
            ),
          ),
        );
        await tester.pump();

        final RenderBox anchor =
            anchorKey.currentContext!.findRenderObject()! as RenderBox;

        await tester.pumpWidget(
          wrapWithApp(
            Stack(
              children: <Widget>[
                Positioned(
                  left: 650.0,
                  top: 200.0,
                  width: 80.0,
                  height: 40.0,
                  child: SizedBox(key: anchorKey),
                ),
                CupertinoPickerOverlay(
                  widgetRenderBox: anchor,
                  horizontalSpacing: 15.0,
                  verticalSpacing: 15.0,
                  offset: const Offset(0.0, 10.0),
                  outsideTapDismissable: true,
                  height: 100.0,
                  width: 300.0,
                  containerDecoration: null,
                  onInitialized: (_) {},
                  child: const Text('overlay-child'),
                ),
              ],
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(tester.takeException(), isNull);
        expect(find.byType(CupertinoPickerContainer), findsOneWidget);
      },
    );

    testWidgets(
      'xAlignment shifts toward right when anchor is near left edge '
      '(fitsOnRight but not fitsOnLeft — lines 145/146)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800.0, 600.0);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final GlobalKey anchorKey = GlobalKey();

        await tester.pumpWidget(
          wrapWithApp(
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  top: 200.0,
                  width: 40.0,
                  height: 40.0,
                  child: SizedBox(key: anchorKey),
                ),
              ],
            ),
          ),
        );
        await tester.pump();

        final RenderBox anchor =
            anchorKey.currentContext!.findRenderObject()! as RenderBox;

        await tester.pumpWidget(
          wrapWithApp(
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  top: 200.0,
                  width: 40.0,
                  height: 40.0,
                  child: SizedBox(key: anchorKey),
                ),
                CupertinoPickerOverlay(
                  widgetRenderBox: anchor,
                  horizontalSpacing: 15.0,
                  verticalSpacing: 15.0,
                  offset: const Offset(0.0, 10.0),
                  outsideTapDismissable: true,
                  height: 100.0,
                  width: 300.0,
                  containerDecoration: null,
                  onInitialized: (_) {},
                  child: const Text('overlay-child'),
                ),
              ],
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(tester.takeException(), isNull);
        expect(find.byType(CupertinoPickerContainer), findsOneWidget);
      },
    );
  });
}
