import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTimeOverlay extends StatefulWidget {
  const CupertinoTimeOverlay({
    required this.widgetRenderBox,
    required this.minimumDate,
    required this.maximumDate,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.offset,
    required this.mainColor,
    required this.dismissBehavior,
    this.onDateChanged,
    this.onDateSelected,
    this.currentDate,
    this.initialDate,
    super.key,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;
  final DateTime? initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final CalendarContainerDecoration? containerDecoration;
  final CalendarDismissBehavior dismissBehavior;
  final Color mainColor;

  @override
  State<CupertinoTimeOverlay> createState() => _CupertinoTimeOverlayState();
}

class _CupertinoTimeOverlayState extends State<CupertinoTimeOverlay> {
  AnimationController? _controller;
  DateTime? _selectedDate;

  void _onInitialized(AnimationController animationController) {
    _controller = animationController;
    _controller?.forward();
    _controller?.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop(_selectedDate);
    }
  }

  void _closeOverlay() {
    if (_controller != null) {
      final bool isReverseInProgress =
          _controller!.status == AnimationStatus.reverse;
      if (!isReverseInProgress) {
        _controller?.reverse(from: 0.75);
      }
    }
  }

  void _onDateChanged(DateTime date) {
    _selectedDate = date;
    widget.onDateChanged?.call(date);
  }

  void _onDateSelected(DateTime date) {
    _selectedDate = date;
    widget.onDateSelected?.call(date);

    if (widget.dismissBehavior.hasDateSelectDismiss) {
      _closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickerOverlay(
      onInitialized: _onInitialized,
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: 203,
      width: 231,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      outsideTapDismissable: widget.dismissBehavior.hasOusideTapDismiss,
      child: Center(
        child: SizedBox(
          height: 160,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (_) {},
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    super.dispose();
  }
}
