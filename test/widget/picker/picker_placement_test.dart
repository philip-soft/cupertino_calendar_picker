// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/picker_screens.dart';

const double _epsilon = 0.01;

/// A picker button type with the widget displayed in its overlay.
class _PickerCase {
  const _PickerCase({
    required this.name,
    required this.button,
    required this.content,
    required this.size,
  });

  final String name;
  final Widget button;
  final Type content;
  final Size size;
}

final List<_PickerCase> _pickerCases = <_PickerCase>[
  _PickerCase(
    name: 'calendar',
    button: CupertinoCalendarPickerButton(
      minimumDateTime: DateTime(2026),
      maximumDateTime: DateTime(2026, 12, 31),
      initialDateTime: DateTime(2026, 6, 15),
    ),
    content: CupertinoCalendar,
    size: const Size(calendarWidth, calendarDatePickerHeight),
  ),
  const _PickerCase(
    name: 'time picker',
    button: CupertinoTimePickerButton(
      initialTime: TimeOfDay(hour: 9, minute: 41),
    ),
    content: CupertinoTimePicker,
    size: Size(timePickerWidth, timePickerHeight),
  ),
];

Widget _page({required Alignment alignment, required Widget button}) {
  return CupertinoApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TestScreen.anchorMargin),
          child: Align(alignment: alignment, child: button),
        ),
      ),
    ),
  );
}

void _expectRect(Rect actual, Rect expected) {
  expect(actual.left, closeTo(expected.left, _epsilon));
  expect(actual.top, closeTo(expected.top, _epsilon));
  expect(actual.right, closeTo(expected.right, _epsilon));
  expect(actual.bottom, closeTo(expected.bottom, _epsilon));
}

void main() {
  for (final TestScreen screen in testScreens) {
    for (final _PickerCase picker in _pickerCases) {
      group('The ${picker.name} on ${screen.name}', () {
        for (final MapEntry<String, Alignment> position
            in anchorPositions.entries) {
          testWidgets('opens next to a button at the ${position.key}', (
            WidgetTester tester,
          ) async {
            // Arrange
            setTestScreen(tester, screen);
            await tester.pumpWidget(
              _page(alignment: position.value, button: picker.button),
            );
            final Finder button = find.byWidget(picker.button);
            final Rect anchor = tester.getRect(button);

            // Act
            await tester.tap(button);
            await tester.pumpAndSettle();

            // Assert
            final Rect actual = tester.getRect(find.byType(picker.content));
            _expectRect(
              actual,
              expectedPickerRect(screen, anchor, picker.size),
            );
            expect(
              screen.pickerArea.inflate(_epsilon).contains(actual.topLeft) &&
                  screen.pickerArea
                      .inflate(_epsilon)
                      .contains(actual.bottomRight),
              isTrue,
              reason: '$actual is outside of ${screen.pickerArea}',
            );
          });
        }
      });
    }
  }
}
