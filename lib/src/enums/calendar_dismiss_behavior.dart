/// A enum that represents how the calendar can be closed.
enum CalendarDismissBehavior {
  /// The calendar will close when a tap occurs outside of it.
  onOutsideTap,

  /// The calendar will close when a date is selected.
  onDateSelect,

  /// The calendar will close when either a tap occurs outside of it or a date is selected.
  onOusideTapOrDateSelect;

  /// This is `true` if the behavior is either [CalendarDismissBehavior.onOutsideTap]
  /// or [CalendarDismissBehavior.onOusideTapOrDateSelect].
  bool get hasOusideTapDismiss {
    return this == CalendarDismissBehavior.onOutsideTap ||
        this == CalendarDismissBehavior.onOusideTapOrDateSelect;
  }

  /// This is `true` if the behavior is either [CalendarDismissBehavior.onDateSelect]
  /// or [CalendarDismissBehavior.onOusideTapOrDateSelect].
  bool get hasDateSelectDismiss {
    return this == CalendarDismissBehavior.onDateSelect ||
        this == CalendarDismissBehavior.onOusideTapOrDateSelect;
  }
}
