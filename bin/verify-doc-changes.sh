#!/bin/bash
set -e

# Test LoopBack.io will build if changes made to @artlab/docs
echo "TASK => VERIFY DOCS"
if git diff --name-only --quiet $TRAVIS_BRANCH docs/; then
  echo "No changes to @artlab/docs in this PR"
  exit 0
else
  echo "Testing @artlab/docs"
  npm run verify:docs
fi
