import 'package:flutter/cupertino.dart';

class CupertinoPickerButton<T> extends StatefulWidget {
  const CupertinoPickerButton({
    required this.title,
    required this.mainColor,
    required this.showPickerFunction,
    super.key,
    this.onSelected,
  });

  final String title;
  final Future<T> Function(RenderBox? renderBox) showPickerFunction;
  final ValueChanged<T?>? onSelected;
  final Color mainColor;

  @override
  State<CupertinoPickerButton<T>> createState() =>
      _CupertinoPickerButtonState<T>();
}

class _CupertinoPickerButtonState<T> extends State<CupertinoPickerButton<T>>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 1000);
  static const Duration kFadeInDuration = Duration(milliseconds: 800);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);
  final Duration _fadeDuration = const Duration(milliseconds: 200);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  bool _buttonHeldDown = false;

  bool _isCalendarOpened = false;
  bool get isCalendarOpened => _isCalendarOpened;
  set isCalendarOpened(bool value) {
    setState(() {
      _isCalendarOpened = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _fadeDuration,
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.linear))
        .drive(_opacityTween);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = 0.4;
  }

  Future<void> _onTap(BuildContext context) async {
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
            duration: kFadeOutDuration,
            curve: Curves.easeInOutCubicEmphasized,
          )
        : _animationController.animateTo(
            0.0,
            duration: kFadeInDuration,
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
    return GestureDetector(
      onTap: () => _onTap(context),
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        height: 34.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 100),
            style: TextStyle(
              color: CupertinoDynamicColor.maybeResolve(
                isCalendarOpened ? widget.mainColor : CupertinoColors.label,
                context,
              ),
              fontSize: 17.0,
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
