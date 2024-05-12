import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPickerButton extends StatefulWidget {
  const CalendarPickerButton({
    required this.selectedDate,
    required this.minimumDate,
    required this.maximumDate,
    this.offset = const Offset(0.0, 10.0),
    this.barrierColor = Colors.transparent,
    this.mainColor = CupertinoColors.systemRed,
    super.key,
    this.onDateChanged,
    this.currentDate,
    this.onDisplayedMonthChanged,
    this.containerDecoration,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
  });

  /// The minimum selectable [DateTime].
  final DateTime minimumDate;

  /// The maximum selectable [DateTime].
  final DateTime maximumDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime>? onDateChanged;

  /// The selected [DateTime] that the calendar should display.
  final DateTime selectedDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime? currentDate;

  /// Called when the user navigates to a new month in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The spacing from left and right side of the screen.
  final double horizontalSpacing = 15.0;

  /// The spacing from top and bottom side of the screen.
  final double verticalSpacing = 15.0;

  /// The offset from top/bottom of the [widgetRenderBox] location.
  final Offset offset;
  final Color barrierColor;
  final Color mainColor;
  final CalendarContainerDecoration? containerDecoration;
  final CalendarWeekdayDecoration? weekdayDecoration;
  final CalendarMonthPickerDecoration? monthPickerDecoration;
  final CalendarHeaderDecoration? headerDecoration;

  @override
  State<CalendarPickerButton> createState() => _CalendarPickerButtonState();
}

class _CalendarPickerButtonState extends State<CalendarPickerButton>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 600);
  static const Duration kFadeInDuration = Duration(milliseconds: 600);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  late DateTime _selectedDate;

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
    _selectedDate = widget.selectedDate;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
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

  @override
  void didUpdateWidget(CalendarPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDate != _selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    isCalendarOpened = true;
    await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDate: widget.minimumDate,
      initialDate: _selectedDate,
      currentDate: widget.currentDate,
      mainColor: widget.mainColor,
      headerDecoration: widget.headerDecoration,
      containerDecoration: widget.containerDecoration,
      monthPickerDecoration: widget.monthPickerDecoration,
      weekdayDecoration: widget.weekdayDecoration,
      offset: widget.offset,
      maximumDate: widget.maximumDate,
      barrierColor: widget.barrierColor,
      verticalSpacing: widget.verticalSpacing,
      horizontalSpacing: widget.horizontalSpacing,
      onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
      onDateChanged: _onDateChanged,
    );
    isCalendarOpened = false;
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      widget.onDateChanged?.call(date);
    });
  }

  bool _buttonHeldDown = false;

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
    if (_animationController.isAnimating) {
      return;
    }
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
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final int day = _selectedDate.day;
    final int month = _selectedDate.month;
    final int year = _selectedDate.year;
    final String fullMonthString = localization.datePickerMonth(month);
    final String dayString = localization.datePickerDayOfMonth(day);
    final String monthString = fullMonthString.substring(0, 3);
    final String yearString = localization.datePickerYear(year);

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
          child: Text(
            '$monthString $dayString, $yearString',
            style: TextStyle(
              color: CupertinoDynamicColor.maybeResolve(
                isCalendarOpened ? widget.mainColor : CupertinoColors.label,
                context,
              ),
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }
}
