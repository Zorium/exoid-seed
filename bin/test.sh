#!/bin/sh
[ -z "$VERBOSE" ] && export VERBOSE=0
[ -z "$LINT" ] && export LINT=1
export NODE_ENV=test
export RETHINK_DB=obelix_test

node_modules/gulp/bin/gulp.js test
