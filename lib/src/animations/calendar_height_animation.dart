import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

final TweenSequence<double> heightAnimation =
    TweenSequence<double>(<TweenSequenceItem<double>>[
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 75.0,
      end: 110.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 110.0,
      end: 150.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 150.0,
      end: 185.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 185.0,
      end: 220.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 220.0,
      end: 245.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 245.0,
      end: 265.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 265.0,
      end: 283.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 283.0,
      end: 295.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 295.0,
      end: 305.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 305.0,
      end: 310.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 310.0,
      end: 315.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 315.0,
      end: 320.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 320.0,
      end: 325.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 325.0,
      end: 328.0,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 328.0,
      end: calendarHeight,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: calendarHeight,
      end: calendarMaxHeight,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: calendarMaxHeight,
      end: calendarHeight,
    ),
    weight: 1.0,
  ),
]);
