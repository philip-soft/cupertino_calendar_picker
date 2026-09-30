// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_durations.dart';
import 'test_helpers.dart';

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
            height: height,
            width: width,
            child: const Text('overlay-child'),
          ),
        ],
      ),
    ),
  );
  await tester.pump();
  await tester.pump(overlayOpenPumpDuration);
}

/// Pushes a route with a [CupertinoPickerOverlay] and records its result.
class _RouteResult {
  bool isCompleted = false;
  Object? value;
}

Future<_RouteResult> _pushOverlay(
  WidgetTester tester, {
  bool outsideTapDismissable = true,
  ValueGetter<Object?>? dismissResult,
  Widget child = const Text('overlay-child'),
}) async {
  final _RouteResult result = _RouteResult();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  await tester.pumpWidget(
    wrapWithApp(
      Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => const SizedBox.expand(),
        ),
      ),
    ),
  );
  unawaited(
    navigatorKey.currentState!
        .push(
          PageRouteBuilder<Object?>(
            opaque: false,
            pageBuilder: (_, _, _) => CupertinoPickerOverlay(
              height: 100.0,
              width: 100.0,
              outsideTapDismissable: outsideTapDismissable,
              dismissResult: dismissResult,
              child: child,
            ),
          ),
        )
        .then((Object? value) {
          result
            ..isCompleted = true
            ..value = value;
        }),
  );
  await tester.pumpAndSettle();
  return result;
}

void main() {
  group('CupertinoPickerOverlay placement', () {
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

      // Anchor occupies y=[50, 90]; with little room above and lots below the
      // overlay must be placed below the anchor's bottom edge (90) at
      // bottom + offset.dy = 90 + 10 = 100.
      final Positioned positioned = _contentPositioned(tester);
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

      // anchorTop - height - offset.dy = 520 - 200 - 10 = 310.
      final Positioned positioned = _contentPositioned(tester);
      expect(positioned.top, closeTo(anchorTop - height - 10.0, 0.01));
    });

    testWidgets('pins to the right edge when the anchor is near it', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pumpOverlayWithAnchor(
        tester,
        anchorOffset: const Offset(650.0, 200.0),
        anchorSize: const Size(80.0, 40.0),
        height: 100.0,
        width: 300.0,
      );

      // left = screenWidth - width - horizontalSpacing = 800 - 300 - 15.
      expect(_contentPositioned(tester).left, closeTo(485.0, 0.01));
      final CupertinoPickerContainer container = tester
          .widget<CupertinoPickerContainer>(
            find.byType(CupertinoPickerContainer),
          );
      expect(container.scaleAlignment.x, greaterThan(0.0));
    });

    testWidgets('pins to the left edge when the anchor is near it', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pumpOverlayWithAnchor(
        tester,
        anchorOffset: const Offset(0.0, 200.0),
        anchorSize: const Size(40.0, 40.0),
        height: 100.0,
        width: 300.0,
      );

      expect(_contentPositioned(tester).left, closeTo(15.0, 0.01));
      final CupertinoPickerContainer container = tester
          .widget<CupertinoPickerContainer>(
            find.byType(CupertinoPickerContainer),
          );
      expect(container.scaleAlignment.x, lessThan(0.0));
    });

    testWidgets('centers without an anchor', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        wrapWithApp(
          const CupertinoPickerOverlay(
            height: 100.0,
            width: 200.0,
            child: Text('overlay-child'),
          ),
        ),
      );
      await tester.pump(overlayOpenPumpDuration);

      expect(tester.takeException(), isNull);
      final Positioned positioned = _contentPositioned(tester);
      expect(positioned.left, closeTo(300.0, 0.01));
      expect(positioned.top, closeTo(250.0, 0.01));
    });

    testWidgets('uses the provided containerDecoration', (
      WidgetTester tester,
    ) async {
      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundType: PickerBackgroundType.plainColor,
      );

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoPickerOverlay(
            height: 100.0,
            width: 100.0,
            containerDecoration: decoration,
            child: const Text('overlay-child'),
          ),
        ),
      );

      final CupertinoPickerContainer container = tester
          .widget<CupertinoPickerContainer>(
            find.byType(CupertinoPickerContainer),
          );
      expect(container.decoration, decoration);
    });

    testWidgets('positions relative to a nested navigator', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800.0, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final GlobalKey anchorKey = GlobalKey();
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        wrapWithApp(
          Padding(
            padding: const EdgeInsets.only(left: 200.0, top: 100.0),
            child: Navigator(
              key: navigatorKey,
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (_, _, _) => Stack(
                  children: <Widget>[
                    Positioned(
                      left: 100.0,
                      top: 50.0,
                      width: 80.0,
                      height: 40.0,
                      child: SizedBox(key: anchorKey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final RenderBox anchor =
          anchorKey.currentContext!.findRenderObject()! as RenderBox;

      navigatorKey.currentState!.push(
        PageRouteBuilder<void>(
          opaque: false,
          pageBuilder: (_, _, _) => CupertinoPickerOverlay(
            widgetRenderBox: anchor,
            height: 100.0,
            width: 100.0,
            child: const Text('overlay-child'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The anchor is at (100, 50) inside the navigator, so the overlay opens
      // below it at 50 + 40 + 10 = 100 and centered at 140 - 50 = 90.
      final Positioned positioned = _contentPositioned(tester);
      expect(positioned.top, closeTo(100.0, 0.01));
      expect(positioned.left, closeTo(90.0, 0.01));
    });
  });

  group('CupertinoPickerOverlay dismissal', () {
    testWidgets('outside tap pops the route with the dismiss result', (
      WidgetTester tester,
    ) async {
      final _RouteResult result = await _pushOverlay(
        tester,
        dismissResult: () => 'dismissed',
      );

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pumpAndSettle();

      expect(result.isCompleted, isTrue);
      expect(result.value, 'dismissed');
      expect(find.text('overlay-child'), findsNothing);
    });

    testWidgets('does not dismiss on outside tap when not dismissable', (
      WidgetTester tester,
    ) async {
      final _RouteResult result = await _pushOverlay(
        tester,
        outsideTapDismissable: false,
      );

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pumpAndSettle();

      expect(result.isCompleted, isFalse);
      expect(find.text('overlay-child'), findsOneWidget);
    });

    testWidgets('the back gesture closes with the dismiss result', (
      WidgetTester tester,
    ) async {
      final _RouteResult result = await _pushOverlay(
        tester,
        outsideTapDismissable: false,
        dismissResult: () => 42,
      );

      final NavigatorState navigator = tester.state<NavigatorState>(
        find.byType(Navigator).last,
      );
      await navigator.maybePop();
      await tester.pumpAndSettle();

      expect(result.isCompleted, isTrue);
      expect(result.value, 42);
    });

    testWidgets('descendants close the overlay with a result via the scope', (
      WidgetTester tester,
    ) async {
      final _RouteResult result = await _pushOverlay(
        tester,
        dismissResult: () => 'dismissed',
        child: Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () =>
                CupertinoPickerOverlayScope.maybeOf(context)?.close('closed'),
            child: const Text('close'),
          ),
        ),
      );

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(result.value, 'closed');
    });

    testWidgets('closing twice completes the route once', (
      WidgetTester tester,
    ) async {
      final _RouteResult result = await _pushOverlay(
        tester,
        child: Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () {
              CupertinoPickerOverlayScope.maybeOf(context)
                ?..close('first')
                ..close('second');
            },
            child: const Text('close'),
          ),
        ),
      );

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(result.value, 'first');
    });

    testWidgets('PopScope cannot be popped directly', (
      WidgetTester tester,
    ) async {
      await _pushOverlay(tester);

      final PopScope<Object?> scope = tester.widget<PopScope<Object?>>(
        find.byWidgetPredicate((Widget widget) => widget is PopScope).last,
      );
      expect(scope.canPop, isFalse);
    });
  });
}
