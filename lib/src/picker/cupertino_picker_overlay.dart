// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

/// Displays [child] in an animated container next to [widgetRenderBox] and
/// pops the enclosing route with a result once the dismiss animation ends.
///
/// Descendants close the overlay through [CupertinoPickerOverlayScope].
class CupertinoPickerOverlay extends StatefulWidget {
  const CupertinoPickerOverlay({
    required this.height,
    required this.width,
    required this.child,
    this.widgetRenderBox,
    this.horizontalSpacing = pickerDefaultHorizontalSpacing,
    this.verticalSpacing = pickerDefaultVerticalSpacing,
    this.offset = pickerDefaultOffset,
    this.outsideTapDismissable = true,
    this.containerDecoration,
    this.dismissResult,
    super.key,
  });

  final double height;
  final double width;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;

  /// The widget the overlay is displayed next to.
  ///
  /// When `null` or detached, the overlay is centered.
  final RenderBox? widgetRenderBox;
  final bool outsideTapDismissable;
  final PickerContainerDecoration? containerDecoration;

  /// Returns the result of the route when the overlay is dismissed by an
  /// outside tap or the system back gesture.
  final ValueGetter<Object?>? dismissResult;
  final Widget child;

  @override
  State<CupertinoPickerOverlay> createState() => _CupertinoPickerOverlayState();
}

class _CupertinoPickerOverlayState extends State<CupertinoPickerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;
  Rect? _anchorRect;
  Object? _result;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: calendarAnimationDuration,
      reverseDuration: calendarAnimationReverseDuration,
    )..addStatusListener(_handleAnimationStatus);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: calendarAnimationCurve,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status.isDismissed && _isClosing && mounted) {
      Navigator.of(context).pop(_result);
    }
  }

  void _close(Object? result) {
    if (_isClosing) return;
    _isClosing = true;
    _result = result;
    _controller.reverse(from: pickerDismissAnimationStartValue);
  }

  void _dismiss() => _close(widget.dismissResult?.call());

  /// Returns the anchor's rect relative to the navigator the overlay's route
  /// is displayed in, remembering the last known rect once it detaches.
  Rect? _resolveAnchorRect() {
    final RenderBox? anchor = widget.widgetRenderBox;
    if (anchor == null || !anchor.attached || !anchor.hasSize) {
      return _anchorRect;
    }

    final RenderObject? navigatorBox = Navigator.maybeOf(context)?.context
        .findRenderObject();
    final Offset origin = navigatorBox is RenderBox && navigatorBox.attached
        ? navigatorBox.localToGlobal(Offset.zero)
        : Offset.zero;
    return _anchorRect =
        anchor.localToGlobal(Offset.zero) - origin & anchor.size;
  }

  @override
  Widget build(BuildContext context) {
    final Rect? anchorRect = _resolveAnchorRect();
    final EdgeInsets padding = MediaQuery.viewPaddingOf(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) _dismiss();
      },
      child: CupertinoPickerOverlayScope(
        close: _close,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final PickerOverlayLayout layout = PickerOverlayLayout.compute(
              anchor: anchorRect,
              bounds: constraints.biggest,
              padding: padding,
              size: Size(widget.width, widget.height),
              horizontalSpacing: widget.horizontalSpacing,
              verticalSpacing: widget.verticalSpacing,
              offset: widget.offset,
            );

            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fill(
                  child: _OutsideTapBarrier(
                    onDismiss: widget.outsideTapDismissable ? _dismiss : null,
                  ),
                ),
                Positioned(
                  top: layout.top,
                  left: layout.left,
                  width: widget.width,
                  child: Semantics(
                    scopesRoute: true,
                    explicitChildNodes: true,
                    child: CupertinoPickerContainer(
                      animation: _animation,
                      height: widget.height,
                      width: widget.width,
                      decoration:
                          widget.containerDecoration ??
                          PickerContainerDecoration.withDynamicColor(context),
                      maxScale: layout.scale,
                      scaleAlignment: layout.scaleAlignment,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OutsideTapBarrier extends StatelessWidget {
  const _OutsideTapBarrier({required this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onDismiss = this.onDismiss;
    final Widget barrier = GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      excludeFromSemantics: true,
      child: const SizedBox.expand(),
    );
    if (onDismiss == null) return barrier;

    return Semantics(
      label: CupertinoLocalizations.of(context).modalBarrierDismissLabel,
      onTap: onDismiss,
      child: barrier,
    );
  }
}

/// Exposes closing of the enclosing [CupertinoPickerOverlay].
class CupertinoPickerOverlayScope extends InheritedWidget {
  const CupertinoPickerOverlayScope({
    required this.close,
    required super.child,
    super.key,
  });

  /// Closes the overlay and completes its route with the given result.
  final ValueChanged<Object?> close;

  /// Returns the closest enclosing scope, or `null` when [context] is not
  /// inside of a [CupertinoPickerOverlay].
  static CupertinoPickerOverlayScope? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<CupertinoPickerOverlayScope>();
  }

  @override
  bool updateShouldNotify(CupertinoPickerOverlayScope oldWidget) {
    return close != oldWidget.close;
  }
}
