#!/bin/bash

bundle exec jazzy

git add docs/
git add .jazzy.yaml
git commit -m "documentation update"

sync_directory_to_s3 "us-east-2" "lionheart-opensource" "E33XE7TKGUV1ZD" "docs" "KeyboardAdjuster/"

