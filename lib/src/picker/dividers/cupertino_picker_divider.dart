// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

class CupertinoPickerDivider extends StatelessWidget {
  const CupertinoPickerDivider({this.horizontalIndent = 16.0, super.key});

  final double horizontalIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: horizontalIndent,
      endIndent: horizontalIndent,
      color: CupertinoColors.separator.resolveFrom(context),
      height: 0.33,
      thickness: 0.33,
    );
  }
}
