// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// An enum for the picker's background appearance.
enum PickerBackgroundType {
  /// Fills the background with the color as is.
  plainColor,

  /// Blurs the content behind the picker and limits the opacity of the color,
  /// so that the blur stays visible.
  transparentAndBlurred,
}
