#!/bin/bash

# This script builds/verifies that `docs` is able to be served by `tib.io`
# site. It runs the following steps:
# 1. Clone `tib/tib.io` github repository into `sandbox`
# 2. Bootstrap `tib.io` package using `lerna` to use `docs` folder for
# `@tib/docs` dependency
# 3. Run `npm run build` for `tib.io` module to make sure jekyll can
# generate the web site successfully

# Set `-e` so that non-zero exit code from any step will be honored
set -e

if ! [ -x "$(command -v bundle)" ]; then
  echo 'Error: You must have Bundler installed (http://bundler.io)' >&2
  exit 1
fi

# Set `-v` (verbose) for travis build
if [ -n "$TRAVIS" ]; then
  set -v
fi

# Make sure we use the correct repo root dir
DIR=`dirname $0`
REPO_ROOT=$DIR/..
pushd $REPO_ROOT >/dev/null

# Update apidocs
lerna bootstrap
lerna run --scope @tib/docs prepack

# Clean up sandbox/tib.io directory
rm -rf sandbox/tib.io/

# Shadow clone the `tib/tib.io` github repo
git clone --depth 1 https://github.com/tibjs/tib.io.git sandbox/tib.io

# Add tib.io-workflow-scripts with @tib/docs linked
lerna bootstrap --no-ci --scope tib.io-workflow-scripts --include-dependencies

pushd $REPO_ROOT/sandbox/tib.io/ >/dev/null

# Run bundle install for ruby gems required for `tib.io`
bundle install

# Run npm build script to fetch readme files and generate jekyll site
# npm run build

popd >/dev/null
if [ "$1" == "--verify" ]; then
# Clean up sandbox/tib.io/ if `--verify`
  rm -rf sandbox/tib.io/
fi
popd >/dev/null
