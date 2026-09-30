// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

/// Signature for the per-suite layout that sizes and positions the widget
/// under test inside the shared app scaffold.
typedef TestLayoutBuilder = Widget Function(Widget child);

/// The single app scaffold every widget test renders into.
///
/// Each `test_helpers.dart` supplies only its own [layout], so localization
/// delegates, supported locales and theming stay defined in one place.
Widget wrapTestWidget(
  Widget child, {
  required Brightness brightness,
  required TextDirection textDirection,
  required Locale locale,
  TestLayoutBuilder? layout,
}) {
  return CupertinoApp(
    locale: locale,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const <Locale>[
      Locale('en', 'US'),
      Locale('en', 'GB'),
      Locale('ar'),
      Locale('zh'),
    ],
    theme: CupertinoThemeData(brightness: brightness),
    home: CupertinoPageScaffold(
      child: Directionality(
        textDirection: textDirection,
        child: layout == null ? child : layout(child),
      ),
    ),
  );
}
