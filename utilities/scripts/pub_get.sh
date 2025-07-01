#!/bin/bash
# pub_get.sh
# Find all pubspec.yaml files in the project
find . -name "pubspec.yaml" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Installing packages in $dir"
  (cd "$dir" && dart pub get)
done
