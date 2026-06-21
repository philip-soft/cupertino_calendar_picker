#!/bin/bash
set -e

UPDATE_GOLDENS=""
if [[ "$1" == "--update-goldens" ]]; then
  UPDATE_GOLDENS="--update-goldens"
fi

flutter test --coverage $UPDATE_GOLDENS

lcov \
  --remove coverage/lcov.info \
  'lib/src/calendar/date_picker/custom_cupertino_date_picker.dart' \
  --output-file coverage/lcov.info \
  --ignore-errors unused

genhtml coverage/lcov.info --output-directory coverage/html

echo "Coverage report generated at coverage/html/index.html"
