// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

void main() {
  group('PickerContainerDecoration', () {
    test('copyWith keeps the background type and color', () {
      // Arrange
      final PickerContainerDecoration decoration = PickerContainerDecoration(
        backgroundType: PickerBackgroundType.plainColor,
        backgroundColor: const Color(0xFF112233),
      );

      // Act
      final PickerContainerDecoration copy = decoration.copyWith(
        borderRadius: BorderRadius.circular(4.0),
      );

      // Assert
      expect(copy.backgroundType, PickerBackgroundType.plainColor);
      expect(copy.backgroundColor, const Color(0xFF112233));
      expect(copy.borderRadius, BorderRadius.circular(4.0));
    });

    test('copyWith can change the background type', () {
      final PickerContainerDecoration copy = PickerContainerDecoration(
        backgroundType: PickerBackgroundType.plainColor,
      ).copyWith(backgroundType: PickerBackgroundType.transparentAndBlurred);

      expect(copy.backgroundType, PickerBackgroundType.transparentAndBlurred);
    });

    test('supports value equality', () {
      expect(
        PickerContainerDecoration(backgroundColor: const Color(0xFF000000)),
        PickerContainerDecoration(backgroundColor: const Color(0xFF000000)),
      );
    });
  });

  group('day styles', () {
    test('selected day copyWith keeps the background circle color', () {
      final CalendarMonthPickerSelectedDayStyle style =
          CalendarMonthPickerSelectedDayStyle(
            mainColor: const Color(0xFFFF0000),
          );

      final CalendarMonthPickerSelectedDayStyle copy = style.copyWith(
        textStyle: const TextStyle(fontSize: 10.0),
      );

      expect(copy.backgroundCircleColor, style.backgroundCircleColor);
      expect(copy.textStyle.fontSize, 10.0);
    });

    test('selected current day copyWith keeps the background circle color', () {
      final CalendarMonthPickerSelectedCurrentDayStyle style =
          CalendarMonthPickerSelectedCurrentDayStyle(
            mainColor: const Color(0xFFFF0000),
          );

      final CalendarMonthPickerSelectedCurrentDayStyle copy = style.copyWith(
        textStyle: const TextStyle(fontSize: 10.0),
      );

      expect(copy.backgroundCircleColor, const Color(0xFFFF0000));
    });

    test('copyWith can override the background circle color', () {
      final CalendarMonthPickerSelectedDayStyle copy =
          CalendarMonthPickerSelectedDayStyle(
            mainColor: const Color(0xFFFF0000),
          ).copyWith(backgroundCircleColor: const Color(0xFF00FF00));

      expect(copy.backgroundCircleColor, const Color(0xFF00FF00));
    });

    test('styles support value equality', () {
      expect(
        CalendarMonthPickerDefaultDayStyle(),
        CalendarMonthPickerDefaultDayStyle(),
      );
      expect(
        CalendarMonthPickerSelectedDayStyle(mainColor: const Color(0xFF0000FF)),
        CalendarMonthPickerSelectedDayStyle(mainColor: const Color(0xFF0000FF)),
      );
    });
  });

  group('value equality', () {
    test('all decorations compare by value', () {
      expect(CalendarHeaderDecoration(), CalendarHeaderDecoration());
      expect(CalendarFooterDecoration(), CalendarFooterDecoration());
      expect(CalendarWeekdayDecoration(), CalendarWeekdayDecoration());
      expect(
        const CalendarMonthPickerDecoration(),
        const CalendarMonthPickerDecoration(),
      );
      expect(PickerButtonDecoration(), PickerButtonDecoration());
      expect(CalendarActionDecoration(), CalendarActionDecoration());
    });
  });

  group('CalendarMonthPickerDecoration', () {
    test('copyWith replaces only the provided styles', () {
      final CalendarMonthPickerDefaultDayStyle defaultStyle =
          CalendarMonthPickerDefaultDayStyle();
      final CalendarMonthPickerDisabledDayStyle disabledStyle =
          CalendarMonthPickerDisabledDayStyle();
      final CalendarMonthPickerDecoration decoration =
          CalendarMonthPickerDecoration(defaultDayStyle: defaultStyle);

      final CalendarMonthPickerDecoration copy = decoration.copyWith(
        disabledDayStyle: disabledStyle,
      );

      expect(copy.defaultDayStyle, defaultStyle);
      expect(copy.disabledDayStyle, disabledStyle);
      expect(copy, isNot(decoration));
      expect(
        copy,
        CalendarMonthPickerDecoration(
          defaultDayStyle: defaultStyle,
          disabledDayStyle: disabledStyle,
        ),
      );
      expect(
        copy.hashCode,
        CalendarMonthPickerDecoration(
          defaultDayStyle: defaultStyle,
          disabledDayStyle: disabledStyle,
        ).hashCode,
      );
    });
  });

  group('CalendarHeaderDecoration', () {
    test('copyWith replaces only the provided colors', () {
      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration();

      final CalendarHeaderDecoration copy = decoration.copyWith(
        forwardButtonColor: const Color(0xFF00FF00),
      );

      expect(copy.forwardButtonColor, const Color(0xFF00FF00));
      expect(copy.backwardButtonColor, decoration.backwardButtonColor);
      expect(copy, isNot(decoration));
      expect(copy.copyWith(), copy);
      expect(copy.copyWith().hashCode, copy.hashCode);
    });

    test('defaults navigation colors to the default main color', () {
      final CalendarHeaderDecoration decoration = CalendarHeaderDecoration();

      expect(decoration.forwardButtonColor, CupertinoColors.systemRed);
      expect(decoration.backwardButtonColor, CupertinoColors.systemRed);
      expect(decoration.monthDateArrowColor, CupertinoColors.systemRed);
    });
  });

  group('dynamic colors of plain decorations', () {
    testWidgets('are resolved against the current brightness', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        wrapTestWidget(
          CalendarFooter(
            time: const TimeOfDay(hour: 9, minute: 30),
            isTimePickerVisible: false,
            onTimePickerStateChanged: (_) {},
            onTimeChanged: (_) {},
            type: CupertinoCalendarType.inline,
            label: 'Label',
            mainColor: CupertinoColors.systemRed,
            decoration: CalendarFooterDecoration(),
            use24hFormat: true,
          ),
          brightness: Brightness.dark,
          textDirection: TextDirection.ltr,
          locale: const Locale('en', 'US'),
        ),
      );

      // Act
      final RichText label = tester.widget<RichText>(
        find.descendant(
          of: find.text('Label'),
          matching: find.byType(RichText),
        ),
      );

      // Assert
      expect(
        label.text.style?.color?.toARGB32(),
        CupertinoColors.label.darkColor.toARGB32(),
      );
    });
  });

  group('timeFormat', () {
    testWidgets('uses the ambient locale', (WidgetTester tester) async {
      String? formatted;
      await tester.pumpWidget(
        wrapTestWidget(
          Builder(
            builder: (BuildContext context) {
              formatted = const TimeOfDay(
                hour: 13,
                minute: 5,
              ).timeFormat(context, use24hFormat: false);
              return const SizedBox();
            },
          ),
          brightness: Brightness.light,
          textDirection: TextDirection.rtl,
          locale: const Locale('ar'),
        ),
      );

      expect(formatted, contains('م'));
    });
  });
}
