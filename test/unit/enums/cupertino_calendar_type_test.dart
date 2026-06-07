// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CupertinoCalendarType', () {
    test('exposes compact and inline values', () {
      const List<CupertinoCalendarType> values = CupertinoCalendarType.values;

      expect(values, contains(CupertinoCalendarType.compact));
      expect(values, contains(CupertinoCalendarType.inline));
      expect(values.length, 2);
    });

    test('values are distinct', () {
      expect(
        CupertinoCalendarType.compact,
        isNot(CupertinoCalendarType.inline),
      );
    });
  });
}
