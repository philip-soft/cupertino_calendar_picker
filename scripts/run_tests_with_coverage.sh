#!/bin/bash
set -e

flutter test --coverage

lcov \
  --remove coverage/lcov.info \
  'lib/src/calendar/date_picker/custom_cupertino_date_picker.dart' \
  --output-file coverage/lcov.info \
  --ignore-errors unused

genhtml coverage/lcov.info --output-directory coverage/html

echo "Coverage report generated at coverage/html/index.html"
