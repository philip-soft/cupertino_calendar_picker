// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a [CupertinoTimePicker] in a [CupertinoPickerOverlay].
///
/// The route completes with the last changed time, or `null` if the time
/// was not changed.
class CupertinoTimeOverlay extends StatefulWidget {
  const CupertinoTimeOverlay({
    required this.minuteInterval,
    required this.use24hFormat,
    this.widgetRenderBox,
    this.horizontalSpacing = pickerDefaultHorizontalSpacing,
    this.verticalSpacing = pickerDefaultVerticalSpacing,
    this.offset = pickerDefaultOffset,
    this.initialTime,
    this.minimumTime,
    this.maximumTime,
    this.containerDecoration,
    this.onTimeChanged,
    super.key,
  });

  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset offset;
  final RenderBox? widgetRenderBox;

  /// The initially selected time, clamped to the range.
  ///
  /// Defaults to [TimeOfDay.now].
  final TimeOfDay? initialTime;
  final TimeOfDay? minimumTime;
  final TimeOfDay? maximumTime;
  final PickerContainerDecoration? containerDecoration;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final int minuteInterval;
  final bool use24hFormat;

  @override
  State<CupertinoTimeOverlay> createState() => _CupertinoTimeOverlayState();
}

class _CupertinoTimeOverlayState extends State<CupertinoTimeOverlay> {
  late final TimeOfDay _initialTime;
  TimeOfDay? _changedTime;

  @override
  void initState() {
    super.initState();
    final TimeOfDay? minimumTime = widget.minimumTime;
    final TimeOfDay? maximumTime = widget.maximumTime;
    assert(
      minimumTime == null ||
          maximumTime == null ||
          !maximumTime.isBefore(minimumTime),
      'maximumTime $maximumTime must be on or after minimumTime $minimumTime.',
    );
    final TimeOfDay? initialTime = widget.initialTime;
    assert(
      initialTime == null ||
          initialTime.clampTo(minimumTime, maximumTime) == initialTime,
      'initialTime $initialTime must be within the range '
      '$minimumTime...$maximumTime.',
    );
    _initialTime = (widget.initialTime ?? TimeOfDay.now()).clampTo(
      widget.minimumTime,
      widget.maximumTime,
    );
  }

  void _onTimeChanged(DateTime dateTime) {
    final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
    _changedTime = time;
    widget.onTimeChanged?.call(time);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPickerOverlay(
      containerDecoration: widget.containerDecoration,
      widgetRenderBox: widget.widgetRenderBox,
      height: timePickerHeight,
      width: timePickerWidth,
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      offset: widget.offset,
      dismissResult: () => _changedTime,
      semanticsLabel: context.materialLocalization.timePickerDialHelpText,
      child: CupertinoTimePicker(
        initialTime: _initialTime,
        minimumTime: widget.minimumTime,
        maximumTime: widget.maximumTime,
        onTimeChanged: _onTimeChanged,
        minuteInterval: widget.minuteInterval,
        use24hFormat: widget.use24hFormat,
      ),
    );
  }
}
