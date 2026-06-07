// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarDismissBehavior', () {
    test('exposes all four enum values', () {
      const List<CalendarDismissBehavior> values =
          CalendarDismissBehavior.values;

      expect(values, contains(CalendarDismissBehavior.onOutsideTap));
      expect(values, contains(CalendarDismissBehavior.onDateSelect));
      expect(
        values,
        contains(CalendarDismissBehavior.onOusideTapOrDateSelect),
      );
      expect(values, contains(CalendarDismissBehavior.onActionTap));
      expect(values.length, 4);
    });

    group('hasOusideTapDismiss', () {
      test('is true for onOutsideTap', () {
        expect(
          CalendarDismissBehavior.onOutsideTap.hasOusideTapDismiss,
          isTrue,
        );
      });

      test('is true for onOusideTapOrDateSelect', () {
        expect(
          CalendarDismissBehavior.onOusideTapOrDateSelect.hasOusideTapDismiss,
          isTrue,
        );
      });

      test('is false for onDateSelect', () {
        expect(
          CalendarDismissBehavior.onDateSelect.hasOusideTapDismiss,
          isFalse,
        );
      });

      test('is false for onActionTap', () {
        expect(
          CalendarDismissBehavior.onActionTap.hasOusideTapDismiss,
          isFalse,
        );
      });
    });

    group('hasDateSelectDismiss', () {
      test('is true for onDateSelect', () {
        expect(
          CalendarDismissBehavior.onDateSelect.hasDateSelectDismiss,
          isTrue,
        );
      });

      test('is true for onOusideTapOrDateSelect', () {
        expect(
          CalendarDismissBehavior.onOusideTapOrDateSelect.hasDateSelectDismiss,
          isTrue,
        );
      });

      test('is false for onOutsideTap', () {
        expect(
          CalendarDismissBehavior.onOutsideTap.hasDateSelectDismiss,
          isFalse,
        );
      });

      test('is false for onActionTap', () {
        expect(
          CalendarDismissBehavior.onActionTap.hasDateSelectDismiss,
          isFalse,
        );
      });
    });
  });
}
