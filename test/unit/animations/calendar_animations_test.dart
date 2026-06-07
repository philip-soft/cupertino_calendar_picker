// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarAnimations', () {
    group('heightAnimation', () {
      test('returns a TweenSequence<double>', () {
        final TweenSequence<double> sequence =
            CalendarAnimations.heightAnimation(height: 100.0);

        expect(sequence, isA<TweenSequence<double>>());
      });

      test('begins at 0 when evaluated at t=0', () {
        final TweenSequence<double> sequence =
            CalendarAnimations.heightAnimation(height: 100.0);

        final double value = sequence.transform(0.0);

        expect(value, 0.0);
      });

      test('ends at the final percentage of the supplied height at t=1', () {
        const double height = 100.0;
        final TweenSequence<double> sequence =
            CalendarAnimations.heightAnimation(height: height);

        final double value = sequence.transform(1.0);

        expect(value, closeTo(height, 0.0001));
      });

      test('scales output to provided height', () {
        const double height = 200.0;
        final TweenSequence<double> sequence =
            CalendarAnimations.heightAnimation(height: height);

        final double value = sequence.transform(1.0);

        expect(value, closeTo(height, 0.0001));
      });
    });

    group('generateHeightAnimation', () {
      test('produces one TweenSequenceItem per percentage entry', () {
        final List<double> percentages = <double>[50.0, 100.0];

        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateHeightAnimation(
          height: 100.0,
          percentageList: percentages,
        ).toList();

        expect(items.length, percentages.length);
      });

      test('first item begins at 0', () {
        final List<double> percentages = <double>[25.0, 75.0, 100.0];

        final TweenSequenceItem<double> first =
            CalendarAnimations.generateHeightAnimation(
          height: 100.0,
          percentageList: percentages,
        ).first;

        final Tween<double> tween = first.tween as Tween<double>;
        expect(tween.begin, 0.0);
      });

      test('successive items chain begin to previous end', () {
        final List<double> percentages = <double>[25.0, 75.0, 100.0];

        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateHeightAnimation(
          height: 100.0,
          percentageList: percentages,
        ).toList();

        final Tween<double> t0 = items[0].tween as Tween<double>;
        final Tween<double> t1 = items[1].tween as Tween<double>;
        final Tween<double> t2 = items[2].tween as Tween<double>;
        expect(t1.begin, t0.end);
        expect(t2.begin, t1.end);
      });

      test('weights are all 1.0', () {
        final List<double> percentages = <double>[50.0, 100.0];

        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateHeightAnimation(
          height: 50.0,
          percentageList: percentages,
        ).toList();

        for (final TweenSequenceItem<double> item in items) {
          expect(item.weight, 1.0);
        }
      });

      test('emits no items when percentageList is empty', () {
        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateHeightAnimation(
          height: 100.0,
          percentageList: <double>[],
        ).toList();

        expect(items, isEmpty);
      });
    });

    group('maxHeightPercentage', () {
      test('is just above 100', () {
        expect(CalendarAnimations.maxHeightPercentage, greaterThan(100));
        expect(CalendarAnimations.maxHeightPercentage, lessThan(101));
      });
    });

    group('scaleAnimation', () {
      test('returns a TweenSequence<double>', () {
        final TweenSequence<double> sequence =
            CalendarAnimations.scaleAnimation(maxScale: 1.0);

        expect(sequence, isA<TweenSequence<double>>());
      });

      test('begins at 0 when evaluated at t=0', () {
        final TweenSequence<double> sequence =
            CalendarAnimations.scaleAnimation(maxScale: 1.0);

        final double value = sequence.transform(0.0);

        expect(value, 0.0);
      });

      test('ends at maxScale when evaluated at t=1', () {
        final TweenSequence<double> sequence =
            CalendarAnimations.scaleAnimation(maxScale: 1.0);

        final double value = sequence.transform(1.0);

        expect(value, closeTo(1.0, 0.0001));
      });

      test('respects custom maxScale', () {
        const double maxScale = 2.5;
        final TweenSequence<double> sequence =
            CalendarAnimations.scaleAnimation(maxScale: maxScale);

        final double value = sequence.transform(1.0);

        expect(value, closeTo(maxScale, 0.0001));
      });
    });

    group('generateScaleAnimation', () {
      test('produces one TweenSequenceItem per value entry', () {
        final List<double> values = <double>[0.5, 1.0];

        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateScaleAnimation(
          maxScale: 1.0,
          valueList: values,
        ).toList();

        expect(items.length, values.length);
      });

      test('first item begins at 0', () {
        final TweenSequenceItem<double> first =
            CalendarAnimations.generateScaleAnimation(
          maxScale: 1.0,
          valueList: <double>[0.25, 1.0],
        ).first;

        final Tween<double> tween = first.tween as Tween<double>;
        expect(tween.begin, 0.0);
      });

      test('successive items chain begin to previous end', () {
        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateScaleAnimation(
          maxScale: 1.0,
          valueList: <double>[0.25, 0.5, 1.0],
        ).toList();

        final Tween<double> t0 = items[0].tween as Tween<double>;
        final Tween<double> t1 = items[1].tween as Tween<double>;
        final Tween<double> t2 = items[2].tween as Tween<double>;
        expect(t1.begin, t0.end);
        expect(t2.begin, t1.end);
      });

      test('end values scale by maxScale', () {
        const double maxScale = 2.0;

        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateScaleAnimation(
          maxScale: maxScale,
          valueList: <double>[0.5, 1.0],
        ).toList();

        final Tween<double> t0 = items[0].tween as Tween<double>;
        final Tween<double> t1 = items[1].tween as Tween<double>;
        expect(t0.end, 1.0);
        expect(t1.end, 2.0);
      });

      test('emits no items when valueList is empty', () {
        final List<TweenSequenceItem<double>> items =
            CalendarAnimations.generateScaleAnimation(
          maxScale: 1.0,
          valueList: <double>[],
        ).toList();

        expect(items, isEmpty);
      });
    });
  });
}
