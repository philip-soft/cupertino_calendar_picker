// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime initial = DateTime.utc(2024, 6, 15);

  Widget buildCalendar({
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
    CupertinoCalendarType type = CupertinoCalendarType.inline,
    DateTime? min,
    DateTime? max,
    DateTime? init,
    DateTime? currentDateTime,
    ValueChanged<DateTime>? onDateChanged,
    ValueChanged<DateTime>? onDateSelected,
    ValueChanged<DateTime>? onMonthChanged,
    SelectableDayPredicate? predicate,
    List<CupertinoCalendarAction>? actions,
    Brightness brightness = Brightness.light,
    TextDirection direction = TextDirection.ltr,
  }) {
    return wrapWithApp(
      CupertinoCalendar(
        minimumDateTime: min ?? minimum,
        maximumDateTime: max ?? maximum,
        initialDateTime: init ?? initial,
        currentDateTime: currentDateTime ?? DateTime.utc(2024, 6, 15),
        mode: mode,
        type: type,
        onDateTimeChanged: onDateChanged,
        onDateSelected: onDateSelected,
        onDisplayedMonthChanged: onMonthChanged,
        selectableDayPredicate: predicate,
        firstDayOfWeekIndex: 0,
        actions: actions,
      ),
      brightness: brightness,
      textDirection: direction,
    );
  }

  group('CupertinoCalendar – rendering', () {
    testWidgets('renders inline date calendar with header and grid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalendar());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarHeader), findsOneWidget);
      expect(find.byType(CalendarWeekdays), findsOneWidget);
      expect(find.byType(CalendarMonthPicker), findsOneWidget);
      expect(find.text('June 2024'), findsOneWidget);
    });

    testWidgets('renders no footer in date mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalendar());
      await tester.pumpAndSettle();

      expect(find.byType(CalendarFooter), findsNothing);
    });

    testWidgets('renders footer in dateTime mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(mode: CupertinoCalendarMode.dateTime),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarFooter), findsOneWidget);
    });

    testWidgets('compact type renders cleanly', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildCalendar(type: CupertinoCalendarType.compact),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoCalendar), findsOneWidget);
      expect(find.byType(CalendarMonthPicker), findsOneWidget);
    });

    testWidgets('renders cancel/confirm actions in compact mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(
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
  });

  group('CupertinoCalendar – interaction', () {
    testWidgets('initial date is shown in the header', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(init: DateTime.utc(2024, 3)),
      );
      await tester.pumpAndSettle();

      expect(find.text('March 2024'), findsOneWidget);
    });

    testWidgets('tapping a different day fires onDateSelected', (
      WidgetTester tester,
    ) async {
      DateTime? changed;
      DateTime? selected;
      await tester.pumpWidget(
        buildCalendar(
          onDateChanged: (DateTime d) => changed = d,
          onDateSelected: (DateTime d) => selected = d,
        ),
      );
      await tester.pumpAndSettle();

      final Finder day20 = find.byWidgetPredicate(
        (Widget w) =>
            w is CalendarMonthPickerDay &&
            w.dayDate.day == 20 &&
            w.dayDate.month == 6 &&
            w.dayDate.year == 2024,
      );
      await tester.tap(day20.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(changed, isNotNull);
      expect(selected, isNotNull);
      expect(selected?.day, 20);
      expect(selected?.month, 6);
      expect(selected?.year, 2024);
    });

    testWidgets('forward chevron advances the month', (
      WidgetTester tester,
    ) async {
      DateTime? lastMonth;
      await tester.pumpWidget(
        buildCalendar(onMonthChanged: (DateTime m) => lastMonth = m),
      );
      await tester.pumpAndSettle();
      expect(find.text('June 2024'), findsOneWidget);

      await tester.tap(find.byIcon(CupertinoIcons.chevron_forward).last);
      await tester.pumpAndSettle();

      expect(find.text('July 2024'), findsOneWidget);
      expect(lastMonth?.month, 7);
    });

    testWidgets('back chevron rewinds the month', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalendar());
      await tester.pumpAndSettle();
      expect(find.text('June 2024'), findsOneWidget);

      await tester.tap(find.byIcon(CupertinoIcons.chevron_back));
      await tester.pumpAndSettle();

      expect(find.text('May 2024'), findsOneWidget);
    });

    testWidgets('tapping header opens the year/month picker view', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalendar());
      await tester.pumpAndSettle();
      expect(find.byType(CustomCupertinoDatePicker), findsNothing);

      await tester.tap(find.text('June 2024'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomCupertinoDatePicker), findsOneWidget);
    });

    testWidgets('selectableDayPredicate makes days non-tappable', (
      WidgetTester tester,
    ) async {
      DateTime? selected;
      await tester.pumpWidget(
        buildCalendar(
          onDateSelected: (DateTime d) => selected = d,
          predicate: (DateTime d) => d.day != 10,
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

      final CalendarMonthPickerDay disabled =
          tester.widget<CalendarMonthPickerDay>(day10.first);
      expect(disabled.onDaySelected, isNull);
    });

    testWidgets('days outside minimum/maximum are disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(
          min: DateTime.utc(2024, 6, 10),
          max: DateTime.utc(2024, 6, 20),
          init: DateTime.utc(2024, 6, 15),
        ),
      );
      await tester.pumpAndSettle();

      final CalendarMonthPickerDay disabledBefore =
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
      expect(disabledBefore.onDaySelected, isNull);

      final CalendarMonthPickerDay disabledAfter =
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
      expect(disabledAfter.onDaySelected, isNull);
    });

    testWidgets('updating initialDateTime resets displayed month', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(init: DateTime.utc(2024, 6, 15)),
      );
      await tester.pumpAndSettle();
      expect(find.text('June 2024'), findsOneWidget);

      await tester.pumpWidget(
        buildCalendar(init: DateTime.utc(2025, 1, 5)),
      );
      await tester.pumpAndSettle();

      expect(find.text('January 2025'), findsOneWidget);
    });
  });

  group('CupertinoCalendar – picker wheel paths', () {
    testWidgets(
      'scrolling the year picker wheel updates the displayed date',
      (WidgetTester tester) async {
        DateTime? changed;
        await tester.pumpWidget(
          buildCalendar(
            onDateChanged: (DateTime d) => changed = d,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('June 2024'));
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(CustomCupertinoDatePicker),
          const Offset(0, -120),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
      },
    );

    testWidgets(
      'tapping the time label in dateTime mode opens the time picker view',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildCalendar(mode: CupertinoCalendarMode.dateTime),
        );
        await tester.pumpAndSettle();
        expect(find.byType(CalendarFooter), findsOneWidget);

        final Finder timeLabel = find.descendant(
          of: find.byType(CalendarFooter),
          matching: find.byType(GestureDetector),
        );
        expect(timeLabel, findsWidgets);
        await tester.tap(timeLabel.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'flinging the year picker wheel triggers onDateTimeChanged',
      (WidgetTester tester) async {
        DateTime? changed;
        await tester.pumpWidget(
          buildCalendar(
            onDateChanged: (DateTime d) => changed = d,
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

        expect(changed, isNotNull);
      },
    );
  });

  group('CupertinoCalendar – appearance modes', () {
    testWidgets('renders in dark mode without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalendar(brightness: Brightness.dark));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoCalendar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in RTL direction without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildCalendar(direction: TextDirection.rtl),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoCalendar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('CupertinoCalendar – year picker boundary clamping', () {
    testWidgets(
      'clamps to minimumDateTime when year picker result is before minimum '
      '(line 216)',
      (WidgetTester tester) async {
        final DateTime min = DateTime.utc(2024, 6, 20);
        final DateTime max = DateTime.utc(2030, 12, 31);
        final DateTime init = DateTime.utc(2024, 7, 15);

        DateTime? changed;
        await tester.pumpWidget(
          buildCalendar(
            min: min,
            max: max,
            init: init,
            onDateChanged: (DateTime d) => changed = d,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('July 2024'));
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(CustomCupertinoDatePicker),
          const Offset(0, 200),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        if (changed != null) {
          expect(
            changed!.isBefore(min),
            isFalse,
            reason: 'Result should be clamped to minimumDateTime',
          );
        }
      },
    );

    testWidgets(
      'clamps to maximumDateTime when year picker result exceeds maximum '
      '(line 218)',
      (WidgetTester tester) async {
        final DateTime min = DateTime.utc(2020);
        final DateTime max = DateTime.utc(2024, 7, 10);
        final DateTime init = DateTime.utc(2024, 6, 15);

        DateTime? changed;
        await tester.pumpWidget(
          buildCalendar(
            min: min,
            max: max,
            init: init,
            onDateChanged: (DateTime d) => changed = d,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('June 2024'));
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(CustomCupertinoDatePicker),
          const Offset(0, -200),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        if (changed != null) {
          expect(
            changed!.isAfter(max),
            isFalse,
            reason: 'Result should be clamped to maximumDateTime',
          );
        }
      },
    );
  });

  group('CupertinoCalendar – time changed path', () {
    testWidgets(
      '_onTimeChanged updates selected date and fires onDateTimeChanged '
      '(lines 252/253)',
      (WidgetTester tester) async {
        DateTime? changed;
        await tester.pumpWidget(
          buildCalendar(
            mode: CupertinoCalendarMode.dateTime,
            onDateChanged: (DateTime d) => changed = d,
          ),
        );
        await tester.pumpAndSettle();

        final Finder timeLabel = find.descendant(
          of: find.byType(CalendarFooter),
          matching: find.byType(GestureDetector),
        );
        await tester.tap(timeLabel.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.byType(CupertinoTimePickerWheel), findsOneWidget);

        await tester.drag(
          find.byType(CupertinoTimePickerWheel),
          const Offset(0, -100),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('CupertinoCalendar – asserts', () {
    test('throws when maximumDateTime is before minimumDateTime', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2020, 6),
        ),
        throwsAssertionError,
      );
    });

    test('throws when initialDateTime is before minimumDateTime', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2025, 6),
          initialDateTime: DateTime.utc(2020),
        ),
        throwsAssertionError,
      );
    });

    test('throws when initialDateTime is after maximumDateTime', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2025, 6),
          initialDateTime: DateTime.utc(2030),
        ),
        throwsAssertionError,
      );
    });

    test('throws when actions are used with inline type', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2025, 6),
          actions: const <CupertinoCalendarAction>[
            CancelCupertinoCalendarAction(),
          ],
        ),
        throwsAssertionError,
      );
    });

    test('throws when actions list is empty', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2025, 6),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[],
        ),
        throwsAssertionError,
      );
    });

    test('throws when actions list has more than two entries', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2024, 6),
          maximumDateTime: DateTime.utc(2025, 6),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[
            CancelCupertinoCalendarAction(),
            ConfirmCupertinoCalendarAction(),
            ConfirmCupertinoCalendarAction(),
          ],
        ),
        throwsAssertionError,
      );
    });
  });
}
