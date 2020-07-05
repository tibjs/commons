#!/bin/bash

# This script builds/verifies that `docs` is able to be served by `artlab.io`
# site. It runs the following steps:
# 1. Clone `artlab/artlab.io` github repository into `sandbox`
# 2. Bootstrap `artlab.io` package using `lerna` to use `docs` folder for
# `@artlab/docs` dependency
# 3. Run `npm run build` for `artlab.io` module to make sure jekyll can
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
lerna run --scope @artlab/docs prepack

# Clean up sandbox/artlab.io directory
rm -rf sandbox/artlab.io/

# Shadow clone the `artlab/artlab.io` github repo
git clone --depth 1 https://github.com/artlab/artlab.io.git sandbox/artlab.io

# Add artlab.io-workflow-scripts with @artlab/docs linked
lerna bootstrap --no-ci --scope artlab.io-workflow-scripts --include-dependencies

pushd $REPO_ROOT/sandbox/artlab.io/ >/dev/null

# Run bundle install for ruby gems required for `artlab.io`
bundle install

# Run npm build script to fetch readme files and generate jekyll site
# npm run build

popd >/dev/null
if [ "$1" == "--verify" ]; then
# Clean up sandbox/artlab.io/ if `--verify`
  rm -rf sandbox/artlab.io/
fi
popd >/dev/null
