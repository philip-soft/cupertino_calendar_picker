// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPickerMediaQuery extends StatelessWidget {
  const CupertinoPickerMediaQuery({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: context.textScaler.clamp(
          maxScaleFactor: calendarMaxTextScaleFactor,
        ),
      ),
      child: child,
    );
  }
}
