// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/picker_screens.dart';

const Size _calendarSize = Size(calendarWidth, calendarDatePickerHeight);

final TestScreen _phone = testScreens.firstWhere(
  (TestScreen screen) => screen.name == 'phone',
);
final TestScreen _landscapePhone = testScreens.firstWhere(
  (TestScreen screen) => screen.name == 'landscape phone',
);

Widget _page({required Widget child}) {
  return CupertinoApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TestScreen.anchorMargin),
          child: child,
        ),
      ),
    ),
  );
}

Widget _calendarButton() {
  return CupertinoCalendarPickerButton(
    minimumDateTime: DateTime(2026),
    maximumDateTime: DateTime(2026, 12, 31),
    initialDateTime: DateTime(2026, 6, 15),
  );
}

Rect _calendarRect(WidgetTester tester) {
  return tester.getRect(find.byType(CupertinoCalendar));
}

void _expectRect(Rect actual, Rect expected) {
  const double epsilon = 0.01;
  expect(actual.left, closeTo(expected.left, epsilon));
  expect(actual.top, closeTo(expected.top, epsilon));
  expect(actual.right, closeTo(expected.right, epsilon));
  expect(actual.bottom, closeTo(expected.bottom, epsilon));
}

void main() {
  testWidgets('hides the keyboard of a focused text field when opening', (
    WidgetTester tester,
  ) async {
    // Arrange
    setTestScreen(tester, _phone);
    await tester.pumpWidget(
      _page(
        child: Column(
          children: <Widget>[
            const CupertinoTextField(),
            const Spacer(),
            _calendarButton(),
          ],
        ),
      ),
    );
    await tester.showKeyboard(find.byType(CupertinoTextField));
    expect(tester.testTextInput.isVisible, isTrue);

    // Act
    await tester.tap(find.byType(CupertinoCalendarPickerButton));
    await tester.pumpAndSettle();

    // Assert
    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.byType(CupertinoCalendar), findsOneWidget);
  });

  testWidgets('keeps its position when the button is removed while open', (
    WidgetTester tester,
  ) async {
    // Arrange
    setTestScreen(tester, _phone);
    final ValueNotifier<bool> isButtonVisible = ValueNotifier<bool>(true);
    addTearDown(isButtonVisible.dispose);
    await tester.pumpWidget(
      _page(
        child: Align(
          alignment: Alignment.bottomRight,
          child: ValueListenableBuilder<bool>(
            valueListenable: isButtonVisible,
            builder: (BuildContext context, bool isVisible, Widget? _) {
              return isVisible ? _calendarButton() : const SizedBox();
            },
          ),
        ),
      ),
    );
    await tester.tap(find.byType(CupertinoCalendarPickerButton));
    await tester.pumpAndSettle();
    final Rect openedRect = _calendarRect(tester);

    // Act
    isButtonVisible.value = false;
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(CupertinoCalendarPickerButton), findsNothing);
    _expectRect(_calendarRect(tester), openedRect);
    expect(tester.takeException(), isNull);
  });

  testWidgets('follows the button when the screen rotates while open', (
    WidgetTester tester,
  ) async {
    // Arrange
    setTestScreen(tester, _phone);
    await tester.pumpWidget(
      _page(
        child: Align(
          alignment: Alignment.bottomRight,
          child: _calendarButton(),
        ),
      ),
    );
    final Finder button = find.byType(CupertinoCalendarPickerButton);
    await tester.tap(button);
    await tester.pumpAndSettle();

    // Act
    setTestScreen(tester, _landscapePhone);
    await tester.pumpAndSettle();

    // Assert
    _expectRect(
      _calendarRect(tester),
      expectedPickerRect(
        _landscapePhone,
        tester.getRect(button),
        _calendarSize,
      ),
    );
  });

  testWidgets('is centered when opened without a render box', (
    WidgetTester tester,
  ) async {
    // Arrange
    setTestScreen(tester, _phone);
    await tester.pumpWidget(
      _page(
        child: Builder(
          builder: (BuildContext context) {
            return CupertinoButton(
              onPressed: () => showCupertinoCalendarPicker(
                context,
                minimumDateTime: DateTime(2026),
                maximumDateTime: DateTime(2026, 12, 31),
                initialDateTime: DateTime(2026, 6, 15),
              ),
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Assert
    _expectRect(
      _calendarRect(tester),
      expectedPickerRect(_phone, null, _calendarSize),
    );
  });
}
