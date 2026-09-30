// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// An enum that represents how the calendar can be closed.
///
/// Regardless of the behavior, the calendar is always closed by its actions
/// and by the system back gesture.
enum CalendarDismissBehavior {
  /// The calendar will close when a tap occurs outside of it or on the action button.
  onOutsideTap,

  /// The calendar will close when a date is selected or on the action button.
  onDateSelect,

  /// The calendar will close when either a tap occurs outside of it or a date
  /// is selected or on the action button.
  onOutsideTapOrDateSelect,

  /// The calendar will close when a tap occurs on the action button only.
  ///
  /// Requires at least one action to be provided.
  onActionTap;

  /// This is `true` if the behavior is either [CalendarDismissBehavior.onOutsideTap]
  /// or [CalendarDismissBehavior.onOutsideTapOrDateSelect].
  bool get hasOutsideTapDismiss {
    return this == CalendarDismissBehavior.onOutsideTap ||
        this == CalendarDismissBehavior.onOutsideTapOrDateSelect;
  }

  /// This is `true` if the behavior is either [CalendarDismissBehavior.onDateSelect]
  /// or [CalendarDismissBehavior.onOutsideTapOrDateSelect].
  bool get hasDateSelectDismiss {
    return this == CalendarDismissBehavior.onDateSelect ||
        this == CalendarDismissBehavior.onOutsideTapOrDateSelect;
  }
}
