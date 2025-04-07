// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

typedef YearPickerCallback = void Function(bool showYearPicker);

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.currentMonth,
    required this.onYearPickerStateChanged,
    required this.onPreviousMonthIconTapped,
    required this.onNextMonthIconTapped,
    required this.decoration,
    super.key,
  });

  final DateTime currentMonth;
  final VoidCallback? onPreviousMonthIconTapped;
  final VoidCallback? onNextMonthIconTapped;
  final YearPickerCallback onYearPickerStateChanged;
  final CalendarHeaderDecoration decoration;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _showYearPicker = false;

  CalendarHeaderDecoration get _decoration => widget.decoration;
  bool get _isBackwardDisabled => widget.onPreviousMonthIconTapped == null;
  bool get _isForwardDisabled => widget.onNextMonthIconTapped == null;

  void _handleYearPickerStateChange() {
    setState(() {
      _showYearPicker = !_showYearPicker;
      widget.onYearPickerStateChanged.call(_showYearPicker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.currentMonth;
    final String headerString = widget.decoration.monthDateFormat?.format(
          date,
        ) ??
        DateFormat.yMMMM(context.localeString).format(
          date,
        );

    final CalendarHeaderMode headerMode = widget.decoration.headerMode;
    final bool isCenterMonthYear =
        headerMode == CalendarHeaderMode.centerMonthYear;
    if (isCenterMonthYear) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _BackwardButton(
            widget: widget,
            isBackwardDisabled: _isBackwardDisabled,
            decoration: _decoration,
            showYearPicker: _showYearPicker,
          ),
          _MonthAndYear(
            showYearPicker: _showYearPicker,
            decoration: _decoration,
            headerString: headerString,
            handleYearPickerStateChange: _handleYearPickerStateChange,
          ),
          _ForwardButton(
            widget: widget,
            isForwardDisabled: _isForwardDisabled,
            decoration: _decoration,
            showYearPicker: _showYearPicker,
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        const SizedBox(width: 20.0),
        _MonthAndYear(
          showYearPicker: _showYearPicker,
          decoration: _decoration,
          headerString: headerString,
          handleYearPickerStateChange: _handleYearPickerStateChange,
        ),
        const Spacer(),
        _BackwardButton(
          widget: widget,
          isBackwardDisabled: _isBackwardDisabled,
          decoration: _decoration,
          showYearPicker: _showYearPicker,
        ),
        SizedBox(width: 2.0.scale(context)),
        _ForwardButton(
          widget: widget,
          isForwardDisabled: _isForwardDisabled,
          decoration: _decoration,
          showYearPicker: _showYearPicker,
        ),
      ],
    );
  }
}

class _MonthAndYear extends StatelessWidget {
  const _MonthAndYear({
    required this.showYearPicker,
    required this.decoration,
    required this.headerString,
    required this.handleYearPickerStateChange,
  });

  final bool showYearPicker;
  final CalendarHeaderDecoration decoration;
  final String headerString;
  final VoidCallback handleYearPickerStateChange;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: handleYearPickerStateChange,
      child: Row(
        children: <Widget>[
          AnimatedDefaultTextStyle(
            duration: innerPickersFadeDuration,
            style: showYearPicker
                ? decoration.monthDateStyle!.copyWith(
                    color: decoration.monthDateArrowColor,
                  )
                : decoration.monthDateStyle!,
            child: Text(headerString),
          ),
          SizedBox(width: 5.0.scale(context)),
          if (decoration.showMonthPickerIcon)
            AnimatedRotation(
              duration: innerPickersFadeDuration,
              curve: Curves.easeInOut,
              turns: showYearPicker ? 1.25 : 1.0,
              child: SizedBox(
                width: 11.0.scale(context),
                height: 22.0.scale(context),
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  color: decoration.monthDateArrowColor,
                  size: decoration.monthPickerIconSize.scale(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BackwardButton extends StatelessWidget {
  const _BackwardButton({
    required this.widget,
    required this.isBackwardDisabled,
    required this.decoration,
    required this.showYearPicker,
  });

  final CalendarHeader widget;
  final bool isBackwardDisabled;
  final CalendarHeaderDecoration decoration;
  final bool showYearPicker;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(),
      secondChild: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onPreviousMonthIconTapped,
        child: SizedBox(
          height: calendarMonthSwitcherSize,
          width: calendarMonthSwitcherSize,
          child: Icon(
            CupertinoIcons.chevron_back,
            color: isBackwardDisabled
                ? decoration.backwardDisabledButtonColor
                : decoration.backwardButtonColor,
            size: decoration.monthSwitcherIconSize.scale(context),
          ),
        ),
      ),
      crossFadeState:
          showYearPicker ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: innerPickersFadeDuration,
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          children: <Widget>[
            bottomChild,
            topChild,
          ],
        );
      },
    );
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton({
    required this.widget,
    required this.isForwardDisabled,
    required this.decoration,
    required this.showYearPicker,
  });

  final CalendarHeader widget;
  final bool isForwardDisabled;
  final CalendarHeaderDecoration decoration;
  final bool showYearPicker;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(),
      secondChild: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onNextMonthIconTapped,
        child: SizedBox(
          height: calendarMonthSwitcherSize,
          width: calendarMonthSwitcherSize,
          child: Icon(
            CupertinoIcons.chevron_forward,
            color: isForwardDisabled
                ? decoration.forwardDisabledButtonColor
                : decoration.forwardButtonColor,
            size: decoration.monthSwitcherIconSize.scale(context),
          ),
        ),
      ),
      crossFadeState:
          showYearPicker ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: innerPickersFadeDuration,
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          children: <Widget>[
            bottomChild,
            topChild,
          ],
        );
      },
    );
  }
}
