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
  group('CalendarMonthPickerDisabledDayStyle', () {
    test('defaults to calendarMonthPickerDisabledDayStyle', () {
      final CalendarMonthPickerDisabledDayStyle style =
          CalendarMonthPickerDisabledDayStyle();

      expect(style.textStyle, calendarMonthPickerDisabledDayStyle);
    });

    test('uses supplied textStyle', () {
      const TextStyle input = TextStyle(fontSize: 14.0);

      final CalendarMonthPickerDisabledDayStyle style =
          CalendarMonthPickerDisabledDayStyle(textStyle: input);

      expect(style.textStyle, input);
    });

    test('copyWith overrides textStyle', () {
      final CalendarMonthPickerDisabledDayStyle original =
          CalendarMonthPickerDisabledDayStyle();
      const TextStyle replacement = TextStyle(fontSize: 11.0);

      final CalendarMonthPickerDisabledDayStyle? copy =
          original.copyWith(textStyle: replacement);

      expect(copy?.textStyle, replacement);
    });

    test('copyWith with no args preserves the original textStyle', () {
      const TextStyle initial = TextStyle(fontSize: 13.5);
      final CalendarMonthPickerDisabledDayStyle original =
          CalendarMonthPickerDisabledDayStyle(textStyle: initial);

      final CalendarMonthPickerDisabledDayStyle? copy = original.copyWith();

      expect(copy?.textStyle, initial);
    });

    testWidgets('withDynamicColor resolves the disabled color',
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

      final CalendarMonthPickerDisabledDayStyle style =
          CalendarMonthPickerDisabledDayStyle.withDynamicColor(ctx);

      expect(style.textStyle.color, isNotNull);
    });
  });

  group('CalendarMonthPickerDefaultDayStyle', () {
    test('defaults to calendarMonthPickerDefaultDayStyle', () {
      final CalendarMonthPickerDefaultDayStyle style =
          CalendarMonthPickerDefaultDayStyle();

      expect(style.textStyle, calendarMonthPickerDefaultDayStyle);
    });

    test('copyWith overrides textStyle', () {
      final CalendarMonthPickerDefaultDayStyle original =
          CalendarMonthPickerDefaultDayStyle();
      const TextStyle replacement = TextStyle(fontSize: 9.0);

      final CalendarMonthPickerDefaultDayStyle? copy =
          original.copyWith(textStyle: replacement);

      expect(copy?.textStyle, replacement);
    });

    test('copyWith with no args preserves the original textStyle', () {
      const TextStyle initial = TextStyle(fontSize: 12.5);
      final CalendarMonthPickerDefaultDayStyle original =
          CalendarMonthPickerDefaultDayStyle(textStyle: initial);

      final CalendarMonthPickerDefaultDayStyle? copy = original.copyWith();

      expect(copy?.textStyle, initial);
    });

    testWidgets('withDynamicColor resolves the default color',
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

      final CalendarMonthPickerDefaultDayStyle style =
          CalendarMonthPickerDefaultDayStyle.withDynamicColor(ctx);

      expect(style.textStyle.color, isNotNull);
    });
  });

  group('CalendarMonthPickerSelectedDayStyle', () {
    test('uses mainColor for textStyle and background circle when supplied',
        () {
      const Color main = Color(0xFFAA1122);

      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle(mainColor: main);

      expect(style.textStyle.color, main);
      expect(style.backgroundCircleColor, main.withAlpha(30));
    });

    test('uses supplied backgroundCircleColor over mainColor', () {
      const Color main = Color(0xFFAA1122);
      const Color override = Color(0xFF00FF00);

      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle(
        mainColor: main,
        backgroundCircleColor: override,
      );

      expect(style.backgroundCircleColor, override);
    });

    test('uses supplied textStyle verbatim', () {
      const TextStyle input = TextStyle(
        fontSize: 20.0,
        color: Color(0xFFFFAAAA),
      );

      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle(textStyle: input);

      expect(style.textStyle, input);
    });

    test('copyWith overrides textStyle', () {
      final CalendarMonthPickerSelectedDayStyle original =
          CalendarMonthPickerSelectedDayStyle();
      const TextStyle replacement = TextStyle(fontSize: 8.0);

      final CalendarMonthPickerSelectedDayStyle? copy =
          original.copyWith(textStyle: replacement);

      expect(copy?.textStyle, replacement);
    });

    test('copyWith with no args preserves the original textStyle', () {
      const TextStyle initial = TextStyle(fontSize: 11.0);
      final CalendarMonthPickerSelectedDayStyle original =
          CalendarMonthPickerSelectedDayStyle(textStyle: initial);

      final CalendarMonthPickerSelectedDayStyle? copy = original.copyWith();

      expect(copy?.textStyle, initial);
    });

    testWidgets('withDynamicColor populates background and text colors',
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

      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle.withDynamicColor(
        ctx,
        mainColor: const Color(0xFF112233),
      );

      expect(style.textStyle.color, isNotNull);
      expect(style.backgroundCircleColor, isNotNull);
    });
  });

  group('CalendarMonthPickerSelectedCurrentDayStyle', () {
    test('uses mainColor as background circle when no override is provided',
        () {
      const Color main = Color(0xFF445566);

      final CalendarMonthPickerSelectedCurrentDayStyle style =
          CalendarMonthPickerSelectedCurrentDayStyle(mainColor: main);

      expect(style.backgroundCircleColor, main);
    });

    test('uses supplied backgroundCircleColor over mainColor', () {
      const Color main = Color(0xFF445566);
      const Color override = Color(0xFFFF0000);

      final CalendarMonthPickerSelectedCurrentDayStyle style =
          CalendarMonthPickerSelectedCurrentDayStyle(
        mainColor: main,
        backgroundCircleColor: override,
      );

      expect(style.backgroundCircleColor, override);
    });

    test('defaults textStyle to calendarMonthPickerSelectedCurrentDayStyle',
        () {
      final CalendarMonthPickerSelectedCurrentDayStyle style =
          CalendarMonthPickerSelectedCurrentDayStyle();

      expect(style.textStyle, calendarMonthPickerSelectedCurrentDayStyle);
    });

    test('copyWith overrides textStyle', () {
      final CalendarMonthPickerSelectedCurrentDayStyle original =
          CalendarMonthPickerSelectedCurrentDayStyle();
      const TextStyle replacement = TextStyle(fontSize: 6.0);

      final CalendarMonthPickerSelectedCurrentDayStyle? copy =
          original.copyWith(textStyle: replacement);

      expect(copy?.textStyle, replacement);
    });

    test('copyWith with no args preserves the original textStyle', () {
      const TextStyle initial = TextStyle(fontSize: 7.5);
      final CalendarMonthPickerSelectedCurrentDayStyle original =
          CalendarMonthPickerSelectedCurrentDayStyle(textStyle: initial);

      final CalendarMonthPickerSelectedCurrentDayStyle? copy =
          original.copyWith();

      expect(copy?.textStyle, initial);
    });

    testWidgets('withDynamicColor resolves both textStyle and circle colors',
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

      final CalendarMonthPickerSelectedCurrentDayStyle style =
          CalendarMonthPickerSelectedCurrentDayStyle.withDynamicColor(
        ctx,
        mainColor: const Color(0xFF334455),
      );

      expect(style.textStyle.color, isNotNull);
      expect(style.backgroundCircleColor, isNotNull);
    });
  });

  group('CalendarMonthPickerCurrentDayStyle', () {
    test('defaults to calendarMonthPickerCurrentDayStyle', () {
      final CalendarMonthPickerCurrentDayStyle style =
          CalendarMonthPickerCurrentDayStyle();

      expect(style.textStyle, calendarMonthPickerCurrentDayStyle);
    });

    test('uses supplied textStyle', () {
      const TextStyle input = TextStyle(fontSize: 18.0);

      final CalendarMonthPickerCurrentDayStyle style =
          CalendarMonthPickerCurrentDayStyle(textStyle: input);

      expect(style.textStyle, input);
    });

    test('copyWith overrides textStyle', () {
      final CalendarMonthPickerCurrentDayStyle original =
          CalendarMonthPickerCurrentDayStyle();
      const TextStyle replacement = TextStyle(fontSize: 5.0);

      final CalendarMonthPickerCurrentDayStyle? copy =
          original.copyWith(textStyle: replacement);

      expect(copy?.textStyle, replacement);
    });

    test('copyWith with no args preserves the original textStyle', () {
      const TextStyle initial = TextStyle(fontSize: 16.5);
      final CalendarMonthPickerCurrentDayStyle original =
          CalendarMonthPickerCurrentDayStyle(textStyle: initial);

      final CalendarMonthPickerCurrentDayStyle? copy = original.copyWith();

      expect(copy?.textStyle, initial);
    });

    testWidgets(
        'withDynamicColor falls back to mainColor when style has no '
        'explicit color', (WidgetTester tester) async {
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

      const Color main = Color(0xFF010203);
      final CalendarMonthPickerCurrentDayStyle style =
          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
        ctx,
        mainColor: main,
      );

      expect(style.textStyle.color, main);
    });

    testWidgets(
        'withDynamicColor returns resolved color when explicit textStyle '
        'color is provided', (WidgetTester tester) async {
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

      const TextStyle input = TextStyle(color: Color(0xFF010101));
      final CalendarMonthPickerCurrentDayStyle style =
          CalendarMonthPickerCurrentDayStyle.withDynamicColor(
        ctx,
        textStyle: input,
      );

      expect(style.textStyle.color, const Color(0xFF010101));
    });
  });
}
