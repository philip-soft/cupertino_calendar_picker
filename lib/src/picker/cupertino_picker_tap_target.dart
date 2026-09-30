// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_ui/cupertino_ui.dart';

/// A tappable area that is announced as a button by screen readers and can be
/// focused and activated with a keyboard.
///
/// When [semanticsLabel] is provided, the semantics of [child] are replaced
/// by it.
class CupertinoPickerTapTarget extends StatelessWidget {
  const CupertinoPickerTapTarget({
    required this.onTap,
    required this.child,
    this.semanticsLabel,
    this.semanticsValue,
    this.isSelected,
    this.isExpanded,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.behavior = HitTestBehavior.translucent,
    super.key,
  });

  /// Called when the target is tapped or activated. `null` disables it.
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool? isSelected;
  final bool? isExpanded;
  final HitTestBehavior behavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onTap = this.onTap;
    final bool isEnabled = onTap != null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      selected: isSelected,
      expanded: isExpanded,
      label: semanticsLabel,
      value: semanticsValue,
      excludeSemantics: semanticsLabel != null,
      onTap: onTap,
      child: FocusableActionDetector(
        enabled: isEnabled,
        actions: <Type, Action<Intent>>{
          if (onTap != null)
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent _) {
                onTap();
                return null;
              },
            ),
        },
        child: GestureDetector(
          onTap: onTap,
          onTapDown: isEnabled ? onTapDown : null,
          onTapUp: isEnabled ? onTapUp : null,
          onTapCancel: isEnabled ? onTapCancel : null,
          behavior: behavior,
          excludeFromSemantics: true,
          child: child,
        ),
      ),
    );
  }
}
