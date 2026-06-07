// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('DayPeriodExtension', () {
    testWidgets('returns AM abbreviation for DayPeriod.am',
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

      final String result = DayPeriod.am.localizedString(capturedContext);

      final String expected =
          CupertinoLocalizations.of(capturedContext).anteMeridiemAbbreviation;
      expect(result, expected);
      expect(result, 'AM');
    });

    testWidgets('returns PM abbreviation for DayPeriod.pm',
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

      final String result = DayPeriod.pm.localizedString(capturedContext);

      final String expected =
          CupertinoLocalizations.of(capturedContext).postMeridiemAbbreviation;
      expect(result, expected);
      expect(result, 'PM');
    });
  });
}
