import 'package:flutter/cupertino.dart';

final TweenSequence<double> scaleReverseAnimation =
    TweenSequence<double>(<TweenSequenceItem<double>>[
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 1.0,
      end: 0.995,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.995,
      end: 0.96,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.96,
      end: 0.885,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.885,
      end: 0.795,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.795,
      end: 0.696,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.696,
      end: 0.605,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.605,
      end: 0.522,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.522,
      end: 0.45,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.45,
      end: 0.385,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.385,
      end: 0.34,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.34,
      end: 0.3,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.3,
      end: 0.24,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.24,
      end: 0.23,
    ),
    weight: 1.0,
  ),
  TweenSequenceItem<double>(
    tween: Tween<double>(
      begin: 0.23,
      end: 0.0,
    ),
    weight: 1.0,
  ),
]);
