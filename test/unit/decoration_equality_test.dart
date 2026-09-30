// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const TextStyle _otherStyle = TextStyle(fontSize: 99.0);
const Color _otherColor = Color(0xFF123456);

/// Builds a decoration with default values and one with a changed field.
typedef _Variants = (Object Function() create, Object changed);

final Map<String, _Variants> _decorations = <String, _Variants>{
  'CalendarActionDecoration': (
    CalendarActionDecoration.new,
    CalendarActionDecoration(pressedColor: _otherColor),
  ),
  'CalendarFooterDecoration': (
    CalendarFooterDecoration.new,
    CalendarFooterDecoration(timeStyle: _otherStyle),
  ),
  'CalendarWeekdayDecoration': (
    CalendarWeekdayDecoration.new,
    CalendarWeekdayDecoration(textStyle: _otherStyle),
  ),
  'PickerButtonDecoration': (
    PickerButtonDecoration.new,
    PickerButtonDecoration(backgroundColor: _otherColor),
  ),
  'PickerContainerDecoration': (
    PickerContainerDecoration.new,
    PickerContainerDecoration(boxShadow: const <BoxShadow>[BoxShadow()]),
  ),
  'CalendarMonthPickerSelectedDayStyle': (
    CalendarMonthPickerSelectedDayStyle.new,
    CalendarMonthPickerSelectedDayStyle(backgroundCircleColor: _otherColor),
  ),
};

void main() {
  group('Decoration equality', () {
    for (final MapEntry<String, _Variants> entry in _decorations.entries) {
      final (Object Function() create, Object changed) = entry.value;

      test('${entry.key} instances with equal fields are equal', () {
        final Object a = create();
        final Object b = create();

        expect(identical(a, b), isFalse);
        expect(a, b);
        expect(a.hashCode, b.hashCode);
      });

      test('${entry.key} instances with a different field are not equal', () {
        expect(create(), isNot(changed));
      });
    }
  });
}
