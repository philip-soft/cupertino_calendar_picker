// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension PackageBuildContextExtension on BuildContext {
  bool get alwaysUse24hFormat {
    return MediaQuery.alwaysUse24HourFormatOf(this);
  }

  MaterialLocalizations get materialLocalization {
    assert(debugCheckHasMaterialLocalizations(this));
    return MaterialLocalizations.of(this);
  }

  CupertinoLocalizations get cupertinoLocalization {
    assert(debugCheckHasCupertinoLocalizations(this));
    return CupertinoLocalizations.of(this);
  }

  Locale get locale {
    return Localizations.localeOf(this);
  }

  String get localeString {
    String localeString = locale.languageCode;

    final String? countryCode = locale.countryCode;
    if (countryCode != null) {
      localeString += '_$countryCode';
    }
    return localeString;
  }
}
