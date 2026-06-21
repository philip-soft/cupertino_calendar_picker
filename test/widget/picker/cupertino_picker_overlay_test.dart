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

/// Returns the [Positioned] that lays out the overlay content (the one
/// wrapping the [CupertinoPickerContainer]), so tests can assert the
/// computed placement rather than merely that it renders.
Positioned _contentPositioned(WidgetTester tester) {
  return tester.widget<Positioned>(
    find
        .ancestor(
          of: find.byType(CupertinoPickerContainer),
          matching: find.byType(Positioned),
        )
        .first,
  );
}

/// Mounts the anchor and the overlay in the *same* tree so the overlay reads an
/// attached [RenderBox] and computes a real position (as it does in production).
/// Pumping the anchor alone first, then replacing the tree, would detach the
/// box and collapse the geometry to the origin.
Future<void> _pumpOverlayWithAnchor(
  WidgetTester tester, {
  required Offset anchorOffset,
  required Size anchorSize,
  required double height,
  required double width,
}) async {
  final GlobalKey anchorKey = GlobalKey();

  Positioned buildAnchor() => Positioned(
        left: anchorOffset.dx,
        top: anchorOffset.dy,
        width: anchorSize.width,
        height: anchorSize.height,
        child: SizedBox(key: anchorKey),
      );

  await tester.pumpWidget(
    wrapWithApp(Stack(children: <Widget>[buildAnchor()])),
  );
  await tester.pump();

  final RenderBox anchor =
      anchorKey.currentContext!.findRenderObject()! as RenderBox;

  await tester.pumpWidget(
    wrapWithApp(
      Stack(
        children: <Widget>[
          buildAnchor(),
          CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            outsideTapDismissable: true,
            height: height,
            width: width,
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
}

void main() {
  group('CupertinoPickerOverlay', () {
    testWidgets('positions overlay below anchor when more space exists below', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pumpOverlayWithAnchor(
        tester,
        anchorOffset: const Offset(100.0, 50.0),
        anchorSize: const Size(80.0, 40.0),
        height: 200.0,
        width: 200.0,
      );

      expect(find.text('overlay-child'), findsOneWidget);
      expect(find.byType(CupertinoPickerContainer), findsOneWidget);

      // Anchor occupies y=[50, 90]; with little room above and lots below the
      // overlay must be placed below the anchor's bottom edge (90) at
      // bottom + offset.dy = 90 + 10 = 100.
      final Positioned positioned = _contentPositioned(tester);
      const double anchorBottom = 50.0 + 40.0;
      expect(positioned.top, isNotNull);
      expect(positioned.top, greaterThanOrEqualTo(anchorBottom));
      expect(positioned.top, closeTo(100.0, 0.01));
    });

    testWidgets('positions overlay above anchor when more space exists above', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      const double height = 200.0;
      const double anchorTop = 600.0 - 80.0;
      await _pumpOverlayWithAnchor(
        tester,
        anchorOffset: const Offset(100.0, anchorTop),
        anchorSize: const Size(80.0, 40.0),
        height: height,
        width: 200.0,
      );

      expect(find.text('overlay-child'), findsOneWidget);

      // The anchor sits near the bottom, so the overlay must open above it:
      // its bottom edge (top + height) cannot extend past the anchor's top,
      // landing at anchorTop - height - offset.dy = 520 - 200 - 10 = 310.
      final Positioned positioned = _contentPositioned(tester);
      expect(positioned.top, isNotNull);
      expect(positioned.top! + height, lessThanOrEqualTo(anchorTop));
      expect(positioned.top, closeTo(anchorTop - height - 10.0, 0.01));
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
      'positions overlay left-aligned when anchor is near the right edge',
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

        // Anchor (centre x=690) leaves too little room on the right for a
        // 300-wide overlay, so it is pinned against the right edge:
        // left = screenWidth - width - horizontalSpacing = 800 - 300 - 15.
        final Positioned positioned = _contentPositioned(tester);
        expect(positioned.left, closeTo(485.0, 0.01));
        // Scale origin leans toward the right (positive x) since space is
        // missing on that side.
        final CupertinoPickerContainer container =
            tester.widget<CupertinoPickerContainer>(
          find.byType(CupertinoPickerContainer),
        );
        expect(container.scaleAlignment.x, greaterThan(0.0));
      },
    );

    testWidgets(
      'xAlignment shifts toward right when anchor is near left edge',
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

        // Anchor hugs the left edge, so the overlay is pinned to the left with
        // just the horizontal spacing: left = horizontalSpacing = 15.
        final Positioned positioned = _contentPositioned(tester);
        expect(positioned.left, closeTo(15.0, 0.01));
        // Scale origin leans toward the left (negative x) since space is
        // missing on that side.
        final CupertinoPickerContainer container =
            tester.widget<CupertinoPickerContainer>(
          find.byType(CupertinoPickerContainer),
        );
        expect(container.scaleAlignment.x, lessThan(0.0));
      },
    );
  });
}
