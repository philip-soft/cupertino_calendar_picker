// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('CupertinoCalendarActionWidget', () {
    testWidgets('renders the action label', (WidgetTester tester) async {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('uses bold label style for the default action', (
      WidgetTester tester,
    ) async {
      const ConfirmCupertinoCalendarAction action =
          ConfirmCupertinoCalendarAction();

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.text('Done'));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('uses regular weight style for non-default action', (
      WidgetTester tester,
    ) async {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.text('Cancel'));
      expect(text.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('invokes onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      CupertinoCalendarAction? received;
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (CupertinoCalendarAction a) => received = a,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(received, equals(action));
    });

    testWidgets('changes background color while pressed', (
      WidgetTester tester,
    ) async {
      const CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction();

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      ColoredBox getColoredBox() {
        return tester.widget<ColoredBox>(
          find
              .descendant(
                of: find.byType(CupertinoCalendarActionWidget),
                matching: find.byType(ColoredBox),
              )
              .first,
        );
      }

      expect(getColoredBox().color, const Color(0x00000000));

      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.text('Cancel')),
      );
      await tester.pump();

      expect(getColoredBox().color, isNot(const Color(0x00000000)));

      await gesture.up();
      await tester.pump();
    });

    testWidgets(
      'cancelling a press restores the transparent background',
      (WidgetTester tester) async {
        const CancelCupertinoCalendarAction action =
            CancelCupertinoCalendarAction();

        await tester.pumpWidget(
          wrapWithApp(
            SizedBox(
              height: 44.0,
              child: Row(
                children: <Widget>[
                  CupertinoCalendarActionWidget(
                    action: action,
                    onPressed: (_) {},
                  ),
                ],
              ),
            ),
          ),
        );

        ColoredBox getColoredBox() {
          return tester.widget<ColoredBox>(
            find
                .descendant(
                  of: find.byType(CupertinoCalendarActionWidget),
                  matching: find.byType(ColoredBox),
                )
                .first,
          );
        }

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(find.text('Cancel')),
        );
        await tester.pump();
        expect(getColoredBox().color, isNot(const Color(0x00000000)));

        await gesture.moveBy(const Offset(0, 500));
        await tester.pump();
        await gesture.cancel();
        await tester.pump();

        expect(getColoredBox().color, const Color(0x00000000));
      },
    );

    testWidgets('uses custom decoration when provided', (
      WidgetTester tester,
    ) async {
      final CalendarActionDecoration custom = CalendarActionDecoration(
        labelStyle:
            const TextStyle(fontSize: 22.0, color: CupertinoColors.activeBlue),
        pressedColor: CupertinoColors.activeOrange,
      );
      final CancelCupertinoCalendarAction action =
          CancelCupertinoCalendarAction(
        decoration: custom,
      );

      await tester.pumpWidget(
        wrapWithApp(
          SizedBox(
            height: 44.0,
            child: Row(
              children: <Widget>[
                CupertinoCalendarActionWidget(
                  action: action,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.text('Cancel'));
      expect(text.style?.fontSize, 22.0);
    });
  });
}
