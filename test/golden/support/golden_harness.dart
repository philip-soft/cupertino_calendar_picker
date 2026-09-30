// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:alchemist/alchemist.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

/// Signature for building a golden scenario for the given theme brightness.
typedef BrightnessWidgetBuilder = Widget Function(Brightness brightness);

/// Renders [child] centered on a page of the app every golden scenario
/// shares.
///
/// [textScale] and [textDirection] override the ambient values when provided.
Widget goldenApp({
  required Brightness brightness,
  required Widget child,
  Locale locale = const Locale('en', 'US'),
  TextDirection? textDirection,
  double? textScale,
}) {
  Widget content = Center(child: child);
  if (textDirection != null) {
    content = Directionality(textDirection: textDirection, child: content);
  }
  if (textScale != null) {
    final Widget scaledContent = content;
    content = Builder(
      builder: (BuildContext context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: scaledContent,
      ),
    );
  }

  return CupertinoApp(
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(brightness: brightness),
    locale: locale,
    supportedLocales: const <Locale>[
      Locale('en', 'US'),
      Locale('ar'),
      Locale('zh'),
    ],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: CupertinoPageScaffold(child: content),
  );
}

/// Renders [builder] in the light and the dark theme side by side.
GoldenTestGroup lightDarkGroup(BrightnessWidgetBuilder builder) {
  return GoldenTestGroup(
    columns: 2,
    children: <Widget>[
      GoldenTestScenario(name: 'light', child: builder(Brightness.light)),
      GoldenTestScenario(name: 'dark', child: builder(Brightness.dark)),
    ],
  );
}
