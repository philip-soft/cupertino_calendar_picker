// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show GlobalMaterialLocalizations, TimeOfDay;

import '../support/picker_screens.dart';

final DateTime _minimum = DateTime(2026);
final DateTime _maximum = DateTime(2026, 12, 31);
final DateTime _selected = DateTime(2026, 6, 15, 9, 40);
final DateTime _today = DateTime(2026, 6, 10);

TestScreen _screenNamed(String name) {
  return testScreens.firstWhere((TestScreen screen) => screen.name == name);
}

Widget _calendarButton({
  CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  List<CupertinoCalendarAction>? actions,
}) {
  return CupertinoCalendarPickerButton(
    minimumDateTime: _minimum,
    maximumDateTime: _maximum,
    initialDateTime: _selected,
    currentDateTime: _today,
    mode: mode,
    use24hFormat: false,
    actions: actions,
    // Each scenario is an app of its own, inside of the golden's app.
    useRootNavigator: false,
  );
}

const Widget _timeButton = CupertinoTimePickerButton(
  initialTime: TimeOfDay(hour: 9, minute: 40),
  use24hFormat: false,
  useRootNavigator: false,
);

/// Renders [button] at [alignment] on [screen], with the unsafe areas
/// highlighted.
Widget _screen(TestScreen screen, Alignment alignment, Widget button) {
  final EdgeInsets padding = screen.padding;

  return MediaQuery(
    data: MediaQueryData(
      size: screen.size,
      padding: padding,
      viewPadding: padding,
    ),
    child: SizedBox.fromSize(
      size: screen.size,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(brightness: Brightness.light),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      left: _unsafeArea(padding.left),
                      top: _unsafeArea(padding.top),
                      right: _unsafeArea(padding.right),
                      bottom: _unsafeArea(padding.bottom),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(TestScreen.anchorMargin),
                  child: Align(alignment: alignment, child: button),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

BorderSide _unsafeArea(double width) {
  return width == 0.0
      ? BorderSide.none
      : BorderSide(color: CupertinoColors.systemGrey3, width: width);
}

/// Opens the picker of every button in the golden.
Future<void> _openPickers(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final Finder buttons = find.byWidgetPredicate(
    (Widget widget) =>
        widget is CupertinoCalendarPickerButton ||
        widget is CupertinoTimePickerButton,
  );
  final int count = buttons.evaluate().length;
  for (int index = 0; index < count; index++) {
    await tester.tap(buttons.at(index));
    await tester.pumpAndSettle();
  }
}

void main() {
  goldenTest(
    'Pickers open next to buttons at different positions on a phone',
    fileName: 'picker_placement_phone',
    pumpBeforeTest: _openPickers,
    builder: () {
      final TestScreen phone = _screenNamed('phone');
      return GoldenTestGroup(
        columns: 4,
        children: <Widget>[
          GoldenTestScenario(
            name: 'calendar, top left',
            child: _screen(phone, Alignment.topLeft, _calendarButton()),
          ),
          GoldenTestScenario(
            name: 'dateTime calendar with actions, bottom right',
            child: _screen(
              phone,
              Alignment.bottomRight,
              _calendarButton(
                mode: CupertinoCalendarMode.dateTime,
                actions: const <CupertinoCalendarAction>[
                  CancelCupertinoCalendarAction(),
                  ConfirmCupertinoCalendarAction(),
                ],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'time picker, center',
            child: _screen(phone, Alignment.center, _timeButton),
          ),
          GoldenTestScenario(
            name: 'calendar, top right',
            child: _screen(phone, Alignment.topRight, _calendarButton()),
          ),
        ],
      );
    },
  );

  goldenTest(
    'Pickers fit on small screens',
    fileName: 'picker_placement_small_screens',
    pumpBeforeTest: _openPickers,
    builder: () {
      return GoldenTestGroup(
        columns: 3,
        children: <Widget>[
          GoldenTestScenario(
            name: 'small phone, top right',
            child: _screen(
              _screenNamed('small phone'),
              Alignment.topRight,
              _calendarButton(),
            ),
          ),
          GoldenTestScenario(
            name: 'landscape phone, top left',
            child: _screen(
              _screenNamed('landscape phone'),
              Alignment.topLeft,
              _calendarButton(),
            ),
          ),
          GoldenTestScenario(
            name: 'landscape phone, center',
            child: _screen(
              _screenNamed('landscape phone'),
              Alignment.center,
              _calendarButton(),
            ),
          ),
        ],
      );
    },
  );
}
