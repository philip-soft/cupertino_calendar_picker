import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  // timeDilation = 10.0;
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> opacity;
  late final Animation<double> scale;
  late final Animation<double> height;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.29,
          end: 0.39,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.39,
          end: 0.5,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.5,
          end: 0.61,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.61,
          end: 0.7,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.7,
          end: 0.785,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.785,
          end: 0.85,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.85,
          end: 0.9,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 0.94,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.94,
          end: 0.965,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.965,
          end: 0.985,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.985,
          end: 0.997,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.997,
          end: 1.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.01,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.01,
          end: 1.0,
        ),
        weight: 0.071,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    height = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 75.0,
          end: 110.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 110.0,
          end: 150.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 150.0,
          end: 185.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 185.0,
          end: 220.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 220.0,
          end: 245.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 245.0,
          end: 265.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 265.0,
          end: 283.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 283.0,
          end: 295.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 295.0,
          end: 305.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 305.0,
          end: 310.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 310.0,
          end: 315.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 315.0,
          end: 318.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 318.0,
          end: 319.0,
        ),
        weight: 0.071,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 319.0,
          end: calendarHeight,
        ),
        weight: 0.071,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _width = calendarWidth;
      _height = calendarHeight;
    } else {
      _width = calendarWidth - 3.0;
      _height = 75.0;
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
            child: AnimatedBuilder(
              animation: _controller,
              child: CupertinoCalendar(
                minimumDate: nowDate.subtract(const Duration(days: 15)),
                initialDate: nowDate,
                currentDate: nowDate,
                maximumDate: DateTime(2030, 02, 14),
                onDateChanged: (_) {},
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: scale.value,
                  alignment: const Alignment(0.5, 1.0),
                  child: SizedBox(
                    height: height.value,
                    child: child,
                  ),
                );
              },
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
