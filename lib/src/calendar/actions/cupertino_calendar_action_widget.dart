// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      _CupertinoContextMenuActionState();
}

class _CupertinoContextMenuActionState
    extends State<CupertinoCalendarActionWidget> {
  bool _isPressed = false;
  bool get isPressed => _isPressed;
  set isPressed(bool value) {
    if (value != _isPressed) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    isPressed = true;
  }

  void _onTapUp(TapUpDetails details) {
    isPressed = false;
  }

  void _onTapCancel() {
    isPressed = false;
  }

  void _onTap() {
    widget.onPressed(widget.action);
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoCalendarAction action = widget.action;
    final CalendarActionDecoration decoration =
        action.decoration ?? CalendarActionDecoration.withDynamicColor(context);
    final TextStyle? style = action.isDefaultAction
        ? decoration.style?.copyWith(fontWeight: FontWeight.w600)
        : decoration.style;

    return Expanded(
      child: MouseRegion(
        cursor: action.onPressed != null && kIsWeb
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: _onTap,
          behavior: HitTestBehavior.opaque,
          child: ColoredBox(
            color: isPressed ? decoration.pressedColor : Colors.transparent,
            child: Center(
              child: Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
