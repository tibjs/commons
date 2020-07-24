#!/bin/bash
set -e

# Test LoopBack.io will build if changes made to @tib/docs
echo "TASK => VERIFY DOCS"
if git diff --name-only --quiet $TRAVIS_BRANCH docs/; then
  echo "No changes to @tib/docs in this PR"
  exit 0
else
  echo "Testing @tib/docs"
  npm run verify:docs
fi
