// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

Future<RenderBox> _pumpAnchor(WidgetTester tester) async {
  final GlobalKey anchorKey = GlobalKey();
  await tester.pumpWidget(
    wrapWithApp(
      Stack(
        children: <Widget>[
          Positioned(
            left: 100.0,
            top: 100.0,
            width: 80.0,
            height: 40.0,
            child: SizedBox(key: anchorKey),
          ),
        ],
      ),
    ),
  );
  return anchorKey.currentContext!.findRenderObject()! as RenderBox;
}

void main() {
  group('CupertinoCalendarOverlay', () {
    final DateTime min = DateTime.utc(2020);
    final DateTime max = DateTime.utc(2030, 12, 31);
    final DateTime initial = DateTime.utc(2024, 6, 15);

    testWidgets('renders the underlying CupertinoCalendar', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarOverlay(
            widgetRenderBox: anchor,
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            firstDayOfWeekIndex: 0,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            mainColor: const Color(0xFFFF0000),
            dismissBehavior: CalendarDismissBehavior.onOutsideTap,
            mode: CupertinoCalendarMode.date,
            minuteInterval: 1,
            use24hFormat: true,
            actions: null,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(CupertinoCalendar), findsOneWidget);
    });

    testWidgets('uses compact type for the inner calendar', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarOverlay(
            widgetRenderBox: anchor,
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            firstDayOfWeekIndex: 0,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            mainColor: const Color(0xFFFF0000),
            dismissBehavior: CalendarDismissBehavior.onOutsideTap,
            mode: CupertinoCalendarMode.date,
            minuteInterval: 1,
            use24hFormat: true,
            actions: null,
          ),
        ),
      );
      await tester.pump();

      final CupertinoCalendar calendar = tester.widget<CupertinoCalendar>(
        find.byType(CupertinoCalendar),
      );
      expect(calendar.type, CupertinoCalendarType.compact);
    });

    testWidgets('outsideTapDismissable matches the dismiss behavior', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarOverlay(
            widgetRenderBox: anchor,
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            firstDayOfWeekIndex: 0,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            mainColor: const Color(0xFFFF0000),
            dismissBehavior: CalendarDismissBehavior.onOutsideTap,
            mode: CupertinoCalendarMode.date,
            minuteInterval: 1,
            use24hFormat: true,
            actions: null,
          ),
        ),
      );
      await tester.pump();

      final CupertinoPickerOverlay overlay =
          tester.widget<CupertinoPickerOverlay>(
        find.byType(CupertinoPickerOverlay),
      );
      expect(overlay.outsideTapDismissable, isTrue);
    });

    testWidgets('outsideTapDismissable false when behavior is onActionTap', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarOverlay(
            widgetRenderBox: anchor,
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            firstDayOfWeekIndex: 0,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            mainColor: const Color(0xFFFF0000),
            dismissBehavior: CalendarDismissBehavior.onActionTap,
            mode: CupertinoCalendarMode.date,
            minuteInterval: 1,
            use24hFormat: true,
            actions: null,
          ),
        ),
      );
      await tester.pump();

      final CupertinoPickerOverlay overlay =
          tester.widget<CupertinoPickerOverlay>(
        find.byType(CupertinoPickerOverlay),
      );
      expect(overlay.outsideTapDismissable, isFalse);
    });

    testWidgets(
      'invokes onDateSelected and closes when behavior dismisses on select',
      (WidgetTester tester) async {
        final RenderBox anchor = await _pumpAnchor(tester);
        DateTime? selected;
        DateTime? changed;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoCalendarOverlay(
              widgetRenderBox: anchor,
              minimumDateTime: min,
              maximumDateTime: max,
              initialDateTime: initial,
              firstDayOfWeekIndex: 0,
              horizontalSpacing: 15.0,
              verticalSpacing: 15.0,
              offset: const Offset(0.0, 10.0),
              mainColor: const Color(0xFFFF0000),
              dismissBehavior: CalendarDismissBehavior.onDateSelect,
              mode: CupertinoCalendarMode.date,
              minuteInterval: 1,
              use24hFormat: true,
              actions: null,
              onDateSelected: (DateTime d) => selected = d,
              onDateTimeChanged: (DateTime d) => changed = d,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final Finder day20 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 20 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day20.first, warnIfMissed: false);
        await tester.pump();

        expect(selected, isNotNull);
        expect(selected?.day, 20);
        expect(changed, isNotNull);
        expect(changed?.day, 20);
      },
    );

    testWidgets(
      'reverse animation pops the route with the selected date',
      (WidgetTester tester) async {
        final RenderBox anchor = await _pumpAnchor(tester);
        DateTime? popped;

        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (BuildContext context) {
                return Center(
                  child: CupertinoButton(
                    onPressed: () async {
                      popped = await Navigator.of(context).push<DateTime>(
                        PageRouteBuilder<DateTime>(
                          opaque: false,
                          pageBuilder: (
                            BuildContext _,
                            Animation<double> __,
                            Animation<double> ___,
                          ) {
                            return CupertinoCalendarOverlay(
                              widgetRenderBox: anchor,
                              minimumDateTime: min,
                              maximumDateTime: max,
                              initialDateTime: initial,
                              firstDayOfWeekIndex: 0,
                              horizontalSpacing: 15.0,
                              verticalSpacing: 15.0,
                              offset: const Offset(0.0, 10.0),
                              mainColor: const Color(0xFFFF0000),
                              dismissBehavior:
                                  CalendarDismissBehavior.onDateSelect,
                              mode: CupertinoCalendarMode.date,
                              minuteInterval: 1,
                              use24hFormat: true,
                              actions: null,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('open'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        final Finder day12 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 12 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day12.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(popped?.day, 12);
        expect(find.byType(CupertinoCalendarOverlay), findsNothing);
      },
    );

    testWidgets(
      'time picker change in dateTime mode invokes onDateTimeChanged',
      (WidgetTester tester) async {
        final RenderBox anchor = await _pumpAnchor(tester);
        DateTime? changed;

        await tester.pumpWidget(
          wrapWithApp(
            CupertinoCalendarOverlay(
              widgetRenderBox: anchor,
              minimumDateTime: min,
              maximumDateTime: max,
              initialDateTime: initial,
              firstDayOfWeekIndex: 0,
              horizontalSpacing: 15.0,
              verticalSpacing: 15.0,
              offset: const Offset(0.0, 10.0),
              mainColor: const Color(0xFFFF0000),
              dismissBehavior: CalendarDismissBehavior.onOutsideTap,
              mode: CupertinoCalendarMode.dateTime,
              minuteInterval: 1,
              use24hFormat: true,
              actions: null,
              onDateTimeChanged: (DateTime d) => changed = d,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final Finder day18 = find.byWidgetPredicate(
          (Widget w) =>
              w is CalendarMonthPickerDay &&
              w.dayDate.day == 18 &&
              w.dayDate.month == 6 &&
              w.dayDate.year == 2024,
        );
        await tester.tap(day18.first, warnIfMissed: false);
        await tester.pump();

        expect(changed, isNotNull);
        expect(changed?.day, 18);
      },
    );

    testWidgets('expands height for dateTime mode and actions', (
      WidgetTester tester,
    ) async {
      final RenderBox anchor = await _pumpAnchor(tester);

      await tester.pumpWidget(
        wrapWithApp(
          CupertinoCalendarOverlay(
            widgetRenderBox: anchor,
            minimumDateTime: min,
            maximumDateTime: max,
            initialDateTime: initial,
            firstDayOfWeekIndex: 0,
            horizontalSpacing: 15.0,
            verticalSpacing: 15.0,
            offset: const Offset(0.0, 10.0),
            mainColor: const Color(0xFFFF0000),
            dismissBehavior: CalendarDismissBehavior.onOutsideTap,
            mode: CupertinoCalendarMode.dateTime,
            minuteInterval: 1,
            use24hFormat: true,
            actions: const <CupertinoCalendarAction>[
              ConfirmCupertinoCalendarAction(),
            ],
          ),
        ),
      );
      await tester.pump();

      final CupertinoPickerOverlay overlay =
          tester.widget<CupertinoPickerOverlay>(
        find.byType(CupertinoPickerOverlay),
      );
      expect(
        overlay.height,
        calendarDateTimePickerHeight + calendarActionsHeight,
      );
    });
  });
}
