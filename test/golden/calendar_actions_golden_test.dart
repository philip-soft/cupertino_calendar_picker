// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

import 'support/golden_harness.dart';

void main() {
  const List<CupertinoCalendarAction> cancelConfirmActions =
      <CupertinoCalendarAction>[
        CancelCupertinoCalendarAction(),
        ConfirmCupertinoCalendarAction(),
      ];

  const List<CupertinoCalendarAction> confirmOnly = <CupertinoCalendarAction>[
    ConfirmCupertinoCalendarAction(),
  ];

  Widget buildScenario(
    Brightness brightness, {
    required List<CupertinoCalendarAction> actions,
  }) {
    return goldenApp(
      brightness: brightness,
      child: SizedBox(
        width: 320.0,
        child: CalendarActions(actions: actions, onPressed: (_) {}),
      ),
    );
  }

  goldenTest(
    'CalendarActions renders cancel and confirm buttons in light and dark themes',
    fileName: 'calendar_actions',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildScenario(brightness, actions: cancelConfirmActions),
    ),
  );

  goldenTest(
    'CalendarActions renders single confirm button in light and dark themes',
    fileName: 'calendar_actions_confirm_only',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildScenario(brightness, actions: confirmOnly),
    ),
  );
}
