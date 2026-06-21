// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';

/// Global test configuration picked up automatically by `flutter test`.
///
/// Both CI and platform goldens render with real fonts — CI goldens use
/// alchemist's software renderer for cross-platform pixel stability, while
/// platform goldens additionally capture native blur and shadow effects.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await _loadFonts();

  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(obscureText: false),
    ),
    run: testMain,
  );
}

/// Loads Roboto as a stand-in for SF Pro so that Cupertino text renders
/// as readable glyphs instead of Ahem boxes in golden screenshots.
Future<void> _loadFonts() async {
  // Cupertino widgets request these font families at runtime (Flutter 3.x).
  const List<String> families = <String>[
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
  ];

  final ByteData regular = _readFont('test/fonts/Roboto-Regular.ttf');
  final ByteData bold = _readFont('test/fonts/Roboto-Bold.ttf');

  for (final String family in families) {
    final FontLoader loader = FontLoader(family)
      ..addFont(Future<ByteData>.value(regular))
      ..addFont(Future<ByteData>.value(bold));
    await loader.load();
  }
}

ByteData _readFont(String path) =>
    File(path).readAsBytesSync().buffer.asByteData();
