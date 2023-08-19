import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 400);

    _controller = AnimationController(
      vsync: this,
      duration: duration,
      value: 1.0,
      lowerBound: 0.3,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: duration,
      value: 1.0,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isExpanded) {
      _controller.reverse();
      _fadeController.reverse();
    } else {
      _controller.forward();
      _fadeController.forward();
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _width = calendarWidth;
      _height = calendarHeight;
    } else {
      _width = 204.0;
      _height = 94.0;
    }

    setState(() {});
  }

  double _width = calendarWidth;
  double _height = calendarHeight;

  @override
  Widget build(BuildContext context) {
    final nowDate = DateTime.now();

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 211.0,
            right: 30.0,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _fadeController,
                curve: Curves.easeInOut,
              ),
              child: ScaleTransition(
                scale: TweenSequence<double>([
                  TweenSequenceItem(
                    tween: Tween(
                      begin: 0.0,
                      end: 1.0,
                    ),
                    weight: 0.8,
                  ),
                  TweenSequenceItem(
                    tween: Tween(
                      begin: 1.0,
                      end: 1.05,
                    ),
                    weight: 0.1,
                  ),
                  TweenSequenceItem(
                    tween: Tween(
                      begin: 1.05,
                      end: 1.0,
                    ),
                    weight: 0.1,
                  ),
                ]).animate(_controller),
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: _controller.duration!,
                  curve: Curves.easeInOut,
                  height: _height,
                  child: CupertinoCalendar(
                    minimumDate: nowDate.subtract(const Duration(days: 15)),
                    initialDate: nowDate,
                    currentDate: nowDate,
                    maximumDate: DateTime(2030, 02, 14),
                    onDateChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 500.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: _toggleAnimation,
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
