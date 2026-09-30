// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

import '../../support/test_app.dart';

/// Wraps [child] in the shared test app using this suite's layout: unconstrained.
Widget wrapWithApp(
  Widget child, {
  Brightness brightness = Brightness.light,
  TextDirection textDirection = TextDirection.ltr,
  Locale locale = const Locale('en', 'US'),
}) {
  return wrapTestWidget(
    child,
    brightness: brightness,
    textDirection: textDirection,
    locale: locale,
  );
}
