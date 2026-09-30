// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

final DateTime _minimum = DateTime(2026);
final DateTime _maximum = DateTime(2026, 12, 31);
final DateTime _initial = DateTime(2026, 9, 10);

const List<CupertinoCalendarAction> _actions = <CupertinoCalendarAction>[
  CancelCupertinoCalendarAction(),
  ConfirmCupertinoCalendarAction(),
];

Widget _app(Widget child) {
  return wrapTestWidget(
    child,
    brightness: Brightness.light,
    textDirection: TextDirection.ltr,
    locale: const Locale('en', 'US'),
    layout: (Widget child) => Center(child: child),
  );
}

Finder _day(int day) {
  return find.byWidgetPredicate(
    (Widget widget) =>
        widget is CalendarMonthPickerDay &&
        widget.dayDate == DateTime(2026, 9, day),
  );
}

/// Opens the calendar overlay from an anchor and records the returned value.
class _PickerResult {
  bool isCompleted = false;
  DateTime? value;
}

Future<_PickerResult> _openCalendar(
  WidgetTester tester, {
  List<CupertinoCalendarAction>? actions,
  CalendarDismissBehavior dismissBehavior =
      CalendarDismissBehavior.onOutsideTap,
  ValueChanged<DateTime>? onDateSelected,
}) async {
  final _PickerResult result = _PickerResult();
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final DateTime? value = await showCupertinoCalendarPicker(
                context,
                widgetRenderBox: context.findRenderObject() as RenderBox?,
                minimumDateTime: _minimum,
                maximumDateTime: _maximum,
                initialDateTime: _initial,
                dismissBehavior: dismissBehavior,
                actions: actions,
                onDateSelected: onDateSelected,
              );
              result
                ..isCompleted = true
                ..value = value;
            },
            child: const SizedBox(width: 60.0, height: 30.0),
          );
        },
      ),
    ),
  );
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pumpAndSettle();
  return result;
}

void main() {
  group('showCupertinoCalendarPicker result', () {
    testWidgets('Cancel action resolves with null even after a change', (
      WidgetTester tester,
    ) async {
      // Arrange
      final _PickerResult result = await _openCalendar(
        tester,
        actions: _actions,
      );
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(result.isCompleted, isTrue);
      expect(result.value, isNull);
    });

    testWidgets(
      'Confirm action resolves with the initial date when unchanged',
      (WidgetTester tester) async {
        final _PickerResult result = await _openCalendar(
          tester,
          actions: _actions,
        );

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(result.isCompleted, isTrue);
        expect(result.value, _initial);
      },
    );

    testWidgets('Confirm action resolves with the changed date', (
      WidgetTester tester,
    ) async {
      final _PickerResult result = await _openCalendar(
        tester,
        actions: _actions,
      );
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result.value, DateTime(2026, 9, 15));
    });

    testWidgets(
      'outside tap resolves with null when a Confirm action is required',
      (WidgetTester tester) async {
        final _PickerResult result = await _openCalendar(
          tester,
          actions: _actions,
        );
        await tester.tap(_day(15));
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(5.0, 5.0));
        await tester.pumpAndSettle();

        expect(result.isCompleted, isTrue);
        expect(result.value, isNull);
      },
    );

    testWidgets('outside tap resolves with the changed date without actions', (
      WidgetTester tester,
    ) async {
      final _PickerResult result = await _openCalendar(tester);
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pumpAndSettle();

      expect(result.value, DateTime(2026, 9, 15));
    });

    testWidgets('date-select dismiss resolves with the selected date', (
      WidgetTester tester,
    ) async {
      final _PickerResult result = await _openCalendar(
        tester,
        dismissBehavior: CalendarDismissBehavior.onDateSelect,
      );

      await tester.tap(_day(20));
      await tester.pumpAndSettle();

      expect(result.isCompleted, isTrue);
      expect(result.value, DateTime(2026, 9, 20));
    });

    testWidgets('closing keeps a route pushed on top of the overlay', (
      WidgetTester tester,
    ) async {
      // Arrange
      final _PickerResult result = await _openCalendar(
        tester,
        dismissBehavior: CalendarDismissBehavior.onDateSelect,
        onDateSelected: (DateTime _) {
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .push(
                PageRouteBuilder<void>(
                  opaque: false,
                  pageBuilder: (_, _, _) => const Text('Pushed'),
                ),
              );
        },
      );

      // Act
      await tester.tap(_day(20));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pushed'), findsOneWidget);
      expect(find.byType(CupertinoCalendar), findsNothing);
      expect(result.isCompleted, isTrue);
      expect(result.value, DateTime(2026, 9, 20));
    });
  });

  group('CupertinoCalendar actions outside of an overlay', () {
    testWidgets('do not pop the hosting route', (WidgetTester tester) async {
      // Arrange
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      int confirmCount = 0;
      await tester.pumpWidget(
        _app(
          Navigator(
            key: navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              return PageRouteBuilder<void>(
                pageBuilder: (_, _, _) => const Text('first page'),
              );
            },
          ),
        ),
      );
      navigatorKey.currentState!.push(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => CupertinoCalendar(
            minimumDateTime: _minimum,
            maximumDateTime: _maximum,
            initialDateTime: _initial,
            type: CupertinoCalendarType.compact,
            actions: <CupertinoCalendarAction>[
              const CancelCupertinoCalendarAction(),
              ConfirmCupertinoCalendarAction(
                onPressed: (DateTime _) => confirmCount++,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert
      expect(confirmCount, 1);
      expect(find.byType(CupertinoCalendar), findsOneWidget);
      expect(find.text('first page'), findsNothing);
    });
  });

  group('CupertinoCalendarPickerButton', () {
    testWidgets('shows the confirmed date after Confirm is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          CupertinoCalendarPickerButton(
            minimumDateTime: _minimum,
            maximumDateTime: _maximum,
            initialDateTime: _initial,
            actions: _actions,
          ),
        ),
      );
      expect(find.text('Sep 10, 2026'), findsOneWidget);
      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pumpAndSettle();
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sep 15, 2026'), findsOneWidget);
    });

    testWidgets('keeps the previous date after Cancel is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _app(
          CupertinoCalendarPickerButton(
            minimumDateTime: _minimum,
            maximumDateTime: _maximum,
            initialDateTime: _initial,
            actions: _actions,
          ),
        ),
      );
      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pumpAndSettle();
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Sep 10, 2026'), findsOneWidget);
    });
  });

  group('Picker buttons removed while their overlay is open', () {
    testWidgets('CupertinoCalendarPickerButton ignores later changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      final ValueNotifier<bool> isButtonShown = ValueNotifier<bool>(true);
      addTearDown(isButtonShown.dispose);
      DateTime? changed;
      await tester.pumpWidget(
        _app(
          ValueListenableBuilder<bool>(
            valueListenable: isButtonShown,
            builder: (BuildContext _, bool isShown, Widget? _) => isShown
                ? CupertinoCalendarPickerButton(
                    minimumDateTime: _minimum,
                    maximumDateTime: _maximum,
                    initialDateTime: _initial,
                    onDateTimeChanged: (DateTime date) => changed = date,
                  )
                : const SizedBox(),
          ),
        ),
      );
      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pumpAndSettle();
      isButtonShown.value = false;
      await tester.pump();

      // Act
      await tester.tap(_day(15));
      await tester.pumpAndSettle();

      // Assert
      expect(tester.takeException(), isNull);
      expect(changed, DateTime(2026, 9, 15));
    });

    testWidgets('CupertinoTimePickerButton ignores later changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      final ValueNotifier<bool> isButtonShown = ValueNotifier<bool>(true);
      addTearDown(isButtonShown.dispose);
      TimeOfDay? changed;
      await tester.pumpWidget(
        _app(
          ValueListenableBuilder<bool>(
            valueListenable: isButtonShown,
            builder: (BuildContext _, bool isShown, Widget? _) => isShown
                ? CupertinoTimePickerButton(
                    initialTime: const TimeOfDay(hour: 10, minute: 0),
                    use24hFormat: true,
                    onTimeChanged: (TimeOfDay time) => changed = time,
                  )
                : const SizedBox(),
          ),
        ),
      );
      await tester.tap(find.byType(CupertinoTimePickerButton));
      await tester.pumpAndSettle();
      isButtonShown.value = false;
      await tester.pump();

      // Act
      await tester.fling(
        find.byType(ListWheelScrollView).first,
        const Offset(0.0, -100.0),
        600.0,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Assert
      expect(tester.takeException(), isNull);
      expect(changed, isNotNull);
    });
  });
}
