// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CupertinoCalendarViewMode', () {
    test('exposes monthPicker, yearPicker and timePicker values', () {
      const List<CupertinoCalendarViewMode> values =
          CupertinoCalendarViewMode.values;

      expect(values, contains(CupertinoCalendarViewMode.monthPicker));
      expect(values, contains(CupertinoCalendarViewMode.yearPicker));
      expect(values, contains(CupertinoCalendarViewMode.timePicker));
      expect(values.length, 3);
    });

    test('values are distinct from each other', () {
      expect(
        CupertinoCalendarViewMode.monthPicker,
        isNot(CupertinoCalendarViewMode.yearPicker),
      );
      expect(
        CupertinoCalendarViewMode.yearPicker,
        isNot(CupertinoCalendarViewMode.timePicker),
      );
      expect(
        CupertinoCalendarViewMode.monthPicker,
        isNot(CupertinoCalendarViewMode.timePicker),
      );
    });
  });
}
