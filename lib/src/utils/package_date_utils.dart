// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

abstract final class PackageDateUtils {
  static DateTime monthDateOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }
}
