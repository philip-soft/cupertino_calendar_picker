// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

Widget _app(Widget child) {
  return wrapTestWidget(
    child,
    brightness: Brightness.light,
    textDirection: TextDirection.ltr,
    locale: const Locale('en', 'US'),
    layout: (Widget child) => Center(child: child),
  );
}

Widget _calendar({
  CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  List<CupertinoCalendarAction>? actions,
}) {
  return CupertinoCalendar(
    minimumDateTime: DateTime(2026, 9, 5),
    maximumDateTime: DateTime(2026, 12, 31),
    initialDateTime: DateTime(2026, 9, 15, 9, 30),
    currentDateTime: DateTime(2026, 9, 20),
    mode: mode,
    type: actions == null
        ? CupertinoCalendarType.inline
        : CupertinoCalendarType.compact,
    timeLabel: 'Starts',
    use24hFormat: true,
    actions: actions,
  );
}

void main() {
  group('Semantics', () {
    testWidgets('day cells expose the full date, selection and tap', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_calendar()));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(
          find.bySemanticsLabel('Tuesday, September 15, 2026'),
        ),
        isSemantics(
          isButton: true,
          isSelected: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(
          find.bySemanticsLabel(RegExp('September 20, 2026')),
        ),
        isSemantics(isButton: true, isSelected: false),
      );
      handle.dispose();
    });

    testWidgets('days outside the range are announced as disabled', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_calendar()));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(
          find.bySemanticsLabel('Thursday, September 3, 2026'),
        ),
        isSemantics(isButton: true, isEnabled: false, hasTapAction: false),
      );
      handle.dispose();
    });

    testWidgets('selecting a day through semantics tap changes the selection', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      DateTime? changed;
      await tester.pumpWidget(
        _app(
          CupertinoCalendar(
            minimumDateTime: DateTime(2026),
            maximumDateTime: DateTime(2026, 12, 31),
            initialDateTime: DateTime(2026, 9, 15),
            onDateTimeChanged: (DateTime value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      tester.semantics.tap(
        find.semantics.byLabel('Friday, September 18, 2026'),
      );
      await tester.pumpAndSettle();

      expect(changed, DateTime(2026, 9, 18));
      handle.dispose();
    });

    testWidgets('header exposes month toggle and navigation buttons', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_calendar()));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel('September 2026')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Previous month')),
        isSemantics(isButton: true, isEnabled: false),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Next month')),
        isSemantics(isButton: true, isEnabled: true, hasTapAction: true),
      );
      handle.dispose();
    });

    testWidgets('weekday labels are excluded from semantics', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_calendar()));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('MON'), findsNothing);
      handle.dispose();
    });

    testWidgets('footer time is a button labelled with the time label', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(_calendar(mode: CupertinoCalendarMode.dateTime)),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel(RegExp('Starts'))),
        isSemantics(isButton: true, hasTapAction: true, value: '09:30'),
      );
      handle.dispose();
    });

    testWidgets('actions are buttons', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          _calendar(
            actions: const <CupertinoCalendarAction>[
              CancelCupertinoCalendarAction(),
              ConfirmCupertinoCalendarAction(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel('Cancel')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('OK')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      handle.dispose();
    });

    testWidgets('picker buttons are buttons labelled with their value', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoCalendarPickerButton(
                minimumDateTime: DateTime(2026),
                maximumDateTime: DateTime(2026, 12, 31),
                initialDateTime: DateTime(2026, 9, 15),
              ),
              const CupertinoTimePickerButton(
                initialTime: TimeOfDay(hour: 9, minute: 30),
                use24hFormat: true,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel('Sep 15, 2026')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('09:30')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      handle.dispose();
    });

    testWidgets('outside barrier can be dismissed via semantics', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          CupertinoCalendarPickerButton(
            minimumDateTime: DateTime(2026),
            maximumDateTime: DateTime(2026, 12, 31),
            initialDateTime: DateTime(2026, 9, 15),
          ),
        ),
      );
      await tester.tap(find.byType(CupertinoCalendarPickerButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoCalendar), findsOneWidget);

      tester.semantics.tap(find.semantics.byLabel('Dismiss'));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoCalendar), findsNothing);
      handle.dispose();
    });
  });
}
