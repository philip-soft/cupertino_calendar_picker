// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CancelCupertinoCalendarAction', () {
    test('defaults to label Cancel and not default action', () {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      expect(action.label, 'Cancel');
      expect(action.isDefaultAction, isFalse);
      expect(action.decoration, isNull);
      expect(action.onPressed, isNull);
    });

    test('respects supplied label, isDefaultAction and onPressed', () {
      void cb() {}

      final CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction(
        label: 'Custom',
        isDefaultAction: true,
        onPressed: cb,
      );

      expect(action.label, 'Custom');
      expect(action.isDefaultAction, isTrue);
      expect(action.onPressed, cb);
    });

    test('two actions with identical fields are equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b = CancelCupertinoCalendarAction();

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('two actions with different labels are not equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b =
          CancelCupertinoCalendarAction(label: 'Other');

      expect(a, isNot(b));
    });

    test('two actions with different isDefaultAction are not equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b =
          CancelCupertinoCalendarAction(isDefaultAction: true);

      expect(a, isNot(b));
    });

    test('identical reference is equal to itself', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();

      // ignore: unrelated_type_equality_checks
      expect(a == a, isTrue);
    });
  });

  group('ConfirmCupertinoCalendarAction', () {
    test('defaults to label Done and isDefaultAction true', () {
      const ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction();

      expect(action.label, 'Done');
      expect(action.isDefaultAction, isTrue);
      expect(action.decoration, isNull);
      expect(action.onPressed, isNull);
    });

    test('accepts a ValueChanged<DateTime> callback as onPressed', () {
      DateTime? captured;
      void cb(DateTime d) {
        captured = d;
      }

      final ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction(onPressed: cb);

      expect(action.onPressed, isNotNull);
      // ignore: avoid_dynamic_calls
      (action.onPressed! as Function)(DateTime(2024, 1, 2));
      expect(captured, DateTime(2024, 1, 2));
    });

    test('two actions with identical fields are equal', () {
      const ConfirmCupertinoCalendarAction a = ConfirmCupertinoCalendarAction();
      const ConfirmCupertinoCalendarAction b = ConfirmCupertinoCalendarAction();

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('CupertinoCalendarAction equality cross-type', () {
    test('a Cancel and Confirm with same fields are equal as base type', () {
      const CancelCupertinoCalendarAction cancel =
          CancelCupertinoCalendarAction(label: 'X', isDefaultAction: true);
      const ConfirmCupertinoCalendarAction confirm =
          ConfirmCupertinoCalendarAction(label: 'X');

      expect(cancel == confirm, isTrue);
    });

    test('different label means not equal', () {
      const CancelCupertinoCalendarAction a =
          CancelCupertinoCalendarAction(label: 'A');
      const CancelCupertinoCalendarAction b =
          CancelCupertinoCalendarAction(label: 'B');

      expect(a == b, isFalse);
    });
  });
}
