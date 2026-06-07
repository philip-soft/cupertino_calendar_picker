// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return CupertinoApp(
    theme: CupertinoThemeData(brightness: brightness),
    home: child,
  );
}

void main() {
  group('CalendarMonthPickerDecoration', () {
    test('default factory leaves all day styles null', () {
      final CalendarMonthPickerDecoration decoration =
          CalendarMonthPickerDecoration();

      expect(decoration.defaultDayStyle, isNull);
      expect(decoration.currentDayStyle, isNull);
      expect(decoration.selectedDayStyle, isNull);
      expect(decoration.selectedCurrentDayStyle, isNull);
      expect(decoration.disabledDayStyle, isNull);
    });

    test('stores provided styles', () {
      final CalendarMonthPickerDefaultDayStyle defaultStyle =
          CalendarMonthPickerDefaultDayStyle();
      final CalendarMonthPickerCurrentDayStyle currentStyle =
          CalendarMonthPickerCurrentDayStyle();
      final CalendarMonthPickerSelectedDayStyle selectedStyle =
          CalendarMonthPickerSelectedDayStyle();
      final CalendarMonthPickerSelectedCurrentDayStyle selectedCurrentStyle =
          CalendarMonthPickerSelectedCurrentDayStyle();
      final CalendarMonthPickerDisabledDayStyle disabledStyle =
          CalendarMonthPickerDisabledDayStyle();

      final CalendarMonthPickerDecoration decoration =
          CalendarMonthPickerDecoration(
        defaultDayStyle: defaultStyle,
        currentDayStyle: currentStyle,
        selectedDayStyle: selectedStyle,
        selectedCurrentDayStyle: selectedCurrentStyle,
        disabledDayStyle: disabledStyle,
      );

      expect(decoration.defaultDayStyle, defaultStyle);
      expect(decoration.currentDayStyle, currentStyle);
      expect(decoration.selectedDayStyle, selectedStyle);
      expect(decoration.selectedCurrentDayStyle, selectedCurrentStyle);
      expect(decoration.disabledDayStyle, disabledStyle);
    });

    group('copyWith', () {
      test('preserves selectedDayStyle and disabledDayStyle when not provided',
          () {
        final CalendarMonthPickerSelectedDayStyle selectedStyle =
            CalendarMonthPickerSelectedDayStyle();
        final CalendarMonthPickerDisabledDayStyle disabledStyle =
            CalendarMonthPickerDisabledDayStyle();
        final CalendarMonthPickerDecoration original =
            CalendarMonthPickerDecoration(
          selectedDayStyle: selectedStyle,
          disabledDayStyle: disabledStyle,
        );

        final CalendarMonthPickerDecoration copy = original.copyWith();

        expect(copy.selectedDayStyle, selectedStyle);
        expect(copy.disabledDayStyle, disabledStyle);
      });

      test('overrides selectedDayStyle when provided', () {
        final CalendarMonthPickerSelectedDayStyle initial =
            CalendarMonthPickerSelectedDayStyle();
        final CalendarMonthPickerSelectedDayStyle replacement =
            CalendarMonthPickerSelectedDayStyle(
          mainColor: const Color(0xFF000000),
        );
        final CalendarMonthPickerDecoration original =
            CalendarMonthPickerDecoration(selectedDayStyle: initial);

        final CalendarMonthPickerDecoration copy = original.copyWith(
          selectedDayStyle: replacement,
        );

        expect(copy.selectedDayStyle, replacement);
      });
    });

    group('withDynamicColor', () {
      testWidgets('populates every day style with non-null instances',
          (WidgetTester tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                ctx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final CalendarMonthPickerDecoration decoration =
            CalendarMonthPickerDecoration.withDynamicColor(ctx);

        expect(decoration.defaultDayStyle, isNotNull);
        expect(decoration.currentDayStyle, isNotNull);
        expect(decoration.selectedDayStyle, isNotNull);
        expect(decoration.selectedCurrentDayStyle, isNotNull);
        expect(decoration.disabledDayStyle, isNotNull);
      });

      testWidgets('respects pre-supplied styles instead of recreating them',
          (WidgetTester tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(
          _wrap(
            Builder(
              builder: (BuildContext context) {
                ctx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        final CalendarMonthPickerDefaultDayStyle defaultStyle =
            CalendarMonthPickerDefaultDayStyle();

        final CalendarMonthPickerDecoration decoration =
            CalendarMonthPickerDecoration.withDynamicColor(
          ctx,
          defaultDayStyle: defaultStyle,
        );

        expect(decoration.defaultDayStyle, defaultStyle);
      });
    });
  });
}
