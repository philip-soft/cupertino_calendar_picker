import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension DayPeriodExtension on DayPeriod {
  String localizedString(BuildContext context) {
    return switch (this) {
      DayPeriod.am =>
        CupertinoLocalizations.of(context).anteMeridiemAbbreviation,
      DayPeriod.pm =>
        CupertinoLocalizations.of(context).postMeridiemAbbreviation,
    };
  }
}
