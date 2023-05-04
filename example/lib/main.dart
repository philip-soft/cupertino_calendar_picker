import 'package:cupertino_kit_example/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
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
  void _changeTheme() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  Brightness _brightness = Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      locale: const Locale('en'),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        changeTheme: _changeTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    required this.changeTheme,
    super.key,
  });

  final String title;
  final VoidCallback changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey,
      child: Center(
        child: Stack(
          children: [
            const SizedBox(height: 50.0),
            CupertinoTheme(
              data: const CupertinoThemeData(brightness: Brightness.light),
              child: CupertinoCalendar(
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                currentDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 35)),
                onDateChanged: (_) {},
              ),
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
