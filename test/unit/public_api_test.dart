// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

// Only the public library is imported on purpose: every type used below must
// be nameable by package consumers.
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('public API', () {
    test('exposes CupertinoCalendarAction as a nameable type', () {
      const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
      ];

      expect(actions, hasLength(2));
    });

    test('exposes CalendarButtonFormatter as a nameable type', () {
      String format(DateTime dateTime) => '${dateTime.year}';
      const CalendarButtonFormatter Function(CalendarButtonFormatter) identity =
          _identity;

      expect(identity(format)(DateTime(2026)), '2026');
    });

    test('Cancel action exposes a typed VoidCallback', () {
      int calls = 0;
      final CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction(onPressed: () => calls++);

      final VoidCallbackType? callback = action.onPressed;
      callback?.call();

      expect(calls, 1);
    });

    test('Confirm action exposes a typed ValueChanged<DateTime>', () {
      DateTime? confirmed;
      final ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction(
            onPressed: (DateTime value) => confirmed = value,
          );

      final void Function(DateTime)? callback = action.onPressed;
      callback?.call(DateTime(2026, 9, 30));

      expect(confirmed, DateTime(2026, 9, 30));
    });

    test('dismiss behaviors are spelled correctly', () {
      expect(
        CalendarDismissBehavior.onOutsideTapOrDateSelect.hasOutsideTapDismiss,
        isTrue,
      );
      expect(PickerBackgroundType.transparentAndBlurred, isNotNull);
    });
  });
}

typedef VoidCallbackType = void Function();

CalendarButtonFormatter _identity(CalendarButtonFormatter formatter) =>
    formatter;
