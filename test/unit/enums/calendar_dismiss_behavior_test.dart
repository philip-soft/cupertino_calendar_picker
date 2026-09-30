// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarDismissBehavior', () {
    // The value set and its order are part of the published API: renaming a
    // value breaks `switch` statements downstream, and reordering shifts the
    // `index` that consumers may have persisted.
    test('declares the documented values in order', () {
      expect(
        CalendarDismissBehavior.values.map(
          (CalendarDismissBehavior value) => value.name,
        ),
        <String>[
          'onOutsideTap',
          'onDateSelect',
          'onOutsideTapOrDateSelect',
          'onActionTap',
        ],
      );
    });

    group('hasOutsideTapDismiss', () {
      test('is true for onOutsideTap', () {
        expect(
          CalendarDismissBehavior.onOutsideTap.hasOutsideTapDismiss,
          isTrue,
        );
      });

      test('is true for onOutsideTapOrDateSelect', () {
        expect(
          CalendarDismissBehavior.onOutsideTapOrDateSelect.hasOutsideTapDismiss,
          isTrue,
        );
      });

      test('is false for onDateSelect', () {
        expect(
          CalendarDismissBehavior.onDateSelect.hasOutsideTapDismiss,
          isFalse,
        );
      });

      test('is false for onActionTap', () {
        expect(
          CalendarDismissBehavior.onActionTap.hasOutsideTapDismiss,
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

      test('is true for onOutsideTapOrDateSelect', () {
        expect(
          CalendarDismissBehavior.onOutsideTapOrDateSelect.hasDateSelectDismiss,
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
