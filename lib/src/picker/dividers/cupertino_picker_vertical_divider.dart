// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoPickerVerticalDivider extends StatelessWidget {
  const CupertinoPickerVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 0.33,
      thickness: 0.33,
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }
}
