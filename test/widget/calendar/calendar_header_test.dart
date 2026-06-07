// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarHeader', () {
    final CalendarHeaderDecoration decoration = CalendarHeaderDecoration(
      mainColor: CupertinoColors.systemRed,
    );

    Widget buildHeader({
      DateTime? currentMonth,
      VoidCallback? onNext,
      VoidCallback? onPrev,
      YearPickerCallback? onYearPickerStateChanged,
    }) {
      return wrapWithApp(
        CalendarHeader(
          currentMonth: currentMonth ?? DateTime.utc(2024, 6),
          onPreviousMonthIconTapped: onPrev,
          onNextMonthIconTapped: onNext,
          onYearPickerStateChanged: onYearPickerStateChanged ?? (bool show) {},
          decoration: decoration,
        ),
      );
    }

    testWidgets('displays month and year in en_US locale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHeader());

      expect(find.text('June 2024'), findsOneWidget);
    });

    testWidgets('renders two navigation chevrons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildHeader(
          onNext: () {},
          onPrev: () {},
        ),
      );

      expect(find.byIcon(CupertinoIcons.chevron_back), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.chevron_forward), findsNWidgets(2));
    });

    testWidgets('tapping forward chevron fires onNextMonthIconTapped', (
      WidgetTester tester,
    ) async {
      int nextCount = 0;
      await tester.pumpWidget(
        buildHeader(
          onNext: () => nextCount++,
          onPrev: () {},
        ),
      );

      final Finder forwardFinder = find.descendant(
        of: find.byWidgetPredicate(
          (Widget w) =>
              w is GestureDetector && w.behavior == HitTestBehavior.translucent,
        ),
        matching: find.byIcon(CupertinoIcons.chevron_forward),
      );
      await tester.tap(forwardFinder.last);
      await tester.pumpAndSettle();

      expect(nextCount, 1);
    });

    testWidgets('tapping back chevron fires onPreviousMonthIconTapped', (
      WidgetTester tester,
    ) async {
      int prevCount = 0;
      await tester.pumpWidget(
        buildHeader(
          onNext: () {},
          onPrev: () => prevCount++,
        ),
      );

      await tester.tap(find.byIcon(CupertinoIcons.chevron_back));
      await tester.pumpAndSettle();

      expect(prevCount, 1);
    });

    testWidgets('tapping the month title calls onYearPickerStateChanged', (
      WidgetTester tester,
    ) async {
      final List<bool> events = <bool>[];
      await tester.pumpWidget(
        buildHeader(
          onNext: () {},
          onPrev: () {},
          onYearPickerStateChanged: events.add,
        ),
      );

      await tester.tap(find.text('June 2024'));
      await tester.pumpAndSettle();

      expect(events, <bool>[true]);

      await tester.tap(find.text('June 2024'));
      await tester.pumpAndSettle();

      expect(events, <bool>[true, false]);
    });

    testWidgets('disabled state when callbacks are null still renders icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHeader());

      expect(find.byIcon(CupertinoIcons.chevron_back), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.chevron_forward), findsNWidgets(2));
    });

    testWidgets('updates display when currentMonth changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildHeader(currentMonth: DateTime.utc(2024, 6)),
      );
      expect(find.text('June 2024'), findsOneWidget);

      await tester.pumpWidget(
        buildHeader(currentMonth: DateTime.utc(2024, 12)),
      );

      expect(find.text('December 2024'), findsOneWidget);
      expect(find.text('June 2024'), findsNothing);
    });
  });
}
