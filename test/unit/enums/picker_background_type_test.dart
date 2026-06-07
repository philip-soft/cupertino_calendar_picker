// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PickerBackgroundType', () {
    test('exposes plainColor and transparentAndBlured values', () {
      const List<PickerBackgroundType> values = PickerBackgroundType.values;

      expect(values, contains(PickerBackgroundType.plainColor));
      expect(values, contains(PickerBackgroundType.transparentAndBlured));
      expect(values.length, 2);
    });

    test('values are distinct', () {
      expect(
        PickerBackgroundType.plainColor,
        isNot(PickerBackgroundType.transparentAndBlured),
      );
    });
  });
}
