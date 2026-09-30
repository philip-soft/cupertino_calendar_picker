// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// A screen the picker placement is tested on, in logical pixels.
class TestScreen {
  const TestScreen({
    required this.name,
    required this.size,
    required this.padding,
  });

  final String name;
  final Size size;

  /// The safe area insets, e.g. the notch and the home indicator.
  final EdgeInsets padding;

  /// The area the picker may occupy with the default spacing.
  Rect get pickerArea {
    return padding
        .deflateRect(Offset.zero & size)
        .deflate(pickerDefaultVerticalSpacing);
  }

  /// Returns the rect of an anchor of [anchorSize] placed at [alignment]
  /// within the safe area, keeping a small margin from its edges.
  Rect anchorRect(Alignment alignment, Size anchorSize) {
    final Rect safeArea = padding
        .deflateRect(Offset.zero & size)
        .deflate(anchorMargin);
    return alignment.inscribe(anchorSize, safeArea);
  }

  static const double anchorMargin = 16.0;

  @override
  String toString() => name;
}

const List<TestScreen> testScreens = <TestScreen>[
  TestScreen(
    name: 'small phone',
    size: Size(320.0, 568.0),
    padding: EdgeInsets.only(top: 20.0),
  ),
  TestScreen(
    name: 'phone',
    size: Size(390.0, 844.0),
    padding: EdgeInsets.only(top: 47.0, bottom: 34.0),
  ),
  TestScreen(
    name: 'landscape phone',
    size: Size(844.0, 390.0),
    padding: EdgeInsets.only(left: 47.0, right: 47.0, bottom: 21.0),
  ),
  TestScreen(
    name: 'tablet',
    size: Size(1024.0, 1366.0),
    padding: EdgeInsets.only(top: 24.0, bottom: 20.0),
  ),
];

/// The positions of the anchor on the screen, by name.
const Map<String, Alignment> anchorPositions = <String, Alignment>{
  'top left': Alignment.topLeft,
  'top center': Alignment.topCenter,
  'top right': Alignment.topRight,
  'center left': Alignment.centerLeft,
  'center': Alignment.center,
  'center right': Alignment.centerRight,
  'bottom left': Alignment.bottomLeft,
  'bottom center': Alignment.bottomCenter,
  'bottom right': Alignment.bottomRight,
};

/// Sets the test view to [screen], with a device pixel ratio of `1.0`.
void setTestScreen(WidgetTester tester, TestScreen screen) {
  final FakeViewPadding padding = FakeViewPadding(
    left: screen.padding.left,
    top: screen.padding.top,
    right: screen.padding.right,
    bottom: screen.padding.bottom,
  );
  tester.view
    ..devicePixelRatio = 1.0
    ..physicalSize = screen.size
    ..padding = padding
    ..viewPadding = padding;
  addTearDown(tester.view.reset);
}

/// Returns the rect a picker of [size] occupies on [screen] next to
/// [anchor], including its scale.
Rect expectedPickerRect(TestScreen screen, Rect? anchor, Size size) {
  final PickerOverlayLayout layout = PickerOverlayLayout.compute(
    anchor: anchor,
    bounds: screen.size,
    padding: screen.padding,
    size: size,
    horizontalSpacing: pickerDefaultHorizontalSpacing,
    verticalSpacing: pickerDefaultVerticalSpacing,
    offset: pickerDefaultOffset,
  );
  return pickerVisualRect(layout, size);
}

/// The rect a picker of [size] placed with [layout] occupies once scaled.
Rect pickerVisualRect(PickerOverlayLayout layout, Size size) {
  final Rect box = Offset(layout.left, layout.top) & size;
  final Offset pivot = layout.scaleAlignment.withinRect(box);
  return Rect.fromPoints(
    pivot + (box.topLeft - pivot) * layout.scale,
    pivot + (box.bottomRight - pivot) * layout.scale,
  );
}
