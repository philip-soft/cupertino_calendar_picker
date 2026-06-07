// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CancelCupertinoCalendarAction', () {
    test('uses "Cancel" as default label', () {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      expect(action.label, 'Cancel');
      expect(action.isDefaultAction, isFalse);
      expect(action.onPressed, isNull);
    });

    test('allows custom label override', () {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction(label: 'Abort');

      expect(action.label, 'Abort');
    });
  });

  group('ConfirmCupertinoCalendarAction', () {
    test('uses "Done" as default label and is the default action', () {
      const ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction();

      expect(action.label, 'Done');
      expect(action.isDefaultAction, isTrue);
    });

    test('accepts a typed onPressed callback', () {
      DateTime? receivedDate;

      final ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction(
        onPressed: (DateTime date) {
          receivedDate = date;
        },
      );
      final DateTime now = DateTime.utc(2024, 6, 15);
      (action.onPressed as ValueChanged<DateTime>?)?.call(now);

      expect(receivedDate, now);
    });
  });

  group('CupertinoCalendarAction equality', () {
    test('actions with the same fields are equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b = CancelCupertinoCalendarAction();

      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('actions with different labels are not equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b =
          CancelCupertinoCalendarAction(label: 'Stop');

      expect(a == b, isFalse);
    });

    test('cancel and confirm are distinct types', () {
      const CancelCupertinoCalendarAction cancel =
          CancelCupertinoCalendarAction();
      const ConfirmCupertinoCalendarAction confirm =
          ConfirmCupertinoCalendarAction();

      expect(cancel == confirm, isFalse);
    });
  });

  group('CupertinoCalendar actions constraints', () {
    test('asserts when actions list is empty', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2020),
          maximumDateTime: DateTime.utc(2030),
          initialDateTime: DateTime.utc(2024, 6, 15),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[],
        ),
        throwsAssertionError,
      );
    });

    test('asserts when actions list has more than 2 entries', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2020),
          maximumDateTime: DateTime.utc(2030),
          initialDateTime: DateTime.utc(2024, 6, 15),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[
            CancelCupertinoCalendarAction(),
            ConfirmCupertinoCalendarAction(),
            CancelCupertinoCalendarAction(label: 'Extra'),
          ],
        ),
        throwsAssertionError,
      );
    });

    test('asserts when actions provided with inline type', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2020),
          maximumDateTime: DateTime.utc(2030),
          initialDateTime: DateTime.utc(2024, 6, 15),
          actions: const <CupertinoCalendarAction>[
            ConfirmCupertinoCalendarAction(),
          ],
        ),
        throwsAssertionError,
      );
    });

    test('builds successfully with 1 action in compact mode', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2020),
          maximumDateTime: DateTime.utc(2030),
          initialDateTime: DateTime.utc(2024, 6, 15),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[
            ConfirmCupertinoCalendarAction(),
          ],
        ),
        returnsNormally,
      );
    });

    test('builds successfully with 2 actions in compact mode', () {
      expect(
        () => CupertinoCalendar(
          minimumDateTime: DateTime.utc(2020),
          maximumDateTime: DateTime.utc(2030),
          initialDateTime: DateTime.utc(2024, 6, 15),
          type: CupertinoCalendarType.compact,
          actions: const <CupertinoCalendarAction>[
            CancelCupertinoCalendarAction(),
            ConfirmCupertinoCalendarAction(),
          ],
        ),
        returnsNormally,
      );
    });
  });
}
