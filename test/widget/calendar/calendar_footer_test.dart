// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarFooter', () {
    final CalendarFooterDecoration decoration = CalendarFooterDecoration();

    Widget buildFooter({
      TimeOfDay time = const TimeOfDay(hour: 14, minute: 30),
      String? label,
      CupertinoCalendarType type = CupertinoCalendarType.inline,
      bool? use24h = true,
      ValueChanged<TimeOfDay>? onTimeChanged,
      ValueChanged<bool>? onTimePickerStateChanged,
    }) {
      return wrapWithApp(
        CalendarFooter(
          time: time,
          onTimePickerStateChanged: onTimePickerStateChanged ?? (bool _) {},
          onTimeChanged: onTimeChanged ?? (TimeOfDay _) {},
          type: type,
          label: label,
          mainColor: CupertinoColors.systemRed,
          decoration: decoration,
          use24hFormat: use24h,
        ),
      );
    }

    testWidgets('renders divider, time button without label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildFooter());

      expect(find.byType(CupertinoPickerDivider), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('renders provided label text', (WidgetTester tester) async {
      const String label = 'Reminder time';

      await tester.pumpWidget(buildFooter(label: label));

      expect(find.text(label), findsOneWidget);
    });

    testWidgets('tapping time button toggles time picker state', (
      WidgetTester tester,
    ) async {
      final List<bool> states = <bool>[];
      await tester.pumpWidget(
        buildFooter(onTimePickerStateChanged: states.add),
      );

      final Finder tapTarget = find.byWidgetPredicate(
        (Widget w) =>
            w is GestureDetector && w.behavior == HitTestBehavior.translucent,
      );
      await tester.tap(tapTarget.last);
      await tester.pumpAndSettle();

      expect(states, <bool>[true]);
    });

    testWidgets('shows day period switcher in compact + 12h mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildFooter(
          type: CupertinoCalendarType.compact,
          use24h: false,
        ),
      );

      expect(
        find.byType(CupertinoSlidingSegmentedControl<DayPeriod>),
        findsOneWidget,
      );
    });

    testWidgets('hides day period switcher in 24h mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildFooter(
          type: CupertinoCalendarType.compact,
        ),
      );

      expect(
        find.byType(CupertinoSlidingSegmentedControl<DayPeriod>),
        findsNothing,
      );
    });

    testWidgets('hides day period switcher when type is inline', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildFooter(
          use24h: false,
        ),
      );

      expect(
        find.byType(CupertinoSlidingSegmentedControl<DayPeriod>),
        findsNothing,
      );
    });

    testWidgets(
      'tapping PM in the day period switcher updates hour by +12',
      (WidgetTester tester) async {
        TimeOfDay? changed;
        await tester.pumpWidget(
          buildFooter(
            time: const TimeOfDay(hour: 9, minute: 0),
            type: CupertinoCalendarType.compact,
            use24h: false,
            onTimeChanged: (TimeOfDay t) => changed = t,
          ),
        );

        await tester.tap(find.text('PM'));
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(changed?.hour, 21);
        expect(changed?.minute, 0);
      },
    );

    testWidgets(
      'tapping AM in the day period switcher updates hour by -12',
      (WidgetTester tester) async {
        TimeOfDay? changed;
        await tester.pumpWidget(
          buildFooter(
            time: const TimeOfDay(hour: 21, minute: 0),
            type: CupertinoCalendarType.compact,
            use24h: false,
            onTimeChanged: (TimeOfDay t) => changed = t,
          ),
        );

        await tester.tap(find.text('AM'));
        await tester.pumpAndSettle();

        expect(changed, isNotNull);
        expect(changed?.hour, 9);
      },
    );

    testWidgets('updates displayed time when widget.time changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildFooter(time: const TimeOfDay(hour: 9, minute: 0)),
      );
      expect(find.textContaining('9'), findsWidgets);

      await tester.pumpWidget(
        buildFooter(time: const TimeOfDay(hour: 17, minute: 45)),
      );

      expect(find.textContaining('17'), findsWidgets);
    });
  });
}
