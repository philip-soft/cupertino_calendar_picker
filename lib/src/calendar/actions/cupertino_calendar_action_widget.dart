// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

typedef CalendarActionCallback = void Function(CupertinoCalendarAction action);

class CupertinoCalendarActionWidget extends StatefulWidget {
  const CupertinoCalendarActionWidget({
    required this.action,
    required this.onPressed,
    super.key,
  });

  final CupertinoCalendarAction action;
  final CalendarActionCallback onPressed;

  @override
  State<CupertinoCalendarActionWidget> createState() =>
      _CupertinoCalendarActionWidgetState();
}

class _CupertinoCalendarActionWidgetState
    extends State<CupertinoCalendarActionWidget> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (value == _isPressed) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoCalendarAction action = widget.action;
    final CalendarActionDecoration decoration =
        action.decoration ?? CalendarActionDecoration.withDynamicColor(context);
    final TextStyle labelStyle = decoration.labelStyle.resolveDynamic(context);
    final String label = action.effectiveLabel(context);

    return Expanded(
      child: CupertinoPickerTapTarget(
        onTap: () => widget.onPressed(action),
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        behavior: HitTestBehavior.opaque,
        semanticsLabel: label,
        child: ColoredBox(
          color: _isPressed
              ? decoration.pressedColor.resolveDynamic(context)
              : Colors.transparent,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: action.isDefaultAction
                  ? labelStyle.copyWith(fontWeight: FontWeight.w600)
                  : labelStyle,
            ),
          ),
        ),
      ),
    );
  }
}
