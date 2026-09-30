// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

class CalendarActions extends StatelessWidget {
  const CalendarActions({
    required this.onPressed,
    required this.actions,
    super.key,
  });

  final List<CupertinoCalendarAction> actions;
  final CalendarActionCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: calendarActionsHeight,
      child: Row(
        children: <Widget>[
          for (final (int index, CupertinoCalendarAction action)
              in actions.indexed) ...<Widget>[
            if (index > 0) const CupertinoPickerVerticalDivider(),
            CupertinoCalendarActionWidget(action: action, onPressed: onPressed),
          ],
        ],
      ),
    );
  }
}
