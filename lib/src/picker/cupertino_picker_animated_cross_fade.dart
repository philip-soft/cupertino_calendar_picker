// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPickerAnimatedCrossFade extends StatelessWidget {
  const CupertinoPickerAnimatedCrossFade({
    required this.firstChild,
    required this.crossFadeState,
    this.secondChild,
    super.key,
  });

  final Widget firstChild;
  final Widget? secondChild;
  final CrossFadeState crossFadeState;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: pickerFadeDuration,
      firstChild: firstChild,
      secondChild: secondChild ?? const SizedBox(),
      crossFadeState: crossFadeState,
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          children: <Widget>[
            SizedBox(
              key: bottomChildKey,
              child: bottomChild,
            ),
            SizedBox(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}
