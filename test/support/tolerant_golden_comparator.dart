// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Per-channel difference that still counts as "the same pixel".
///
/// The package draws 0.33px hairline dividers, whose anti-aliasing blend is
/// resolved slightly differently by each Skia/Impeller revision and host
/// platform. Those drifts land within a couple of 8-bit steps, while a real
/// visual regression (a moved widget, a changed color, a different font)
/// changes pixels far beyond it.
const int _defaultMaxChannelDelta = 12;

/// A [LocalFileComparator] that ignores imperceptible per-pixel drift.
///
/// Unlike a percentage-of-pixels threshold, this stays strict about *how far*
/// a pixel may move: a single misplaced glyph or shifted widget still fails,
/// because those produce channel deltas well above [maxChannelDelta].
class TolerantGoldenFileComparator extends LocalFileComparator {
  TolerantGoldenFileComparator(
    super.testFile, {
    this.maxChannelDelta = _defaultMaxChannelDelta,
  });

  /// Installs this comparator, reusing the base directory the test framework
  /// already resolved for the current test file.
  static void install({int maxChannelDelta = _defaultMaxChannelDelta}) {
    final GoldenFileComparator current = goldenFileComparator;
    if (current is! LocalFileComparator) {
      return;
    }
    goldenFileComparator = TolerantGoldenFileComparator(
      // `LocalFileComparator` only uses the file segment to derive `basedir`.
      current.basedir.resolve('flutter_test_config.dart'),
      maxChannelDelta: maxChannelDelta,
    );
  }

  final int maxChannelDelta;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final Uint8List goldenBytes = Uint8List.fromList(
      await getGoldenBytes(golden),
    );
    if (await _isWithinTolerance(imageBytes, goldenBytes)) {
      return true;
    }
    // Delegate the failure path so the standard diff artifacts still get
    // written to `failures/`.
    return super.compare(imageBytes, golden);
  }

  Future<bool> _isWithinTolerance(
    Uint8List testBytes,
    Uint8List goldenBytes,
  ) async {
    final _DecodedImage test = await _decode(testBytes);
    final _DecodedImage master = await _decode(goldenBytes);

    if (test.width != master.width || test.height != master.height) {
      return false;
    }

    final Uint8List a = test.pixels;
    final Uint8List b = master.pixels;
    for (int i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > maxChannelDelta) {
        return false;
      }
    }
    return true;
  }

  Future<_DecodedImage> _decode(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    try {
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;
      try {
        final ByteData? data = await image.toByteData();
        if (data == null) {
          throw StateError('Could not read pixels from a golden image.');
        }
        return _DecodedImage(
          width: image.width,
          height: image.height,
          pixels: data.buffer.asUint8List(),
        );
      } finally {
        image.dispose();
      }
    } finally {
      codec.dispose();
    }
  }
}

class _DecodedImage {
  const _DecodedImage({
    required this.width,
    required this.height,
    required this.pixels,
  });

  final int width;
  final int height;
  final Uint8List pixels;
}
