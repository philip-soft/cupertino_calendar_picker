// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

class CalendarActions extends StatelessWidget {
  const CalendarActions({
    required this.onPressed,
    this.actions,
    super.key,
  });

  final List<CupertinoCalendarAction>? actions;
  final CalendarActionCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: calendarActionsHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          for (final CupertinoCalendarAction action in actions!) ...<Widget>[
            CupertinoCalendarActionWidget(
              action: action,
              onPressed: onPressed,
            ),
            if (action != actions!.last) const CupertinoPickerVerticalDivider(),
          ],
        ],
      ),
    );
  }
}
