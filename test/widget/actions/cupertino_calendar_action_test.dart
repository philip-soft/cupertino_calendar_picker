// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'test_helpers.dart';

Future<String> _effectiveLabel(
  WidgetTester tester,
  CupertinoCalendarAction action, {
  Locale locale = const Locale('en', 'US'),
}) async {
  late String label;
  await tester.pumpWidget(
    wrapWithApp(
      Builder(
        builder: (BuildContext context) {
          label = action.effectiveLabel(context);
          return const SizedBox();
        },
      ),
      locale: locale,
    ),
  );
  return label;
}

Future<void> _pumpCalendar(
  WidgetTester tester,
  List<CupertinoCalendarAction> actions, {
  CupertinoCalendarType type = CupertinoCalendarType.compact,
}) {
  return tester.pumpWidget(
    wrapWithApp(
      CupertinoCalendar(
        minimumDateTime: DateTime.utc(2020),
        maximumDateTime: DateTime.utc(2030),
        initialDateTime: DateTime.utc(2024, 6, 15),
        type: type,
        actions: actions,
      ),
    ),
  );
}

void main() {
  group('CancelCupertinoCalendarAction', () {
    testWidgets('uses the localized "Cancel" as default label', (
      WidgetTester tester,
    ) async {
      final String label = await _effectiveLabel(
        tester,
        const CancelCupertinoCalendarAction(),
      );

      expect(label, 'Cancel');
    });

    testWidgets('allows custom label override', (WidgetTester tester) async {
      final String label = await _effectiveLabel(
        tester,
        const CancelCupertinoCalendarAction(label: 'Abort'),
      );

      expect(label, 'Abort');
    });
  });

  group('ConfirmCupertinoCalendarAction', () {
    testWidgets('uses the localized "OK" as default label', (
      WidgetTester tester,
    ) async {
      final String label = await _effectiveLabel(
        tester,
        const ConfirmCupertinoCalendarAction(),
      );

      expect(label, 'OK');
    });

    testWidgets('localizes the default label', (WidgetTester tester) async {
      final String label = await _effectiveLabel(
        tester,
        const ConfirmCupertinoCalendarAction(),
        locale: const Locale('ar'),
      );

      expect(label, isNot('OK'));
    });
  });

  group('CupertinoCalendar actions constraints', () {
    testWidgets('asserts when actions list is empty', (
      WidgetTester tester,
    ) async {
      await _pumpCalendar(tester, const <CupertinoCalendarAction>[]);

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when actions list has more than 2 entries', (
      WidgetTester tester,
    ) async {
      await _pumpCalendar(tester, const <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
        CancelCupertinoCalendarAction(label: 'Extra'),
      ]);

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when actions provided with inline type', (
      WidgetTester tester,
    ) async {
      await _pumpCalendar(tester, const <CupertinoCalendarAction>[
        ConfirmCupertinoCalendarAction(),
      ], type: CupertinoCalendarType.inline);

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('builds successfully with 1 action in compact mode', (
      WidgetTester tester,
    ) async {
      await _pumpCalendar(tester, const <CupertinoCalendarAction>[
        ConfirmCupertinoCalendarAction(),
      ]);

      expect(tester.takeException(), isNull);
    });

    testWidgets('builds successfully with 2 actions in compact mode', (
      WidgetTester tester,
    ) async {
      await _pumpCalendar(tester, const <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
      ]);

      expect(tester.takeException(), isNull);
    });
  });
}
