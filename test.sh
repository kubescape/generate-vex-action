#!/usr/bin/env bash
set -x

if [[ -n "$TEST_COMMAND" ]]; then
    $TEST_COMMAND
fi
