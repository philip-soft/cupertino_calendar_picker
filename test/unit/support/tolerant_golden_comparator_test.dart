// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/tolerant_golden_comparator.dart';

/// Encodes a 4x4 image filled with a single opaque grey level.
Future<Uint8List> _solidPng(int grey) async {
  const int size = 4;
  final Uint8List pixels = Uint8List(size * size * 4);
  for (int i = 0; i < pixels.length; i += 4) {
    pixels[i] = grey;
    pixels[i + 1] = grey;
    pixels[i + 2] = grey;
    pixels[i + 3] = 255;
  }

  final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
    pixels,
  );
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: size,
    height: size,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  final ui.Codec codec = await descriptor.instantiateCodec();
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ByteData? png = await frame.image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  frame.image.dispose();
  codec.dispose();
  descriptor.dispose();
  buffer.dispose();
  return png!.buffer.asUint8List();
}

/// Serves [golden] instead of reading from disk, so the tolerance logic can be
/// exercised without touching the real golden files.
class _InMemoryComparator extends TolerantGoldenFileComparator {
  _InMemoryComparator(
    this._goldenBytes, {
    required Directory failureDir,
    required super.maxChannelDelta,
  }) : super(failureDir.uri.resolve('test.dart'));

  final Uint8List _goldenBytes;

  @override
  Future<List<int>> getGoldenBytes(Uri golden) async => _goldenBytes;
}

void main() {
  group('TolerantGoldenFileComparator', () {
    const int maxChannelDelta = 12;
    final Uri golden = Uri.parse('irrelevant.png');

    late Directory failureDir;

    setUp(() {
      // The failure path writes diff artifacts next to the golden, so give it
      // a scratch directory instead of the real `test/golden/failures`.
      failureDir = Directory.systemTemp.createTempSync('tolerant_golden');
    });

    tearDown(() => failureDir.deleteSync(recursive: true));

    test('passes when the images are identical', () async {
      final Uint8List bytes = await _solidPng(128);
      final _InMemoryComparator comparator = _InMemoryComparator(
        bytes,
        failureDir: failureDir,
        maxChannelDelta: maxChannelDelta,
      );

      expect(await comparator.compare(bytes, golden), isTrue);
    });

    test(
      'passes when every channel differs by at most maxChannelDelta',
      () async {
        final _InMemoryComparator comparator = _InMemoryComparator(
          await _solidPng(128),
          failureDir: failureDir,
          maxChannelDelta: maxChannelDelta,
        );

        expect(await comparator.compare(await _solidPng(140), golden), isTrue);
      },
    );

    test('fails when a channel differs by more than maxChannelDelta', () async {
      final _InMemoryComparator comparator = _InMemoryComparator(
        await _solidPng(128),
        failureDir: failureDir,
        maxChannelDelta: maxChannelDelta,
      );

      // The failure path delegates to `LocalFileComparator`, which reports a
      // golden mismatch by throwing rather than returning false.
      await expectLater(
        comparator.compare(await _solidPng(141), golden),
        throwsA(
          isA<FlutterError>().having(
            (FlutterError error) => error.message,
            'message',
            contains('Pixel test failed'),
          ),
        ),
      );
    });
  });
}
