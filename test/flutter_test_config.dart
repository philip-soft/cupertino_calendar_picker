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

Future<void> _loadFonts() async {
  await Future.wait(<Future<void>>[
    _loadRobotoAs('Roboto'),
    _loadRobotoAs('CupertinoSystemText'),
    _loadRobotoAs('CupertinoSystemDisplay'),
    _loadIconFont('MaterialIcons', 'test/fonts/MaterialIcons-Regular.otf'),
    _loadIconFont('CupertinoIcons', 'test/fonts/CupertinoIcons.ttf'),
  ]);
}

/// Loads all Roboto weight variants under [family].
///
/// Flutter reads the weight from each file's internal metadata, so adding
/// all variants to one FontLoader gives the engine the full weight range.
Future<void> _loadRobotoAs(String family) async {
  final FontLoader loader = FontLoader(family)
    ..addFont(_bytes('test/fonts/Roboto-Thin.ttf'))
    ..addFont(_bytes('test/fonts/Roboto-Light.ttf'))
    ..addFont(_bytes('test/fonts/Roboto-Regular.ttf'))
    ..addFont(_bytes('test/fonts/Roboto-Medium.ttf'))
    ..addFont(_bytes('test/fonts/Roboto-Bold.ttf'))
    ..addFont(_bytes('test/fonts/Roboto-Black.ttf'));
  await loader.load();
}

Future<void> _loadIconFont(String family, String path) async {
  final FontLoader loader = FontLoader(family)..addFont(_bytes(path));
  await loader.load();
}

Future<ByteData> _bytes(String path) =>
    Future<ByteData>.value(File(path).readAsBytesSync().buffer.asByteData());
