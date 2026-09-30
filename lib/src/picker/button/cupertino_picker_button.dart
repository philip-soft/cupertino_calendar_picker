// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

class CupertinoPickerButton<T> extends StatefulWidget {
  const CupertinoPickerButton({
    required this.title,
    required this.showPickerFunction,
    required this.onPressed,
    this.mainColor,
    this.decoration,
    super.key,
  });

  final String title;
  final Future<T> Function(RenderBox? renderBox) showPickerFunction;
  final Color? mainColor;
  final PickerButtonDecoration? decoration;
  final VoidCallback? onPressed;

  @override
  State<CupertinoPickerButton<T>> createState() =>
      _CupertinoPickerButtonState<T>();
}

class _CupertinoPickerButtonState<T> extends State<CupertinoPickerButton<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  bool _buttonHeldDown = false;
  bool _isPickerOpened = false;

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
        .drive(Tween<double>(begin: 1.0, end: pickerButtonPressedOpacity));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setPickerOpened(bool value) {
    if (!mounted) return;
    setState(() => _isPickerOpened = value);
  }

  Future<void> _onTap() async {
    if (_isPickerOpened) return;
    widget.onPressed?.call();

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    _setPickerOpened(true);
    await widget.showPickerFunction(renderBox);
    _setPickerOpened(false);
  }

  void _setHeldDown(bool value) {
    if (_buttonHeldDown == value) return;
    _buttonHeldDown = value;
    unawaited(
      _buttonHeldDown
          ? _animationController.animateTo(
              1.0,
              duration: pickerButtonFadeOutDuration,
              curve: Curves.easeInOutCubicEmphasized,
            )
          : _animationController.animateTo(
              0.0,
              duration: pickerButtonFadeInDuration,
              curve: Curves.easeOutCubic,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PickerButtonDecoration decoration =
        widget.decoration ?? PickerButtonDecoration.withDynamicColor(context);
    final TextStyle textStyle = decoration.textStyle.resolveDynamic(context);
    final Color? mainColor = widget.mainColor;

    return CupertinoPickerTapTarget(
      onTap: _onTap,
      onTapDown: (_) => _setHeldDown(true),
      onTapUp: (_) => _setHeldDown(false),
      onTapCancel: () => _setHeldDown(false),
      behavior: HitTestBehavior.opaque,
      semanticsLabel: widget.title,
      isExpanded: _isPickerOpened,
      child: Container(
        decoration: BoxDecoration(
          color: decoration.backgroundColor.resolveDynamic(context),
          borderRadius: BorderRadius.circular(pickerButtonBorderRadius),
        ),
        height: pickerButtonHeight.scale(context),
        padding: const EdgeInsets.symmetric(
          horizontal: pickerButtonHorizontalPadding,
        ),
        // Hugs the title unless the parent forces a width.
        child: Center(
          widthFactor: 1.0,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: AnimatedDefaultTextStyle(
              duration: pickerButtonTextStyleDuration,
              style: _isPickerOpened && mainColor != null
                  ? textStyle.copyWith(color: mainColor)
                  : textStyle,
              child: Text(widget.title),
            ),
          ),
        ),
      ),
    );
  }
}
