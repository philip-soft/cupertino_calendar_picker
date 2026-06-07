// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget wrapWithApp(
  Widget child, {
  Brightness brightness = Brightness.light,
  TextDirection textDirection = TextDirection.ltr,
  Locale locale = const Locale('en', 'US'),
}) {
  return CupertinoApp(
    locale: locale,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const <Locale>[
      Locale('en', 'US'),
      Locale('en', 'GB'),
    ],
    theme: CupertinoThemeData(brightness: brightness),
    home: CupertinoPageScaffold(
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: child),
      ),
    ),
  );
}
