import 'package:cupertino_calendar/cupertino_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
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
      showPerformanceOverlay: true,
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
      backgroundColor: CupertinoColors.systemGrey,
      body: Center(
        child: Stack(
          children: [
            const SizedBox(height: 50.0),
            CupertinoCalendar(
              minimumDate: nowDate.subtract(const Duration(days: 90)),
              initialDate: DateTime(2026, 02, 16),
              currentDate: DateTime(2026, 02, 14),
              maximumDate: DateTime(2030, 02, 14),
              onDateChanged: (_) {},
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
