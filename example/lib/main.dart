import 'dart:developer';

import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'layout_playground.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Cupertino Calendar Example',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late final DateTime _minimumDateTime;
  late final DateTime _maximumDateTime;
  late DateTime _selectedDateTime;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _minimumDateTime = now.subtract(const Duration(days: 40));
    _maximumDateTime = now.add(const Duration(days: 365));
    _selectedDateTime = now;
    _selectedTime = TimeOfDay.fromDateTime(now);
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() => _selectedDateTime = dateTime);
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() => _selectedTime = time);
  }

  /// Opens a calendar picker next to the widget of [context].
  Future<void> _openCalendarPicker(BuildContext context) async {
    final DateTime? dateTime = await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: context.findRenderObject() as RenderBox?,
      minimumDateTime: _minimumDateTime,
      maximumDateTime: _maximumDateTime,
      initialDateTime: _selectedDateTime,
      mode: CupertinoCalendarMode.dateTime,
      timeLabel: 'Ends',
      onDateTimeChanged: _onDateTimeChanged,
    );
    log('Calendar picker closed with $dateTime');
  }

  /// Opens a time picker next to the widget of [context].
  Future<void> _openTimePicker(BuildContext context) async {
    final TimeOfDay? time = await showCupertinoTimePicker(
      context,
      widgetRenderBox: context.findRenderObject() as RenderBox?,
      initialTime: _selectedTime,
      onTimeChanged: _onTimeChanged,
    );
    log('Time picker closed with $time');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Cupertino Calendar Picker'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (_) => const LayoutPlaygroundPage(),
            ),
          ),
          child: const Text('Layout'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            _Section(
              title: 'Inline calendar',
              child: SizedBox(
                width: 350,
                child: CupertinoCalendar(
                  minimumDateTime: _minimumDateTime,
                  maximumDateTime: _maximumDateTime,
                  initialDateTime: _selectedDateTime,
                  mode: CupertinoCalendarMode.dateTime,
                  timeLabel: 'Ends',
                  onDateTimeChanged: _onDateTimeChanged,
                ),
              ),
            ),
            _Section(
              title: 'Picker buttons',
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  CupertinoCalendarPickerButton(
                    minimumDateTime: _minimumDateTime,
                    maximumDateTime: _maximumDateTime,
                    initialDateTime: _selectedDateTime,
                    mode: CupertinoCalendarMode.dateTime,
                    timeLabel: 'Ends',
                    onDateTimeChanged: _onDateTimeChanged,
                  ),
                  CupertinoTimePickerButton(
                    initialTime: _selectedTime,
                    onTimeChanged: _onTimeChanged,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Your own widgets',
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _AnchorTile(
                    title: 'Open calendar',
                    onTap: _openCalendarPicker,
                  ),
                  _AnchorTile(
                    title: 'Open time picker',
                    onTap: _openTimePicker,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Cancel and confirm actions',
              child: CupertinoCalendarPickerButton(
                minimumDateTime: _minimumDateTime,
                maximumDateTime: _maximumDateTime,
                initialDateTime: _selectedDateTime,
                // The picker closes only when an action is pressed.
                dismissBehavior: CalendarDismissBehavior.onActionTap,
                actions: [
                  // Without a label, the actions are labeled "Cancel" and
                  // "OK" in the app's language.
                  CancelCupertinoCalendarAction(
                    onPressed: () => log('Canceled'),
                  ),
                  ConfirmCupertinoCalendarAction(
                    isDefaultAction: true,
                    onPressed: _onDateTimeChanged,
                  ),
                ],
                onCompleted: (dateTime) => log('Confirmed $dateTime'),
              ),
            ),
            _Section(
              title: 'Custom look',
              child: CupertinoCalendarPickerButton(
                minimumDateTime: _minimumDateTime,
                maximumDateTime: _maximumDateTime,
                initialDateTime: _selectedDateTime,
                // Only weekdays can be selected.
                selectableDayPredicate: (date) =>
                    date.weekday != DateTime.saturday &&
                    date.weekday != DateTime.sunday,
                // The week starts on Monday.
                firstDayOfWeekIndex: 1,
                mainColor: CupertinoColors.systemIndigo,
                containerDecoration: PickerContainerDecoration(
                  backgroundType: PickerBackgroundType.plainColor,
                ),
                dismissBehavior:
                    CalendarDismissBehavior.onOutsideTapOrDateSelect,
                onDateTimeChanged: _onDateTimeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A titled block of the example page.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 28.0),
      child: Column(
        children: [
          Text(
            title,
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          const SizedBox(height: 12.0),
          Center(child: child),
        ],
      ),
    );
  }
}

/// A custom widget the pickers open next to.
class _AnchorTile extends StatelessWidget {
  const _AnchorTile({required this.title, required this.onTap});

  final String title;

  /// Receives the context of this widget, so the picker can find its
  /// `RenderBox` and open next to it.
  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(title),
      ),
    );
  }
}
