// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CupertinoCalendarMode', () {
    test('exposes date and dateTime values', () {
      const List<CupertinoCalendarMode> values = CupertinoCalendarMode.values;

      expect(values, contains(CupertinoCalendarMode.date));
      expect(values, contains(CupertinoCalendarMode.dateTime));
      expect(values.length, 2);
    });

    test('values are distinct', () {
      expect(
        CupertinoCalendarMode.date,
        isNot(CupertinoCalendarMode.dateTime),
      );
    });
  });
}
