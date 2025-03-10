// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/extensions/double_extension.dart';
import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPickerButton<T> extends StatefulWidget {
  const CupertinoPickerButton({
    required this.title,
    required this.showPickerFunction,
    required this.onPressed,
    this.mainColor,
    super.key,
    this.onSelected,
    this.decoration,
  });

  final String title;
  final Future<T> Function(RenderBox? renderBox) showPickerFunction;
  final ValueChanged<T?>? onSelected;
  final Color? mainColor;
  final PickerButtonDecoration? decoration;
  final VoidCallback? onPressed;

  @override
  State<CupertinoPickerButton<T>> createState() =>
      _CupertinoPickerButtonState<T>();
}

class _CupertinoPickerButtonState<T> extends State<CupertinoPickerButton<T>>
    with SingleTickerProviderStateMixin {
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  bool _buttonHeldDown = false;

  bool _isCalendarOpened = false;
  bool get isCalendarOpened => _isCalendarOpened;
  set isCalendarOpened(bool value) {
    if (!mounted) return;
    setState(() {
      _isCalendarOpened = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: pickerButtonFadeDuration,
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = 0.4;
  }

  Future<void> _onTap(BuildContext context) async {
    widget.onPressed?.call();

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    isCalendarOpened = true;

    final T? data = await widget.showPickerFunction.call(renderBox);
    widget.onSelected?.call(data);

    isCalendarOpened = false;
  }

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(
            1.0,
            duration: pickerButtonFadeOutDuration,
            curve: Curves.easeInOutCubicEmphasized,
          )
        : _animationController.animateTo(
            0.0,
            duration: pickerButtonFadeInDuration,
            curve: Curves.easeOutCubic,
          );
    // ignore: cascade_invocations
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PickerButtonDecoration decoration =
        widget.decoration ?? PickerButtonDecoration.withDynamicColor(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: decoration.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        height: 34.0.scale(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: AnimatedDefaultTextStyle(
            duration: pickerButtonTextStyleDuration,
            style: decoration.textStyle!.copyWith(
              color: isCalendarOpened
                  ? widget.mainColor
                  : widget.decoration?.textStyle?.color,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
