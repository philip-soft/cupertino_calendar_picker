// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

sealed class CupertinoCalendarAction {
  const CupertinoCalendarAction({
    required this.label,
    this.decoration,
    this.isDefaultAction = false,
    this.onPressed,
  });

  final String label;
  final CalendarActionDecoration? decoration;
  final bool isDefaultAction;
  final Function? onPressed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CupertinoCalendarAction &&
        other.label == label &&
        other.decoration == decoration &&
        other.isDefaultAction == isDefaultAction &&
        other.onPressed == onPressed;
  }

  @override
  int get hashCode {
    return label.hashCode ^
        decoration.hashCode ^
        isDefaultAction.hashCode ^
        onPressed.hashCode;
  }
}

/// A class representing a cancel action.
///
/// The [CancelCupertinoCalendarAction] class extends [CupertinoCalendarAction]
/// and provides default values for properties.
///
/// See also:
/// - [CupertinoCalendarAction], the base class for calendar actions.
final class CancelCupertinoCalendarAction extends CupertinoCalendarAction {
  /// Creates a cancel action class.
  const CancelCupertinoCalendarAction({
    super.label = 'Cancel',
    super.decoration,
    super.isDefaultAction = false,
    super.onPressed,
  });
}

/// A class representing a confirm action.
///
/// The [ConfirmCupertinoCalendarAction] class extends [CupertinoCalendarAction]
/// and provides default values for properties.
///
/// See also:
/// - [CupertinoCalendarAction], the base class for calendar actions.
final class ConfirmCupertinoCalendarAction extends CupertinoCalendarAction {
  /// Creates a confirm action class.
  const ConfirmCupertinoCalendarAction({
    super.label = 'Done',
    super.decoration,
    super.isDefaultAction = true,
    ValueChanged<DateTime>? onPressed,
  }) : super(onPressed: onPressed);
}
