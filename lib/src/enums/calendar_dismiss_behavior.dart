// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// An enum that represents how the calendar can be closed.
///
/// Regardless of the behavior, the calendar is always closed by its actions
/// and by the system back gesture.
enum CalendarDismissBehavior {
  /// The calendar closes on a tap outside of it.
  onOutsideTap,

  /// The calendar closes when a date is selected.
  onDateSelect,

  /// The calendar closes on a tap outside of it or when a date is selected.
  onOutsideTapOrDateSelect,

  /// The calendar closes on an action tap only.
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
