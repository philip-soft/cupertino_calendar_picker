// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';

/// A scroll behavior that allows web/desktop users to scroll the picker using
/// any device, including the mouse.
class CupertinoAnyDeviceScrollBehavior extends CupertinoScrollBehavior {
  const CupertinoAnyDeviceScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        ...PointerDeviceKind.values,
      };
}

/// Fixes the behavior for mouse wheel scrolling by always scrolling in fixed
/// 1-item increments
class CupertinoFixedItemMouseScrolling extends StatelessWidget {
  const CupertinoFixedItemMouseScrolling({
    required this.scrollController,
    required this.child,
    super.key,
  });

  final FixedExtentScrollController? scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const CupertinoAnyDeviceScrollBehavior(),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerSignal: (PointerSignalEvent event) {
          final FixedExtentScrollController? controller = scrollController;
          if (event is PointerScrollEvent &&
              controller != null &&
              controller.hasClients &&
              controller.positions.length == 1) {
            // Default flutter behavior mouse wheel scrolling is scrolling by
            // several items instead of just 1. (The exact number may be
            // platform specific depending on the specific mouse and mouse
            // settings.) There is currently no way to block mouse wheel event
            // propagation in flutter without also entirely disabling mouse
            // wheel drag/drop scrolling. The FixedExtentScrollController custom
            // scroll position _FixedExtentScrollPosition is also a private
            // type, so we cannot override pointerScroll here. To workaround, we
            // first get the correct offset of scrolling by exactly one item in
            // the right direction, and then we counter the future affect of
            // _FixedExtentScrollPosition's pointerScroll method where it will
            // scroll by the amount of scrollDelta.
            double? correctOffset;
            if (event.scrollDelta.dy < 0) {
              // Scroll up event. Scroll to the correct position to get the
              // correct offset, then counteract the future affect of the
              // default behavior with scrollDelta.
              controller.jumpToItem(controller.selectedItem - 1);
              correctOffset = controller.offset + 0.001;
              controller.jumpTo(controller.offset - event.scrollDelta.dy);
            } else if (event.scrollDelta.dy > 0) {
              // Scroll down event. Parallel case to scroll up in the opposite
              // direction.
              controller.jumpToItem(controller.selectedItem + 1);
              correctOffset = controller.offset + 0.001;
              controller.jumpTo(controller.offset - event.scrollDelta.dy);
            }
            // In certain cases with the scroll offset changing several times
            // in one frame, the final value (e.g., hour or minute) was not
            // correct. In the next frame make sure that we capture the correct
            // final value of the new scroll position.
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (correctOffset != null) {
                controller.jumpTo(correctOffset);
              }
            });
          }
        },
        child: child,
      ),
    );
  }
}
