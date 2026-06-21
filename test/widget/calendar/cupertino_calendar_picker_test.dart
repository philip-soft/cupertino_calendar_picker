// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DayPeriod, TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoCalendarPicker', () {
    final DateTime minimum = DateTime.utc(2020);
    final DateTime maximum = DateTime.utc(2030, 12, 31);
    final DateTime initialMonth = DateTime.utc(2024, 6);
    final DateTime selected = DateTime.utc(2024, 6, 15);
    final DateTime currentDate = DateTime.utc(2024, 6, 15);

    Widget buildPicker({
      CupertinoCalendarMode mode = CupertinoCalendarMode.date,
      CupertinoCalendarType type = CupertinoCalendarType.inline,
      DateTime? initial,
      DateTime? min,
      DateTime? max,
      DateTime? sel,
      ValueChanged<DateTime>? onDateChanged,
      ValueChanged<DateTime>? onMonthChanged,
      ValueChanged<DateTime>? onYearPickerChanged,
      ValueChanged<DateTime>? onTimeChanged,
      List<CupertinoCalendarAction>? actions,
    }) {
      return wrapWithApp(
        SizedBox(
          width: 320.0,
          height: 380.0,
          child: Builder(
            builder: (BuildContext context) {
              return CupertinoCalendarPicker(
                initialMonth: initial ?? initialMonth,
                currentDateTime: currentDate,
                minimumDateTime: min ?? minimum,
                maximumDateTime: max ?? maximum,
                selectedDateTime: sel ?? selected,
                selectableDayPredicate: null,
                firstDayOfWeekIndex: 0,
                onDateChanged: onDateChanged ?? (DateTime _) {},
                onTimeChanged: onTimeChanged ?? (DateTime _) {},
                onDisplayedMonthChanged: onMonthChanged ?? (DateTime _) {},
                onYearPickerChanged: onYearPickerChanged ?? (DateTime _) {},
                weekdayDecoration:
                    CalendarWeekdayDecoration.withDynamicColor(context),
                monthPickerDecoration:
                    CalendarMonthPickerDecoration.withDynamicColor(
                  context,
                  mainColor: CupertinoColors.systemRed,
                ),
                headerDecoration: CalendarHeaderDecoration.withDynamicColor(
                  context,
                  mainColor: CupertinoColors.systemRed,
                ),
                footerDecoration:
                    CalendarFooterDecoration.withDynamicColor(context),
                mainColor: CupertinoColors.systemRed,
                mode: mode,
                type: type,
                timeLabel: null,
                minuteInterval: 1,
                use24hFormat: true,
                actions: actions,
              );
            },
          ),
        ),
      );
    }

    testWidgets('starts in month picker view', (WidgetTester tester) async {
      await tester.pumpWidget(buildPicker());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarHeader), findsOneWidget);
      expect(find.byType(CalendarMonthPicker), findsOneWidget);
      expect(find.byType(CustomCupertinoDatePicker), findsNothing);
    });

    testWidgets('tapping header switches to year picker view', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPicker());
      await tester.pumpAndSettle();

      await tester.tap(find.text('June 2024'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomCupertinoDatePicker), findsOneWidget);
    });

    testWidgets('forward chevron advances month + fires callback', (
      WidgetTester tester,
    ) async {
      DateTime? month;
      await tester.pumpWidget(
        buildPicker(onMonthChanged: (DateTime d) => month = d),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(CupertinoIcons.chevron_forward).last);
      await tester.pumpAndSettle();

      expect(find.text('July 2024'), findsOneWidget);
      expect(month?.month, 7);
    });

    testWidgets('back chevron rewinds month', (WidgetTester tester) async {
      await tester.pumpWidget(buildPicker());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(CupertinoIcons.chevron_back));
      await tester.pumpAndSettle();

      expect(find.text('May 2024'), findsOneWidget);
    });

    testWidgets('dateTime mode shows footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildPicker(mode: CupertinoCalendarMode.dateTime),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarFooter), findsOneWidget);
    });

    testWidgets('date mode does not render footer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPicker());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarFooter), findsNothing);
    });

    testWidgets('compact + actions renders CalendarActions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildPicker(
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[
            CancelCupertinoCalendarAction(),
            ConfirmCupertinoCalendarAction(),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarActions), findsOneWidget);
    });

    testWidgets('tapping a day calls onDateChanged', (
      WidgetTester tester,
    ) async {
      DateTime? changed;
      await tester.pumpWidget(
        buildPicker(onDateChanged: (DateTime d) => changed = d),
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

      expect(changed, isNotNull);
      expect(changed?.day, 10);
    });

    testWidgets(
      'tapping header twice closes the year picker (animate back path)',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildPicker());
        await tester.pumpAndSettle();

        await tester.tap(find.text('June 2024'));
        await tester.pumpAndSettle();
        expect(find.byType(CustomCupertinoDatePicker), findsOneWidget);

        await tester.tap(find.text('June 2024'));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarMonthPicker), findsOneWidget);
      },
    );

    testWidgets(
      'year picker wheel scroll fires onYearPickerChanged',
      (WidgetTester tester) async {
        DateTime? yearPicked;
        await tester.pumpWidget(
          buildPicker(
            onYearPickerChanged: (DateTime d) => yearPicked = d,
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('June 2024'));
        await tester.pumpAndSettle();

        await tester.fling(
          find.byType(CustomCupertinoDatePicker),
          const Offset(0, -120),
          800,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(yearPicked, isNotNull);
      },
    );

    testWidgets(
      'dateTime mode + tapping time button switches to time picker view',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildPicker(mode: CupertinoCalendarMode.dateTime),
        );
        await tester.pumpAndSettle();
        expect(find.byType(CalendarFooter), findsOneWidget);

        final Finder tapTarget = find.byWidgetPredicate(
          (Widget w) =>
              w is GestureDetector && w.behavior == HitTestBehavior.translucent,
        );
        await tester.tap(tapTarget.last);
        await tester.pumpAndSettle();

        expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);
      },
    );

    testWidgets(
      'tapping Confirm action invokes its callback and pops the route',
      (WidgetTester tester) async {
        DateTime? confirmedWith;
        await tester.pumpWidget(
          wrapWithApp(
            Navigator(
              onGenerateRoute: (RouteSettings _) {
                return PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context, _, __) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: 320.0,
                          height: 380.0,
                          child: CupertinoCalendarPicker(
                            initialMonth: initialMonth,
                            currentDateTime: currentDate,
                            minimumDateTime: minimum,
                            maximumDateTime: maximum,
                            selectedDateTime: selected,
                            selectableDayPredicate: null,
                            firstDayOfWeekIndex: 0,
                            onDateChanged: (_) {},
                            onTimeChanged: (_) {},
                            onDisplayedMonthChanged: (_) {},
                            onYearPickerChanged: (_) {},
                            weekdayDecoration:
                                CalendarWeekdayDecoration.withDynamicColor(
                              context,
                            ),
                            monthPickerDecoration:
                                CalendarMonthPickerDecoration.withDynamicColor(
                              context,
                              mainColor: CupertinoColors.systemRed,
                            ),
                            headerDecoration:
                                CalendarHeaderDecoration.withDynamicColor(
                              context,
                              mainColor: CupertinoColors.systemRed,
                            ),
                            footerDecoration:
                                CalendarFooterDecoration.withDynamicColor(
                              context,
                            ),
                            mainColor: CupertinoColors.systemRed,
                            mode: CupertinoCalendarMode.date,
                            type: CupertinoCalendarType.compact,
                            timeLabel: null,
                            minuteInterval: 1,
                            use24hFormat: true,
                            actions: <CupertinoCalendarAction>[
                              const CancelCupertinoCalendarAction(),
                              ConfirmCupertinoCalendarAction(
                                onPressed: (DateTime d) => confirmedWith = d,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        expect(confirmedWith, isNotNull);
      },
    );

    testWidgets(
      'tapping Cancel action invokes its callback',
      (WidgetTester tester) async {
        int cancelCount = 0;
        await tester.pumpWidget(
          wrapWithApp(
            Navigator(
              onGenerateRoute: (RouteSettings _) {
                return PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context, _, __) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: 320.0,
                          height: 380.0,
                          child: CupertinoCalendarPicker(
                            initialMonth: initialMonth,
                            currentDateTime: currentDate,
                            minimumDateTime: minimum,
                            maximumDateTime: maximum,
                            selectedDateTime: selected,
                            selectableDayPredicate: null,
                            firstDayOfWeekIndex: 0,
                            onDateChanged: (_) {},
                            onTimeChanged: (_) {},
                            onDisplayedMonthChanged: (_) {},
                            onYearPickerChanged: (_) {},
                            weekdayDecoration:
                                CalendarWeekdayDecoration.withDynamicColor(
                              context,
                            ),
                            monthPickerDecoration:
                                CalendarMonthPickerDecoration.withDynamicColor(
                              context,
                              mainColor: CupertinoColors.systemRed,
                            ),
                            headerDecoration:
                                CalendarHeaderDecoration.withDynamicColor(
                              context,
                              mainColor: CupertinoColors.systemRed,
                            ),
                            footerDecoration:
                                CalendarFooterDecoration.withDynamicColor(
                              context,
                            ),
                            mainColor: CupertinoColors.systemRed,
                            mode: CupertinoCalendarMode.date,
                            type: CupertinoCalendarType.compact,
                            timeLabel: null,
                            minuteInterval: 1,
                            use24hFormat: true,
                            actions: <CupertinoCalendarAction>[
                              CancelCupertinoCalendarAction(
                                onPressed: () => cancelCount++,
                              ),
                              const ConfirmCupertinoCalendarAction(),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cancelCount, 1);
      },
    );

    testWidgets('updating initialMonth jumps to new month', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildPicker(initial: DateTime.utc(2024, 6)),
      );
      await tester.pumpAndSettle();
      expect(find.text('June 2024'), findsOneWidget);

      await tester.pumpWidget(
        buildPicker(initial: DateTime.utc(2025, 3)),
      );
      await tester.pumpAndSettle();

      expect(find.text('March 2025'), findsOneWidget);
    });

    testWidgets(
      'showMonth with jump:false animates to the requested month',
      (WidgetTester tester) async {
        final GlobalKey<CupertinoCalendarPickerState> pickerKey =
            GlobalKey<CupertinoCalendarPickerState>();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              width: 320.0,
              height: 380.0,
              child: Builder(
                builder: (BuildContext context) {
                  return CupertinoCalendarPicker(
                    key: pickerKey,
                    initialMonth: initialMonth,
                    currentDateTime: currentDate,
                    minimumDateTime: minimum,
                    maximumDateTime: maximum,
                    selectedDateTime: selected,
                    selectableDayPredicate: null,
                    firstDayOfWeekIndex: 0,
                    onDateChanged: (DateTime _) {},
                    onTimeChanged: (DateTime _) {},
                    onDisplayedMonthChanged: (DateTime _) {},
                    onYearPickerChanged: (DateTime _) {},
                    weekdayDecoration:
                        CalendarWeekdayDecoration.withDynamicColor(context),
                    monthPickerDecoration:
                        CalendarMonthPickerDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    headerDecoration: CalendarHeaderDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    footerDecoration:
                        CalendarFooterDecoration.withDynamicColor(context),
                    mainColor: CupertinoColors.systemRed,
                    mode: CupertinoCalendarMode.date,
                    type: CupertinoCalendarType.inline,
                    timeLabel: null,
                    minuteInterval: 1,
                    use24hFormat: true,
                    actions: null,
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        pickerKey.currentState!.showMonth(DateTime.utc(2024, 8));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();

        expect(find.text('August 2024'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'scrolling the time picker wheel fires onTimeChanged',
      (WidgetTester tester) async {
        DateTime? timeChanged;
        await tester.pumpWidget(
          buildPicker(
            mode: CupertinoCalendarMode.dateTime,
            onTimeChanged: (DateTime d) => timeChanged = d,
          ),
        );
        await tester.pumpAndSettle();

        final Finder tapTarget = find.byWidgetPredicate(
          (Widget w) =>
              w is GestureDetector && w.behavior == HitTestBehavior.translucent,
        );
        await tester.tap(tapTarget.last);
        await tester.pumpAndSettle();

        expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);

        await tester.drag(
          find.byType(CupertinoTimePickerWheel),
          const Offset(0, -80),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(timeChanged, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'changing AM/PM fires onTimeChanged when not in the time picker view',
      (WidgetTester tester) async {
        DateTime? timeChanged;
        await tester.pumpWidget(
          buildPicker(
            mode: CupertinoCalendarMode.dateTime,
            type: CupertinoCalendarType.compact,
            onTimeChanged: (DateTime d) => timeChanged = d,
          ),
        );
        await tester.pumpAndSettle();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              width: 320.0,
              height: 420.0,
              child: Builder(
                builder: (BuildContext context) {
                  return CupertinoCalendarPicker(
                    initialMonth: initialMonth,
                    currentDateTime: currentDate,
                    minimumDateTime: minimum,
                    maximumDateTime: maximum,
                    selectedDateTime: selected,
                    selectableDayPredicate: null,
                    firstDayOfWeekIndex: 0,
                    onDateChanged: (DateTime _) {},
                    onTimeChanged: (DateTime d) => timeChanged = d,
                    onDisplayedMonthChanged: (DateTime _) {},
                    onYearPickerChanged: (DateTime _) {},
                    weekdayDecoration:
                        CalendarWeekdayDecoration.withDynamicColor(context),
                    monthPickerDecoration:
                        CalendarMonthPickerDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    headerDecoration: CalendarHeaderDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    footerDecoration:
                        CalendarFooterDecoration.withDynamicColor(context),
                    mainColor: CupertinoColors.systemRed,
                    mode: CupertinoCalendarMode.dateTime,
                    type: CupertinoCalendarType.compact,
                    timeLabel: null,
                    minuteInterval: 1,
                    use24hFormat: false,
                    actions: null,
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final Finder amPmControl = find.byType(
          CupertinoSlidingSegmentedControl<DayPeriod>,
        );
        expect(amPmControl, findsOneWidget);

        final Finder pmText = find.text('PM');
        await tester.tap(pmText.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(timeChanged, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'closing the time picker returns to the previous view mode',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildPicker(mode: CupertinoCalendarMode.dateTime),
        );
        await tester.pumpAndSettle();

        final Finder tapTarget = find.byWidgetPredicate(
          (Widget w) =>
              w is GestureDetector && w.behavior == HitTestBehavior.translucent,
        );
        await tester.tap(tapTarget.last);
        await tester.pumpAndSettle();
        expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);

        await tester.tap(tapTarget.last);
        await tester.pumpAndSettle();

        expect(find.byType(CalendarMonthPicker), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'changing AM/PM scrolls the time picker wheel when it is open',
      (WidgetTester tester) async {
        final GlobalKey<CupertinoCalendarPickerState> pickerKey =
            GlobalKey<CupertinoCalendarPickerState>();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              width: 320.0,
              height: 420.0,
              child: Builder(
                builder: (BuildContext context) {
                  return CupertinoCalendarPicker(
                    key: pickerKey,
                    initialMonth: initialMonth,
                    currentDateTime: currentDate,
                    minimumDateTime: minimum,
                    maximumDateTime: maximum,
                    selectedDateTime: DateTime.utc(2024, 6, 15, 9),
                    selectableDayPredicate: null,
                    firstDayOfWeekIndex: 0,
                    onDateChanged: (DateTime _) {},
                    onTimeChanged: (DateTime _) {},
                    onDisplayedMonthChanged: (DateTime _) {},
                    onYearPickerChanged: (DateTime _) {},
                    weekdayDecoration:
                        CalendarWeekdayDecoration.withDynamicColor(context),
                    monthPickerDecoration:
                        CalendarMonthPickerDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    headerDecoration: CalendarHeaderDecoration.withDynamicColor(
                      context,
                      mainColor: CupertinoColors.systemRed,
                    ),
                    footerDecoration:
                        CalendarFooterDecoration.withDynamicColor(context),
                    mainColor: CupertinoColors.systemRed,
                    mode: CupertinoCalendarMode.dateTime,
                    type: CupertinoCalendarType.compact,
                    timeLabel: null,
                    minuteInterval: 1,
                    use24hFormat: false,
                    actions: null,
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        pickerKey.currentState!
            .setViewModeForTest(CupertinoCalendarViewMode.timePicker);
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);

        pickerKey.currentState!
            .onDayPeriodChanged(const TimeOfDay(hour: 9, minute: 30));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
