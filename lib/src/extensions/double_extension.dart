// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/material.dart';

extension DoubleExtension on double {
  double scale(BuildContext context) {
    return this * context.textScaleFactor;
  }
}
