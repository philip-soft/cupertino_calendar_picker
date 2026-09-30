// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PickerBackgroundType', () {
    // The value set and its order are part of the published API: renaming a
    // value breaks `switch` statements downstream, and reordering shifts the
    // `index` that consumers may have persisted.
    test('declares the documented values in order', () {
      expect(
        PickerBackgroundType.values.map(
          (PickerBackgroundType value) => value.name,
        ),
        <String>['plainColor', 'transparentAndBlurred'],
      );
    });
  });
}
