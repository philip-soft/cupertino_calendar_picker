// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// The base class for the actions displayed at the bottom of a compact
/// [CupertinoCalendar].
///
/// Only [CancelCupertinoCalendarAction] and [ConfirmCupertinoCalendarAction]
/// are available.
sealed class CupertinoCalendarAction {
  const CupertinoCalendarAction({
    required this.isDefaultAction,
    this.label,
    this.decoration,
  });

  /// The text displayed on the action button.
  ///
  /// When `null`, a localized default label is used.
  final String? label;

  /// The decoration of the action button.
  final CalendarActionDecoration? decoration;

  /// Whether the action is emphasized as the default one.
  final bool isDefaultAction;

  /// Returns [label] or the localized default label of the action.
  String effectiveLabel(BuildContext context);

  bool _hasSameFields(CupertinoCalendarAction other) {
    return other.runtimeType == runtimeType &&
        other.label == label &&
        other.decoration == decoration &&
        other.isDefaultAction == isDefaultAction;
  }
}

/// A class representing a cancel action.
///
/// Pressing the action calls [onPressed] and closes the calendar overlay
/// without a result.
///
/// See also:
/// - [CupertinoCalendarAction], the base class for calendar actions.
final class CancelCupertinoCalendarAction extends CupertinoCalendarAction {
  /// Creates a cancel action class.
  const CancelCupertinoCalendarAction({
    super.label,
    super.decoration,
    super.isDefaultAction = false,
    this.onPressed,
  });

  /// Called when the action is pressed.
  final VoidCallback? onPressed;

  /// Returns [label] or the localized "Cancel" label.
  @override
  String effectiveLabel(BuildContext context) {
    return label ?? CupertinoLocalizations.of(context).cancelButtonLabel;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CancelCupertinoCalendarAction &&
        _hasSameFields(other) &&
        other.onPressed == onPressed;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      label,
      decoration,
      isDefaultAction,
      onPressed,
    );
  }
}

/// A class representing a confirm action.
///
/// Pressing the action calls [onPressed] with the selected date and closes
/// the calendar overlay with that date as the result.
///
/// See also:
/// - [CupertinoCalendarAction], the base class for calendar actions.
final class ConfirmCupertinoCalendarAction extends CupertinoCalendarAction {
  /// Creates a confirm action class.
  const ConfirmCupertinoCalendarAction({
    super.label,
    super.decoration,
    super.isDefaultAction = true,
    this.onPressed,
  });

  /// Called with the selected date when the action is pressed.
  final ValueChanged<DateTime>? onPressed;

  /// Returns [label] or the localized "OK" label.
  @override
  String effectiveLabel(BuildContext context) {
    return label ?? MaterialLocalizations.of(context).okButtonLabel;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConfirmCupertinoCalendarAction &&
        _hasSameFields(other) &&
        other.onPressed == onPressed;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      label,
      decoration,
      isDefaultAction,
      onPressed,
    );
  }
}

extension CupertinoCalendarActionList on List<CupertinoCalendarAction>? {
  /// Whether a selection only counts once a [ConfirmCupertinoCalendarAction]
  /// is pressed.
  bool get requiresConfirmation {
    return this?.any(
          (CupertinoCalendarAction action) =>
              action is ConfirmCupertinoCalendarAction,
        ) ??
        false;
  }
}
