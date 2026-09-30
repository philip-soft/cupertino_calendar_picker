// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CancelCupertinoCalendarAction', () {
    test('defaults to a localized label and not default action', () {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      expect(action.label, isNull);
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
      const CancelCupertinoCalendarAction b = CancelCupertinoCalendarAction(
        label: 'Other',
      );

      expect(a, isNot(b));
    });

    test('two actions with different isDefaultAction are not equal', () {
      const CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction();
      const CancelCupertinoCalendarAction b = CancelCupertinoCalendarAction(
        isDefaultAction: true,
      );

      expect(a, isNot(b));
    });

    test('two actions with different callbacks are not equal', () {
      final CancelCupertinoCalendarAction a = CancelCupertinoCalendarAction(
        onPressed: () {},
      );
      final CancelCupertinoCalendarAction b = CancelCupertinoCalendarAction(
        onPressed: () {},
      );

      expect(a, isNot(b));
    });
  });

  group('ConfirmCupertinoCalendarAction', () {
    test('defaults to a localized label and isDefaultAction true', () {
      const ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction();

      expect(action.label, isNull);
      expect(action.isDefaultAction, isTrue);
      expect(action.decoration, isNull);
      expect(action.onPressed, isNull);
    });

    test('exposes a typed ValueChanged<DateTime> callback', () {
      DateTime? captured;
      final ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction(
            onPressed: (DateTime date) => captured = date,
          );

      action.onPressed?.call(DateTime(2024, 1, 2));

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
    test('a Cancel and a Confirm with the same fields are not equal', () {
      const CancelCupertinoCalendarAction cancel =
          CancelCupertinoCalendarAction(label: 'X', isDefaultAction: true);
      const ConfirmCupertinoCalendarAction confirm =
          ConfirmCupertinoCalendarAction(label: 'X');

      expect(cancel == confirm, isFalse);
    });
  });
}
