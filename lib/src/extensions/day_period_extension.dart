// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

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
