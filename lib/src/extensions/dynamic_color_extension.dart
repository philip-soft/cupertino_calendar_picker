// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

/// Resolves [CupertinoDynamicColor]s against the ambient brightness, so that
/// decorations created without a [BuildContext] still adapt to dark mode.
extension DynamicColorExtension on Color {
  Color resolveDynamic(BuildContext context) {
    return CupertinoDynamicColor.resolve(this, context);
  }
}

/// Resolves the [TextStyle.color] of a style against the ambient brightness.
extension DynamicTextStyleExtension on TextStyle {
  TextStyle resolveDynamic(BuildContext context) {
    final Color? color = this.color;
    if (color == null) return this;
    return copyWith(color: color.resolveDynamic(context));
  }
}
