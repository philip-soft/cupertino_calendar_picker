import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  // timeDilation = 5.0;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        // brightness: Brightness.light,
        brightness: Brightness.dark,
      ),
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      locale: const Locale('en'),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final nowDate = DateTime.now();

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 225.0,
            right: 22.0,
            child: CupertinoCalendar(
              minimumDate: nowDate.subtract(const Duration(days: 15)),
              initialDate: nowDate,
              currentDate: nowDate,
              maximumDate: DateTime(2030, 02, 14),
              onDateChanged: (_) {},
            ),
          ),
          Positioned(
            top: 450.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              // onTap: _toggleAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 34.0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: CupertinoDynamicColor.resolve(
                        CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.tertiarySystemFill,
                          darkColor:
                              CupertinoColors.tertiarySystemFill.darkColor,
                        ),
                        context,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('MMM dd,').format(DateTime(2023, 08, 23)),
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          DateFormat('yyyy').format(DateTime(2023, 08, 23)),
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
