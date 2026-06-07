// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  bool alwaysUse24HourFormat = false,
  TextScaler textScaler = TextScaler.noScaling,
  Locale locale = const Locale('en', 'US'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const <Locale>[
      Locale('en', 'US'),
      Locale('fr'),
    ],
    home: MediaQuery(
      data: MediaQueryData(
        alwaysUse24HourFormat: alwaysUse24HourFormat,
        textScaler: textScaler,
      ),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('PackageBuildContextExtension', () {
    group('alwaysUse24hFormat', () {
      testWidgets('returns false when MediaQuery is set to 12-hour format',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final bool result = capturedContext.alwaysUse24hFormat;

        expect(result, isFalse);
      });

      testWidgets('returns true when MediaQuery is set to 24-hour format',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            alwaysUse24HourFormat: true,
          ),
        );

        final bool result = capturedContext.alwaysUse24hFormat;

        expect(result, isTrue);
      });
    });

    group('materialLocalization', () {
      testWidgets('returns a MaterialLocalizations instance',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final MaterialLocalizations result =
            capturedContext.materialLocalization;

        expect(result, isA<MaterialLocalizations>());
      });
    });

    group('cupertinoLocalization', () {
      testWidgets('returns a CupertinoLocalizations instance',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final CupertinoLocalizations result =
            capturedContext.cupertinoLocalization;

        expect(result, isA<CupertinoLocalizations>());
      });
    });

    group('locale', () {
      testWidgets('returns the locale from Localizations',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final Locale result = capturedContext.locale;

        expect(result, const Locale('en', 'US'));
      });
    });

    group('localeString', () {
      testWidgets('appends country code with underscore when present',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final String result = capturedContext.localeString;

        expect(result, 'en_US');
      });

      testWidgets('returns language code only when country code is null',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            locale: const Locale('fr'),
          ),
        );

        final String result = capturedContext.localeString;

        expect(result, 'fr');
      });
    });

    group('textScaler', () {
      testWidgets('returns the TextScaler from MediaQuery',
          (WidgetTester tester) async {
        const TextScaler scaler = TextScaler.linear(1.25);
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            textScaler: scaler,
          ),
        );

        final TextScaler result = capturedContext.textScaler;

        expect(result, scaler);
      });
    });

    group('textScaleFactor', () {
      testWidgets('returns 1.0 when no text scaling is applied',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final double result = capturedContext.textScaleFactor;

        expect(result, 1.0);
      });

      testWidgets('returns the linear scale factor from MediaQuery',
          (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            textScaler: const TextScaler.linear(1.75),
          ),
        );

        final double result = capturedContext.textScaleFactor;

        expect(result, 1.75);
      });
    });
  });
}
