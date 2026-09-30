// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// The calendar's layout: header, weekdays, month pages, the inner
/// year/time pickers, the footer and the actions.
///
/// The selection is owned by the parent: every change is reported through the
/// callbacks and displayed once the parent passes a new [selectedDateTime].
class CupertinoCalendarPicker extends StatefulWidget {
  const CupertinoCalendarPicker({
    required this.initialMonth,
    required this.currentDateTime,
    required this.minimumDateTime,
    required this.maximumDateTime,
    required this.selectedDateTime,
    required this.selectableDayPredicate,
    required this.firstDayOfWeekIndex,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onDisplayedMonthChanged,
    required this.onYearPickerChanged,
    required this.weekdayDecoration,
    required this.monthPickerDecoration,
    required this.headerDecoration,
    required this.mainColor,
    required this.mode,
    required this.type,
    required this.timeLabel,
    required this.footerDecoration,
    required this.minuteInterval,
    required this.use24hFormat,
    required this.actions,
    super.key,
  });

  final DateTime initialMonth;
  final DateTime currentDateTime;
  final DateTime minimumDateTime;
  final DateTime maximumDateTime;
  final DateTime selectedDateTime;
  final SelectableDayPredicate? selectableDayPredicate;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onTimeChanged;
  final ValueChanged<DateTime> onDisplayedMonthChanged;
  final ValueChanged<DateTime> onYearPickerChanged;
  final CalendarWeekdayDecoration weekdayDecoration;
  final CalendarMonthPickerDecoration monthPickerDecoration;
  final CalendarHeaderDecoration headerDecoration;
  final CalendarFooterDecoration footerDecoration;
  final Color mainColor;
  final CupertinoCalendarMode mode;
  final CupertinoCalendarType type;
  final String? timeLabel;
  final int minuteInterval;
  final bool use24hFormat;
  final int? firstDayOfWeekIndex;
  final List<CupertinoCalendarAction>? actions;

  @override
  CupertinoCalendarPickerState createState() => CupertinoCalendarPickerState();
}

class CupertinoCalendarPickerState extends State<CupertinoCalendarPicker> {
  late DateTime _currentMonth;
  late PageController _monthPageController;
  final GlobalKey<CustomCupertinoDatePickerDateTimeState> _timePickerKey =
      GlobalKey<CustomCupertinoDatePickerDateTimeState>();
  CupertinoCalendarViewMode _viewMode = CupertinoCalendarViewMode.monthPicker;

  @visibleForTesting
  CupertinoCalendarViewMode get viewMode => _viewMode;

  DateTime get _minimumMonth =>
      PackageDateUtils.monthDateOnly(widget.minimumDateTime);

  DateTime get _maximumMonth =>
      PackageDateUtils.monthDateOnly(widget.maximumDateTime);

  @override
  void initState() {
    super.initState();
    _currentMonth = _clampMonth(widget.initialMonth);
    _monthPageController = PageController(initialPage: _pageOf(_currentMonth));
  }

  @override
  void didUpdateWidget(CupertinoCalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isRangeChanged =
        !DateUtils.isSameMonth(
          oldWidget.minimumDateTime,
          widget.minimumDateTime,
        ) ||
        !DateUtils.isSameMonth(
          oldWidget.maximumDateTime,
          widget.maximumDateTime,
        );
    if (isRangeChanged) _resetMonthPages();

    final DateTime initialMonth = widget.initialMonth;
    if (initialMonth != oldWidget.initialMonth &&
        !DateUtils.isSameMonth(initialMonth, _currentMonth)) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) showMonth(widget.initialMonth, jump: true);
      });
    }
  }

  @override
  void dispose() {
    _monthPageController.dispose();
    super.dispose();
  }

  /// Recreates the page controller, since page indices are relative to
  /// the minimum month and the month pages are rebuilt with a new key.
  void _resetMonthPages() {
    final PageController oldController = _monthPageController;
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration _) => oldController.dispose(),
    );

    final DateTime month = _clampMonth(_currentMonth);
    _monthPageController = PageController(initialPage: _pageOf(month));
    if (!DateUtils.isSameMonth(month, _currentMonth)) {
      _currentMonth = month;
      // Listeners may call setState, which is not allowed during this build.
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) widget.onDisplayedMonthChanged(month);
      });
    }
  }

  DateTime _clampMonth(DateTime month) {
    return PackageDateUtils.monthDateOnly(month)
        .clampTo(_minimumMonth, _maximumMonth);
  }

  int _pageOf(DateTime month) {
    final int lastPage = DateUtils.monthDelta(_minimumMonth, _maximumMonth);
    return DateUtils.monthDelta(_minimumMonth, month).clamp(0, lastPage);
  }

  bool get _isDisplayingFirstMonth => !_currentMonth.isAfter(_minimumMonth);

  bool get _isDisplayingLastMonth => !_currentMonth.isBefore(_maximumMonth);

  void _handleMonthPageChanged(int monthPage) {
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(
      _minimumMonth,
      monthPage,
    );
    if (DateUtils.isSameMonth(_currentMonth, monthDate)) return;

    setState(() => _currentMonth = monthDate);
    widget.onDisplayedMonthChanged(monthDate);
  }

  void _handleNextMonth() {
    if (_isDisplayingLastMonth) return;
    _monthPageController.nextPage(
      duration: monthScrollDuration,
      curve: Curves.ease,
    );
  }

  void _handlePreviousMonth() {
    if (_isDisplayingFirstMonth) return;
    _monthPageController.previousPage(
      duration: monthScrollDuration,
      curve: Curves.ease,
    );
  }

  @visibleForTesting
  void showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = _pageOf(month);
    if (jump) {
      _monthPageController.jumpToPage(monthPage);
    } else {
      _monthPageController.animateToPage(
        monthPage,
        duration: monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _toggleViewMode(CupertinoCalendarViewMode mode, bool isVisible) {
    setState(() {
      _viewMode = isVisible ? mode : CupertinoCalendarViewMode.monthPicker;
    });
  }

  void _onMonthDateChanged(DateTime date) {
    widget.onDateChanged(
      widget.selectedDateTime.copyWith(
        year: date.year,
        month: date.month,
        day: date.day,
      ),
    );
  }

  void _onTimeChanged(DateTime dateTime) {
    widget.onTimeChanged(
      widget.selectedDateTime.copyWith(
        hour: dateTime.hour,
        minute: dateTime.minute,
      ),
    );
  }

  /// Switches the selected time to [newTime]'s day period, limited to
  /// the allowed range.
  @visibleForTesting
  void onDayPeriodChanged(TimeOfDay newTime) {
    final DateTime selected = widget.selectedDateTime;
    final DateTime minimum = widget.minimumDateTime.truncateToMinutes();
    final DateTime newDateTime = selected
        .copyWith(hour: newTime.hour, minute: newTime.minute)
        .clampTo(minimum, widget.maximumDateTime.truncateToMinutes());

    _timePickerKey.currentState?.scrollToDate(
      newDateTime,
      selected,
      newDateTime == minimum,
    );
    widget.onTimeChanged(newDateTime);
  }

  void _onActionPressed(CupertinoCalendarAction action) {
    final CupertinoPickerOverlayScope? overlay =
        CupertinoPickerOverlayScope.maybeOf(context);
    final DateTime selected = widget.selectedDateTime;

    switch (action) {
      case ConfirmCupertinoCalendarAction(
        :final ValueChanged<DateTime>? onPressed,
      ):
        onPressed?.call(selected);
        overlay?.close(selected);
      case CancelCupertinoCalendarAction(:final VoidCallback? onPressed):
        onPressed?.call();
        overlay?.close(null);
    }
  }

  Widget _buildInnerPicker() {
    return switch (_viewMode) {
      CupertinoCalendarViewMode.yearPicker => CustomCupertinoDatePicker(
        minimumDate: _minimumMonth,
        maximumDate: _maximumMonth,
        mode: CupertinoDatePickerMode.monthYear,
        onDateTimeChanged: widget.onYearPickerChanged,
        initialDateTime: _currentMonth,
      ),
      CupertinoCalendarViewMode.timePicker => CupertinoTimePickerWheel(
        pickerKey: _timePickerKey,
        onTimeChanged: _onTimeChanged,
        minimumDateTime: widget.minimumDateTime.truncateToMinutes(),
        maximumDateTime: widget.maximumDateTime.truncateToMinutes(),
        initialDateTime: widget.selectedDateTime.truncateToMinutes(),
        minuteInterval: widget.minuteInterval,
        use24hFormat: widget.use24hFormat,
      ),
      CupertinoCalendarViewMode.monthPicker => const SizedBox(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<CupertinoCalendarAction>? actions = widget.actions;
    final bool isYearPickerVisible =
        _viewMode == CupertinoCalendarViewMode.yearPicker;
    final bool isTimePickerVisible =
        _viewMode == CupertinoCalendarViewMode.timePicker;

    return CupertinoPickerMediaQuery(
      child: Column(
        children: <Widget>[
          const SizedBox(height: calendarHeaderTopSpacing),
          CupertinoPickerAnimatedCrossFade(
            firstChild: CalendarHeader(
              currentMonth: _currentMonth,
              isYearPickerVisible: isYearPickerVisible,
              onNextMonthIconTapped: _isDisplayingLastMonth
                  ? null
                  : _handleNextMonth,
              onPreviousMonthIconTapped: _isDisplayingFirstMonth
                  ? null
                  : _handlePreviousMonth,
              onYearPickerStateChanged: (bool isVisible) => _toggleViewMode(
                CupertinoCalendarViewMode.yearPicker,
                isVisible,
              ),
              decoration: widget.headerDecoration,
            ),
            crossFadeState: isTimePickerVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
          Expanded(
            child: CupertinoPickerAnimatedCrossFade(
              crossFadeState: isYearPickerVisible || isTimePickerVisible
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Column(
                children: <Widget>[
                  const SizedBox(height: calendarWeekdaysTopSpacing),
                  CalendarWeekdays(
                    decoration: widget.weekdayDecoration,
                    firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
                  ),
                  CalendarMonthPicker(
                    monthPageController: _monthPageController,
                    onMonthPageChanged: _handleMonthPageChanged,
                    currentDate: widget.currentDateTime,
                    displayedMonth: _currentMonth,
                    minimumDate: widget.minimumDateTime,
                    maximumDate: widget.maximumDateTime,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    selectedDate: widget.selectedDateTime,
                    onChanged: _onMonthDateChanged,
                    decoration: widget.monthPickerDecoration,
                    mainColor: widget.mainColor,
                    firstDayOfWeekIndex: widget.firstDayOfWeekIndex,
                  ),
                ],
              ),
              secondChild: Padding(
                padding: calendarInnerPickerPadding,
                child: _buildInnerPicker(),
              ),
            ),
          ),
          if (widget.mode == CupertinoCalendarMode.dateTime)
            CupertinoPickerAnimatedCrossFade(
              firstChild: CalendarFooter(
                decoration: widget.footerDecoration,
                label: widget.timeLabel,
                type: widget.type,
                mainColor: widget.mainColor,
                time: TimeOfDay.fromDateTime(widget.selectedDateTime),
                isTimePickerVisible: isTimePickerVisible,
                onTimePickerStateChanged: (bool isVisible) => _toggleViewMode(
                  CupertinoCalendarViewMode.timePicker,
                  isVisible,
                ),
                onTimeChanged: onDayPeriodChanged,
                use24hFormat: widget.use24hFormat,
              ),
              crossFadeState: isYearPickerVisible
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          if (widget.type == CupertinoCalendarType.compact &&
              actions != null &&
              actions.isNotEmpty) ...<Widget>[
            const CupertinoPickerDivider(horizontalIndent: 0.0),
            CalendarActions(actions: actions, onPressed: _onActionPressed),
          ],
        ],
      ),
    );
  }
}
