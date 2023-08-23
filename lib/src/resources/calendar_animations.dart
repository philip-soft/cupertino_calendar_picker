import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/material.dart';

class CalendarAnimations {
  const CalendarAnimations._();

  static final TweenSequence<double> scaleAnimation =
      TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: 0.29,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.29,
        end: 0.39,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.39,
        end: 0.5,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.5,
        end: 0.61,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.61,
        end: 0.7,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.7,
        end: 0.785,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.785,
        end: 0.85,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.85,
        end: 0.9,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.9,
        end: 0.94,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.94,
        end: 0.965,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.965,
        end: 0.985,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.985,
        end: 0.997,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.997,
        end: 1.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 1.0,
        end: 1.01,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 1.01,
        end: 1.0,
      ),
      weight: 0.0666,
    ),
  ]);

  static final TweenSequence<double> heightAnimation =
      TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: 75.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 75.0,
        end: 110.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 110.0,
        end: 150.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 150.0,
        end: 185.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 185.0,
        end: 220.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 220.0,
        end: 245.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 245.0,
        end: 265.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 265.0,
        end: 283.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 283.0,
        end: 295.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 295.0,
        end: 305.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 305.0,
        end: 310.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 310.0,
        end: 315.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 315.0,
        end: 318.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 318.0,
        end: 319.0,
      ),
      weight: 0.0666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 319.0,
        end: calendarHeight,
      ),
      weight: 0.0666,
    ),
  ]);

  static final TweenSequence<double> scaleReverseAnimation =
      TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 1.0,
        end: 0.995,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.995,
        end: 0.96,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.96,
        end: 0.885,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.885,
        end: 0.795,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.795,
        end: 0.696,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.696,
        end: 0.605,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.605,
        end: 0.522,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.522,
        end: 0.45,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.45,
        end: 0.385,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.385,
        end: 0.34,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.34,
        end: 0.3,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.3,
        end: 0.24,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.24,
        end: 0.23,
      ),
      weight: 0.07142,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0.23,
        end: 0.0,
      ),
      weight: 0.07142,
    ),
  ]);

  static final TweenSequence<double> heightReverseAnimation =
      TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: calendarHeight,
        end: 303.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 303.0,
        end: 278.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 278.0,
        end: 247.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 247.0,
        end: 215.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 215.0,
        end: 184.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 184.0,
        end: 156.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 156.0,
        end: 132.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 132.0,
        end: 113.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 113.0,
        end: 96.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 96.0,
        end: 81.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 81.0,
        end: 60.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 60.0,
        end: 50.0,
      ),
      weight: 0.07692,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 50.0,
        end: 0.0,
      ),
      weight: 0.07692,
    ),
  ]);
}
