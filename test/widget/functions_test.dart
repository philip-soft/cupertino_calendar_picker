// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapWithApp(Widget child) {
  return CupertinoApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: CupertinoPageScaffold(child: child),
  );
}

class _Host extends StatefulWidget {
  const _Host({required this.onTap});
  final Future<void> Function(BuildContext context, RenderBox? anchor) onTap;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final GlobalKey _anchorKey = GlobalKey();

  Future<void> _handleTap() async {
    final RenderBox? box =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (!mounted) return;
    await widget.onTap(context, box);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: SizedBox(
          key: _anchorKey,
          width: 80.0,
          height: 40.0,
          child: const ColoredBox(color: Color(0xFFCCCCCC)),
        ),
      ),
    );
  }
}

void main() {
  group('showCupertinoCalendarPicker', () {
    final DateTime min = DateTime.utc(2020);
    final DateTime max = DateTime.utc(2030, 12, 31);
    final DateTime initial = DateTime.utc(2024, 6, 15);

    testWidgets('opens calendar overlay with the initial date', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              await showCupertinoCalendarPicker(
                ctx,
                widgetRenderBox: box,
                minimumDateTime: min,
                maximumDateTime: max,
                initialDateTime: initial,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(CupertinoCalendarOverlay), findsOneWidget);
      expect(find.byType(CupertinoCalendar), findsOneWidget);
    });

    testWidgets('tap outside dismisses with onOutsideTap behavior', (
      WidgetTester tester,
    ) async {
      DateTime? result;
      bool completed = false;

      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              result = await showCupertinoCalendarPicker(
                ctx,
                widgetRenderBox: box,
                minimumDateTime: min,
                maximumDateTime: max,
                initialDateTime: initial,
              );
              completed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(result, isNull);
      expect(find.byType(CupertinoCalendarOverlay), findsNothing);
    });

    testWidgets(
      'does not dismiss on outside tap when behavior is onDateSelect',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithApp(
            _Host(
              onTap: (BuildContext ctx, RenderBox? box) async {
                await showCupertinoCalendarPicker(
                  ctx,
                  widgetRenderBox: box,
                  minimumDateTime: min,
                  maximumDateTime: max,
                  initialDateTime: initial,
                  dismissBehavior: CalendarDismissBehavior.onDateSelect,
                );
              },
            ),
          ),
        );

        await tester.tap(find.byType(_Host));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        await tester.tapAt(const Offset(5.0, 5.0));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CupertinoCalendarOverlay), findsOneWidget);
      },
    );

    testWidgets('opens with dateTime mode and shows footer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              await showCupertinoCalendarPicker(
                ctx,
                widgetRenderBox: box,
                minimumDateTime: min,
                maximumDateTime: max,
                initialDateTime: initial,
                mode: CupertinoCalendarMode.dateTime,
                use24hFormat: true,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final CupertinoCalendar calendar = tester.widget<CupertinoCalendar>(
        find.byType(CupertinoCalendar),
      );
      expect(calendar.mode, CupertinoCalendarMode.dateTime);
    });

    testWidgets('opens with confirm action when actions are provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              await showCupertinoCalendarPicker(
                ctx,
                widgetRenderBox: box,
                minimumDateTime: min,
                maximumDateTime: max,
                initialDateTime: initial,
                dismissBehavior: CalendarDismissBehavior.onActionTap,
                actions: const <CupertinoCalendarAction>[
                  CancelCupertinoCalendarAction(),
                  ConfirmCupertinoCalendarAction(),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });
  });

  group('showCupertinoTimePicker', () {
    testWidgets('opens time overlay', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              await showCupertinoTimePicker(
                ctx,
                widgetRenderBox: box,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
                use24hFormat: true,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(CupertinoTimeOverlay), findsOneWidget);
      expect(find.byType(CupertinoTimePicker), findsOneWidget);
    });

    testWidgets('tap outside dismisses the time picker', (
      WidgetTester tester,
    ) async {
      bool completed = false;
      TimeOfDay? result;

      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              result = await showCupertinoTimePicker(
                ctx,
                widgetRenderBox: box,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
                use24hFormat: true,
              );
              completed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tapAt(const Offset(5.0, 5.0));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(result, isNull);
      expect(find.byType(CupertinoTimeOverlay), findsNothing);
    });

    testWidgets(
      'falls back to MediaQuery.alwaysUse24hFormat when use24hFormat is null',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: _wrapWithApp(
              _Host(
                onTap: (BuildContext ctx, RenderBox? box) async {
                  await showCupertinoTimePicker(
                    ctx,
                    widgetRenderBox: box,
                    initialTime: const TimeOfDay(hour: 10, minute: 0),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(_Host));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        final CupertinoTimeOverlay overlay =
            tester.widget<CupertinoTimeOverlay>(
          find.byType(CupertinoTimeOverlay),
        );
        expect(overlay.use24hFormat, isTrue);
      },
    );

    testWidgets('honors initialTime parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          _Host(
            onTap: (BuildContext ctx, RenderBox? box) async {
              await showCupertinoTimePicker(
                ctx,
                widgetRenderBox: box,
                initialTime: const TimeOfDay(hour: 7, minute: 30),
                use24hFormat: true,
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(_Host));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final CupertinoTimeOverlay overlay = tester.widget<CupertinoTimeOverlay>(
        find.byType(CupertinoTimeOverlay),
      );
      expect(overlay.initialTime, const TimeOfDay(hour: 7, minute: 30));
    });
  });
}
