// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;

typedef YearPickerCallback = void Function(bool showYearPicker);

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.currentMonth,
    required this.isYearPickerVisible,
    required this.onYearPickerStateChanged,
    required this.onPreviousMonthIconTapped,
    required this.onNextMonthIconTapped,
    required this.decoration,
    super.key,
  });

  final DateTime currentMonth;
  final bool isYearPickerVisible;
  final VoidCallback? onPreviousMonthIconTapped;
  final VoidCallback? onNextMonthIconTapped;

  /// Called with the requested visibility of the year picker.
  final YearPickerCallback onYearPickerStateChanged;
  final CalendarHeaderDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final String headerString = DateFormat.yMMMM(context.localeString)
        .format(currentMonth);
    final TextStyle monthDateStyle = decoration.monthDateStyle.resolveDynamic(
      context,
    );
    final Color arrowColor = decoration.monthDateArrowColor.resolveDynamic(
      context,
    );
    final MaterialLocalizations localizations = context.materialLocalization;

    return Row(
      children: <Widget>[
        const SizedBox(width: calendarHeaderLeadingSpacing),
        CupertinoPickerTapTarget(
          onTap: () => onYearPickerStateChanged(!isYearPickerVisible),
          semanticsLabel: headerString,
          isExpanded: isYearPickerVisible,
          child: Row(
            children: <Widget>[
              AnimatedDefaultTextStyle(
                duration: innerPickersFadeDuration,
                style: isYearPickerVisible
                    ? monthDateStyle.copyWith(color: arrowColor)
                    : monthDateStyle,
                child: Text(headerString),
              ),
              SizedBox(width: calendarHeaderTitleArrowSpacing.scale(context)),
              AnimatedRotation(
                duration: innerPickersFadeDuration,
                curve: Curves.easeInOut,
                turns: isYearPickerVisible ? 1.25 : 1.0,
                child: SizedBox(
                  width: calendarHeaderArrowWidth.scale(context),
                  height: calendarHeaderArrowHeight.scale(context),
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    color: arrowColor,
                    size: calendarMonthPickerIconSize.scale(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MonthSwitcherButton(
                icon: CupertinoIcons.chevron_back,
                semanticsLabel: localizations.previousMonthTooltip,
                onTap: onPreviousMonthIconTapped,
                color: decoration.backwardButtonColor,
                disabledColor: decoration.backwardDisabledButtonColor,
              ),
              SizedBox(width: calendarMonthSwitcherSpacing.scale(context)),
              _MonthSwitcherButton(
                icon: CupertinoIcons.chevron_forward,
                semanticsLabel: localizations.nextMonthTooltip,
                onTap: onNextMonthIconTapped,
                color: decoration.forwardButtonColor,
                disabledColor: decoration.forwardDisabledButtonColor,
              ),
            ],
          ),
          crossFadeState: isYearPickerVisible
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: innerPickersFadeDuration,
          layoutBuilder:
              (
                Widget topChild,
                Key topChildKey,
                Widget bottomChild,
                Key bottomChildKey,
              ) {
                return Stack(children: <Widget>[bottomChild, topChild]);
              },
        ),
      ],
    );
  }
}

class _MonthSwitcherButton extends StatelessWidget {
  const _MonthSwitcherButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    required this.color,
    required this.disabledColor,
  });

  final IconData icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final Color color;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = onTap == null ? disabledColor : color;

    return CupertinoPickerTapTarget(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      child: SizedBox(
        height: calendarMonthSwitcherSize,
        width: calendarMonthSwitcherSize,
        child: Icon(
          icon,
          color: iconColor.resolveDynamic(context),
          size: calendarMonthSwitcherIconSize.scale(context),
        ),
      ),
    );
  }
}
