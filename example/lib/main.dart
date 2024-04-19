import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // timeDilation = 8.0;
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
  final key = GlobalKey();

  Offset _position = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final nowDate = DateTime.now();

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 500,
                  left: 150,
                  // right: 100,
                  bottom: 100,
                ),
                child: Center(
                  child: FloatingActionButton(
                    key: key,
                    onPressed: () {
                      final screenSize = MediaQuery.sizeOf(context);
                      final screenWidth = screenSize.width;
                      final screenHeight = screenSize.height;

                      final box =
                          key.currentContext?.findRenderObject() as RenderBox?;
                      final position =
                          box?.localToGlobal(Offset.zero) ?? Offset.zero;

                      final widgetSize = box?.size ?? Size.zero;
                      final canFitForTop = position.dy >= calendarHeight;
                      final canFitForLeft = position.dx >= calendarWidth;
                      final canFitForRight =
                          screenWidth - position.dx >= calendarWidth;
                      final canFitForBottom =
                          screenHeight - position.dy >= calendarHeight;
                      print('TOP: $canFitForTop');
                      print('LEFT: $canFitForLeft');
                      print('RIGHT: $canFitForRight');
                      print('BOTTOM: $canFitForBottom');

                      double addH = 0.0;
                      final double addW = (widgetSize.width / 2) - 2.5;

                      late Alignment scaleAligment;

                      if (canFitForTop) {
                        addH = 0.0;
                        scaleAligment = Alignment.topCenter;
                      }

                      if (canFitForBottom) {
                        addH = widgetSize.height;
                        scaleAligment = Alignment.bottomCenter;
                      }

                      setState(() {
                        _position = Offset(
                          position.dx + addW,
                          position.dy + addH,
                        );
                      });

                      double? top =
                          canFitForTop ? position.dy - calendarHeight : null;
                      double? left = canFitForLeft ? 5.0 : null;
                      double? right = canFitForRight ? 5.0 : null;
                      double? bottom = canFitForBottom
                          ? screenHeight - calendarHeight - position.dy
                          : null;

                      if (top != null) {
                        top = top - addH + 10;
                        bottom = null;
                      }

                      if (bottom != null) {
                        bottom = bottom - addH - 10;
                        top = null;
                      }

                      if (left != null) {
                        left = left + addW;
                      }

                      if (right != null) {
                        right = right - addW;
                      }

                      if (right == null && left == null) {
                        left = 10;
                      }

                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: '',
                        barrierColor: Colors.transparent,
                        transitionDuration: Duration.zero,
                        // transitionDuration: const Duration(milliseconds: 430),
                        transitionBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return child;
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: top,
                                left: left,
                                right: right,
                                bottom: bottom,
                                child: Material(
                                  color: Colors.transparent,
                                  child: CupertinoCalendar(
                                    minimumDate: nowDate
                                        .subtract(const Duration(days: 15)),
                                    initialDate: nowDate,
                                    currentDate: nowDate,
                                    maximumDate: DateTime(2030, 02, 14),
                                    onDateChanged: (_) {},
                                    scaleAlignment: scaleAligment,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                left: _position.dx,
                top: _position.dy,
                child: Center(
                  child: Container(
                    height: 5,
                    width: 5,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 200),
          // Positioned(
          //   top: 450.0,
          //   bottom: 0.0,
          //   left: 0.0,
          //   right: 0.0,
          //   child: GestureDetector(
          //     // onTap: _toggleAnimation,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Container(
          //           height: 34.0,
          //           alignment: Alignment.center,
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 11.0,
          //             vertical: 6.0,
          //           ),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6.0),
          //             color: CupertinoDynamicColor.resolve(
          //               CupertinoDynamicColor.withBrightness(
          //                 color: CupertinoColors.tertiarySystemFill,
          //                 darkColor:
          //                     CupertinoColors.tertiarySystemFill.darkColor,
          //               ),
          //               context,
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               Text(
          //                 DateFormat('MMM dd,').format(DateTime(2023, 08, 23)),
          //                 style: const TextStyle(
          //                   fontSize: 17.0,
          //                   fontWeight: FontWeight.w400,
          //                   color: CupertinoColors.systemRed,
          //                 ),
          //               ),
          //               const SizedBox(width: 5.0),
          //               Text(
          //                 DateFormat('yyyy').format(DateTime(2023, 08, 23)),
          //                 style: const TextStyle(
          //                   fontSize: 17.0,
          //                   fontWeight: FontWeight.w400,
          //                   color: CupertinoColors.systemRed,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         const SizedBox(width: 25.0),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
