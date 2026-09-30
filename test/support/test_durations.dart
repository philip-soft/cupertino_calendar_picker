// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';

/// A single pump that outlasts the overlay's open animation.
///
/// Derived from [calendarAnimationDuration] so retuning the animation in
/// `package_config.dart` cannot silently leave the tests pumping too little.
final Duration overlayOpenPumpDuration = calendarAnimationDuration * 1.5;

/// A single pump that outlasts the overlay's dismiss animation.
///
/// Derived from [calendarAnimationReverseDuration] for the same reason.
final Duration overlayClosePumpDuration =
    calendarAnimationReverseDuration * 2.0;

/// A single pump that outlasts a month page transition.
final Duration monthScrollPumpDuration = monthScrollDuration * 1.5;
