import os

copyright_notice = """\
// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

"""

directory = "lib/src/"
file_extensions = {".dart"}
exclusions = {
    "custom_cupertino_date_picker.dart",
    "cupertino_picker_button.dart",
}


def add_copyright_notice(file_path):
    # Open the file and read its content
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Check if the copyright notice is already present
    if copyright_notice.strip() in content:
        print(f"Copyright notice already present in file {file_path}")
        return

    # Open the file for writing and add the copyright notice at the beginning
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(copyright_notice + content)

    print(f"Added copyright notice to file {file_path}")


def should_exclude(file_path):
    # Check by full path
    if file_path in exclusions:
        return True
    # Check by file name or directory
    for exclusion in exclusions:
        if file_path.endswith(exclusion) or exclusion in file_path:
            return True
    return False


def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            # Check for exclusions
            if should_exclude(file_path):
                print(f"File {file_path} is excluded from processing")
                continue
            if os.path.splitext(file_path)[1] in file_extensions:
                add_copyright_notice(file_path)


# Start processing the directory
process_directory(directory)
