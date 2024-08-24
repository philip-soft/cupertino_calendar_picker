// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoPickerDivider extends StatelessWidget {
  const CupertinoPickerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Divider(
        height: 0.3,
        color: CupertinoColors.separator.resolveFrom(context),
        thickness: 0.3,
      ),
    );
  }
}
