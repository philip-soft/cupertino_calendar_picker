// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

import 'support/golden_harness.dart';

void main() {
  // Fixed dates keep the rendered output deterministic across runs/machines.
  final DateTime minimum = DateTime.utc(2020);
  final DateTime maximum = DateTime.utc(2030, 12, 31);
  final DateTime fixedDate = DateTime.utc(2024, 6, 15);

  const List<CupertinoCalendarAction> actions = <CupertinoCalendarAction>[
    CancelCupertinoCalendarAction(),
    ConfirmCupertinoCalendarAction(),
  ];

  Widget buildCalendar({
    CupertinoCalendarMode mode = CupertinoCalendarMode.date,
  }) {
    return SizedBox(
      width: calendarWidth,
      child: CupertinoCalendar(
        minimumDateTime: minimum,
        maximumDateTime: maximum,
        initialDateTime: fixedDate,
        currentDateTime: fixedDate,
        firstDayOfWeekIndex: 0,
        type: CupertinoCalendarType.compact,
        mode: mode,
        actions: actions,
      ),
    );
  }

  /// Displays [child] in an open picker container above a striped backdrop,
  /// so that the blur and the translucency of the container are visible.
  Widget buildOverlay(
    Brightness brightness,
    PickerContainerDecoration decoration,
  ) {
    const double height = calendarDatePickerHeight + calendarActionsHeight;
    return goldenApp(
      brightness: brightness,
      child: SizedBox(
        width: calendarWidth + 40.0,
        height: height + 40.0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const Positioned.fill(child: _StripedBackdrop()),
            CupertinoPickerContainer(
              animation: kAlwaysCompleteAnimation,
              decoration: decoration,
              scaleAlignment: Alignment.center,
              maxScale: 1.0,
              height: height,
              width: calendarWidth,
              child: buildCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  goldenTest(
    'CupertinoCalendar compact renders date mode with actions',
    fileName: 'cupertino_calendar_compact_actions',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          goldenApp(brightness: brightness, child: buildCalendar()),
    ),
  );

  goldenTest(
    'CupertinoCalendar compact renders dateTime mode with actions',
    fileName: 'cupertino_calendar_compact_date_time_actions',
    builder: () => lightDarkGroup(
      (Brightness brightness) => goldenApp(
        brightness: brightness,
        child: buildCalendar(mode: CupertinoCalendarMode.dateTime),
      ),
    ),
  );

  goldenTest(
    'CupertinoPickerContainer renders the blurred background',
    fileName: 'cupertino_picker_container_blurred',
    builder: () => lightDarkGroup(
      (Brightness brightness) =>
          buildOverlay(brightness, PickerContainerDecoration()),
    ),
  );

  goldenTest(
    'CupertinoPickerContainer renders the plain background',
    fileName: 'cupertino_picker_container_plain',
    builder: () => lightDarkGroup(
      (Brightness brightness) => buildOverlay(
        brightness,
        PickerContainerDecoration(
          backgroundType: PickerBackgroundType.plainColor,
        ),
      ),
    ),
  );
}

class _StripedBackdrop extends StatelessWidget {
  const _StripedBackdrop();

  static const List<Color> _colors = <Color>[
    Color(0xFF0A84FF),
    Color(0xFF30D158),
    Color(0xFFFFD60A),
    Color(0xFFFF453A),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final Color color in _colors)
          Expanded(child: ColoredBox(color: color)),
      ],
    );
  }
}
