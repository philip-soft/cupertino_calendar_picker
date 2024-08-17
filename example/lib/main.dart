import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final DateTime nowDateTime = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  /// The context comes from the `Builder` above the widget tree.
  Future<DateTime?> onTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final DateTime nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: nowDate.subtract(const Duration(days: 15)),
      initialDateTime: _selectedDate,
      maximumDateTime: nowDate.add(const Duration(days: 360)),
      onDateTimeChanged: _onDateChanged,
    );
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final minimumDateTime = nowDateTime.subtract(const Duration(days: 15));
    final maximumDateTime = nowDateTime.add(const Duration(days: 360));

    return CupertinoApp(
      title: 'Cupertino Calendar Example',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CupertinoPageScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(),
            const Spacer(flex: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoCalendarPickerButton(
                  selectedDateTime: _selectedDate,
                  mode: CupertinoCalendarMode.dateTime,
                  minimumDateTime: minimumDateTime,
                  maximumDateTime: maximumDateTime,
                  timeLabel: 'Ends',
                ),
                const SizedBox(width: 5),
                const CupertinoTimePickerButton(),
              ],
            ),
            const SizedBox(height: 15),
            Builder(
              builder: (context) {
                return GestureDetector(
                  /// Passing exactly this `BuildContext` is mandatory to get
                  /// the `RenderBox` of the appropriate widget.
                  onTap: () => onTap(context),
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill
                          .resolveFrom(context),
                    ),
                    alignment: Alignment.center,
                    child: const Text('My widget'),
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
