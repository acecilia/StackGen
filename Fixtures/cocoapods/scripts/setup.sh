#!/bin/bash
# Setup project

# Fail if exit code is not zero, in pipes, and also if variable is not set
# See: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -eou pipefail

pod install
xcodegen

echo "✨ Done"
