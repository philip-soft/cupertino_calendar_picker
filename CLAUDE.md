# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`cupertino_calendar_picker` is a Flutter package (v3.0.0) providing iOS-style date and time picker widgets. It targets Flutter ≥3.47.0 and Dart SDK ^3.13.0, and is built on the standalone `cupertino_ui` / `material_ui` packages — always import those, never `package:flutter/cupertino.dart` or `package:flutter/material.dart`.

## Commands

```bash
# Run tests (from repo root)
flutter test

# Regenerate golden images (after an intended visual change)
flutter test --update-goldens test/golden

# Analyze for lint issues
flutter analyze

# Run the example app
cd example && flutter run

# Add copyright headers to all lib/src/ files (excludes custom_cupertino_date_picker.dart and cupertino_picker_button.dart)
python3 scripts/copyright_script.py
```

## Architecture

### Public API (`lib/cupertino_calendar_picker.dart`)

Only explicitly listed symbols are exported — new public types must be added to this export list.

**Two top-level functions** (in `lib/src/functions.dart`):
- `showCupertinoCalendarPicker` — shows a date/date-time overlay picker
- `showCupertinoTimePicker` — shows a time overlay picker

Both use `showGeneralDialog` with `transitionDuration: Duration.zero` and handle their own scale animation via `AnimationController`.

**Three widgets** exported for inline/button use:
- `CupertinoCalendar` — inline calendar widget (can be `compact` or `inline` type)
- `CupertinoCalendarPickerButton` — button that opens the calendar overlay
- `CupertinoTimePickerButton` — button that opens the time overlay

### Widget Hierarchy

Overlay flow (calendar):
```
showCupertinoCalendarPicker
  └── CupertinoCalendarOverlay (decides the route result on dismissal)
        └── CupertinoPickerOverlay (owns the AnimationController, positions the picker, pops the route with a result)
              └── CupertinoPickerContainer (stateless: scale animation + backdrop blur)
                    └── CupertinoCalendar (owns the selection, limited to the min/max range)
                          └── CupertinoCalendarPicker (month paging + view mode; reports changes up)
```

`PickerOverlayLayout.compute` is a pure function that places the picker relative to the anchor's rect (in the navigator's coordinates): it opens on the side with more vertical space, centers on the anchor or pins to the safe-area edge, and scales down if necessary. When the space next to the anchor fits the picker only below `pickerMinimumAnchoredScale`, it is centered on the screen instead. `CupertinoPickerOverlay` re-measures the anchor after each frame it builds, since the anchor lays out after the overlay (e.g. on rotation).

Descendants close the overlay with a result through `CupertinoPickerOverlayScope.maybeOf(context)?.close(result)`; actions use it, so outside of an overlay they only call their `onPressed`.

Clickable elements use `CupertinoPickerTapTarget`, which adds button semantics and keyboard activation.

### Key Enums

- `CupertinoCalendarMode` — `.date` or `.dateTime` (adds time wheel)
- `CupertinoCalendarType` — `.compact` (overlay) or `.inline` (in-page widget)
- `CupertinoCalendarViewMode` — internal: drives month grid vs. year/month scroll views
- `CalendarDismissBehavior` — controls whether tapping outside or selecting a date closes the overlay
- `PickerBackgroundType` — blur vs. solid background

### Decoration System

Each visual section has its own decoration class:
- `PickerContainerDecoration` — the frosted-glass container
- `CalendarHeaderDecoration` — month/year navigation row
- `CalendarWeekdayDecoration` — weekday labels row
- `CalendarMonthPickerDecoration` — day grid; uses `CalendarMonthPickerDayStyle` subclasses for selected/current/disabled/default states
- `CalendarFooterDecoration` — time picker row (dateTime mode only)
- `CalendarActionDecoration` — action buttons (Cancel/Confirm)

All decoration classes have a `.withDynamicColor(context)` factory that adapts to light/dark mode.

### Constants (`lib/src/config/package_config.dart`)

Fixed layout constants live here: `calendarWidth = 320.0`, `calendarDatePickerHeight = 332.0`, `calendarDateTimePickerHeight = 378.0`, `calendarActionsHeight = 44.0`, animation durations, etc.

### Linting

The project uses a strict lint ruleset (`analysis_options.yaml`):
- `always_specify_types` — explicit types everywhere
- `prefer_single_quotes` — single quotes only
- `require_trailing_commas` — trailing commas on all multi-line parameter lists
- `always_use_package_imports` — `package:cupertino_calendar_picker/...` imports, never relative
- `sort_constructors_first`, `always_put_required_named_parameters_first`
- `type_annotate_public_apis` — all public APIs need return types and parameter types

### Copyright Headers

All files in `lib/src/` must start with:
```dart
// Copyright (c) 2026 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.
```
Exceptions: `custom_cupertino_date_picker.dart` and `cupertino_picker_button.dart` (upstream Flutter files).

### Actions

`CupertinoCalendarAction` is a `sealed` class. Only two concrete subtypes exist: `CancelCupertinoCalendarAction` and `ConfirmCupertinoCalendarAction`. Actions are only valid when `type == CupertinoCalendarType.compact` and the list must have 1–2 entries.

### Placement Tests

`test/support/picker_screens.dart` defines the tested screens (small phone, phone, landscape phone, tablet with safe areas) and anchor positions. `test/unit/picker/picker_overlay_layout_matrix_test.dart` checks the layout invariants for every combination, `test/widget/picker/picker_placement_test.dart` compares the rendered picker of the real buttons with `PickerOverlayLayout.compute`, and `test/golden/picker_placement_golden_test.dart` renders opened pickers on whole screens.

### Golden Tests

Golden tests (alchemist) live in `test/golden/` and render through `test/golden/support/golden_harness.dart` (`goldenApp`, `lightDarkGroup`). Each test produces a `ci/` image (software renderer, compared on CI) and a `macos/` image. The test fonts (`test/fonts/`) only contain Latin glyphs, so CJK and Arabic text renders as boxes; cover such locales with widget tests instead.
