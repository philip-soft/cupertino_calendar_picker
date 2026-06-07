// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CalendarActions', () {
    testWidgets('renders a single action without a divider', (
      WidgetTester tester,
    ) async {
      const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
        ConfirmCupertinoCalendarAction(),
      ];

      await tester.pumpWidget(
        wrapWithApp(
          CalendarActions(
            actions: actions,
            onPressed: (_) {},
          ),
        ),
      );

      expect(find.byType(CupertinoCalendarActionWidget), findsOneWidget);
      expect(find.byType(CupertinoPickerVerticalDivider), findsNothing);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('renders two actions separated by a vertical divider', (
      WidgetTester tester,
    ) async {
      const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
      ];

      await tester.pumpWidget(
        wrapWithApp(
          CalendarActions(
            actions: actions,
            onPressed: (_) {},
          ),
        ),
      );

      expect(find.byType(CupertinoCalendarActionWidget), findsNWidgets(2));
      expect(find.byType(CupertinoPickerVerticalDivider), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('forwards the tapped action to onPressed', (
      WidgetTester tester,
    ) async {
      CupertinoCalendarAction? tappedAction;
      const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
      ];

      await tester.pumpWidget(
        wrapWithApp(
          CalendarActions(
            actions: actions,
            onPressed: (CupertinoCalendarAction action) {
              tappedAction = action;
            },
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(tappedAction, isA<CancelCupertinoCalendarAction>());
    });

    testWidgets('uses the calendarActionsHeight constant for height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithApp(
          const CalendarActions(
            actions: <CupertinoCalendarAction>[
              ConfirmCupertinoCalendarAction(),
            ],
            onPressed: _noop,
          ),
        ),
      );

      final SizedBox box = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(CalendarActions),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(box.height, calendarActionsHeight);
    });
  });
}

void _noop(CupertinoCalendarAction _) {}
