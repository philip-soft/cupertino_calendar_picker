// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarMonthPicker', () {
    final DateTime minimum = DateTime.utc(2024, 6);
    final DateTime maximum = DateTime.utc(2024, 12, 31);
    final DateTime currentDate = DateTime.utc(2024, 6, 15);
    final DateTime selectedDate = DateTime.utc(2024, 6, 15);
    final DateTime displayedMonth = DateTime.utc(2024, 6);

    Widget buildMonthPicker({
      ValueChanged<DateTime>? onChanged,
      SelectableDayPredicate? predicate,
      DateTime? selected,
      DateTime? min,
      DateTime? max,
      int? firstDayOfWeekIndex = 0,
    }) {
      final DateTime effectiveMin = min ?? minimum;
      final DateTime effectiveDisplayed = displayedMonth;
      final int initialPage =
          (effectiveDisplayed.year - effectiveMin.year) * 12 +
              (effectiveDisplayed.month - effectiveMin.month);
      final PageController controller =
          PageController(initialPage: initialPage);
      return wrapWithApp(
        SizedBox(
          height: 300.0,
          width: 320.0,
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  CalendarMonthPicker(
                    monthPageController: controller,
                    onMonthPageChanged: (int _) {},
                    displayedMonth: displayedMonth,
                    currentDate: currentDate,
                    minimumDate: effectiveMin,
                    maximumDate: max ?? maximum,
                    selectedDate: selected ?? selectedDate,
                    onChanged: onChanged ?? (DateTime _) {},
                    decoration: CalendarMonthPickerDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    mainColor: CupertinoColors.systemRed,
                    firstDayOfWeekIndex: firstDayOfWeekIndex,
                    selectableDayPredicate: predicate,
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    testWidgets(
      'falls back to default day styles when decoration has null styles',
      (WidgetTester tester) async {
        final PageController controller = PageController();
        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              height: 300.0,
              width: 320.0,
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: <Widget>[
                      CalendarMonthPicker(
                        monthPageController: controller,
                        onMonthPageChanged: (int _) {},
                        displayedMonth: displayedMonth,
                        currentDate: DateTime.utc(2024, 6, 16),
                        minimumDate: DateTime.utc(2024, 6, 10),
                        maximumDate: DateTime.utc(2024, 6, 20),
                        selectedDate: selectedDate,
                        onChanged: (DateTime _) {},
                        decoration: CalendarMonthPickerDecoration(),
                        mainColor: CupertinoColors.systemRed,
                        firstDayOfWeekIndex: 0,
                        selectableDayPredicate: null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CalendarMonthPicker), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders all 30 days of June 2024', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildMonthPicker());
      await tester.pumpAndSettle();

      for (int day = 1; day <= 30; day++) {
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is CalendarMonthPickerDay && w.dayDate.day == day,
          ),
          findsAtLeastNWidgets(1),
          reason: 'Day $day should be rendered',
        );
      }
    });

    testWidgets('tapping a day fires onChanged with that date', (
      WidgetTester tester,
    ) async {
      DateTime? selected;
      await tester.pumpWidget(
        buildMonthPicker(onChanged: (DateTime d) => selected = d),
      );
      await tester.pumpAndSettle();

      final Finder day20 = find.byWidgetPredicate(
        (Widget w) =>
            w is CalendarMonthPickerDay &&
            w.dayDate.day == 20 &&
            w.dayDate.month == 6,
      );
      await tester.tap(day20.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected?.day, 20);
      expect(selected?.month, 6);
    });

    testWidgets('selectableDayPredicate disables matching days', (
      WidgetTester tester,
    ) async {
      DateTime? selected;
      bool isOdd(DateTime d) => d.day.isOdd;

      await tester.pumpWidget(
        buildMonthPicker(
          onChanged: (DateTime d) => selected = d,
          predicate: isOdd,
        ),
      );
      await tester.pumpAndSettle();

      final Finder day10 = find.byWidgetPredicate(
        (Widget w) =>
            w is CalendarMonthPickerDay &&
            w.dayDate.day == 10 &&
            w.dayDate.month == 6,
      );
      await tester.tap(day10.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selected, isNull);

      final CalendarMonthPickerDay enabledDay =
          tester.widget<CalendarMonthPickerDay>(
        find
            .byWidgetPredicate(
              (Widget w) =>
                  w is CalendarMonthPickerDay &&
                  w.dayDate.day == 11 &&
                  w.dayDate.month == 6,
            )
            .first,
      );
      expect(enabledDay.onDaySelected, isNotNull);
    });

    testWidgets('days outside [minimum, maximum] are disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildMonthPicker(
          min: DateTime.utc(2024, 6, 10),
          max: DateTime.utc(2024, 6, 20),
        ),
      );
      await tester.pumpAndSettle();

      final CalendarMonthPickerDay before =
          tester.widget<CalendarMonthPickerDay>(
        find
            .byWidgetPredicate(
              (Widget w) =>
                  w is CalendarMonthPickerDay &&
                  w.dayDate.day == 5 &&
                  w.dayDate.month == 6,
            )
            .first,
      );
      final CalendarMonthPickerDay within =
          tester.widget<CalendarMonthPickerDay>(
        find
            .byWidgetPredicate(
              (Widget w) =>
                  w is CalendarMonthPickerDay &&
                  w.dayDate.day == 15 &&
                  w.dayDate.month == 6,
            )
            .first,
      );
      final CalendarMonthPickerDay after =
          tester.widget<CalendarMonthPickerDay>(
        find
            .byWidgetPredicate(
              (Widget w) =>
                  w is CalendarMonthPickerDay &&
                  w.dayDate.day == 25 &&
                  w.dayDate.month == 6,
            )
            .first,
      );

      expect(before.onDaySelected, isNull);
      expect(within.onDaySelected, isNotNull);
      expect(after.onDaySelected, isNull);
    });

    testWidgets(
      'uses selectedCurrentDayStyle when current day equals selected day',
      (WidgetTester tester) async {
        final DateTime sameDay = DateTime.utc(2024, 6, 15);
        final PageController controller = PageController();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              height: 300.0,
              width: 320.0,
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: <Widget>[
                      CalendarMonthPicker(
                        monthPageController: controller,
                        onMonthPageChanged: (int _) {},
                        displayedMonth: displayedMonth,
                        currentDate: sameDay,
                        minimumDate: minimum,
                        maximumDate: maximum,
                        selectedDate: sameDay,
                        onChanged: (DateTime _) {},
                        decoration:
                            CalendarMonthPickerDecoration.withDynamicColor(
                          context,
                          mainColor: CupertinoColors.systemRed,
                        ),
                        mainColor: CupertinoColors.systemRed,
                        firstDayOfWeekIndex: 0,
                        selectableDayPredicate: null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CalendarMonthPicker), findsOneWidget);
        expect(tester.takeException(), isNull);

        final CalendarMonthPickerDay day15 =
            tester.widget<CalendarMonthPickerDay>(
          find
              .byWidgetPredicate(
                (Widget w) =>
                    w is CalendarMonthPickerDay &&
                    w.dayDate.day == 15 &&
                    w.dayDate.month == 6,
              )
              .first,
        );
        expect(day15.onDaySelected, isNotNull);
      },
    );

    testWidgets(
      'uses selectedCurrentDayStyle fallback when decoration has null selectedCurrentDayStyle',
      (WidgetTester tester) async {
        final DateTime sameDay = DateTime.utc(2024, 6, 15);
        final PageController controller = PageController();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              height: 300.0,
              width: 320.0,
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: <Widget>[
                      CalendarMonthPicker(
                        monthPageController: controller,
                        onMonthPageChanged: (int _) {},
                        displayedMonth: displayedMonth,
                        currentDate: sameDay,
                        minimumDate: minimum,
                        maximumDate: maximum,
                        selectedDate: sameDay,
                        onChanged: (DateTime _) {},
                        decoration: CalendarMonthPickerDecoration(),
                        mainColor: CupertinoColors.systemRed,
                        firstDayOfWeekIndex: 0,
                        selectableDayPredicate: null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(CalendarMonthPicker), findsOneWidget);
      },
    );
  });
}
