#!/bin/bash

jazzy \
  --author Lionheart \
  --author_url http://lionheartsw.com \
  --github_url https://github.com/lionheart/KeyboardAdjuster \
  --github-file-prefix https://github.com/lionheart/KeyboardAdjuster/tree/0.1.0 \
  --module-version 0.1.0 \
  --module KeyboardAdjuster

git co gh-pages
cp -r docs/* .
rm -rf docs/
git add .
git commit -m "documentation update"
git co master
