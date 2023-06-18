#!/bin/bash
set -ex

echo "Called with: $@" > zowe-init.log

if [[ "$1" == "zowe-init" || "$1" == "cat" ]]; then
    # Calling Zowe CLI to initialize daemon mode:
    zowe --version >> zowe-init.log
    cat  # Prevents terminating the container on the `docker run` command
else
    exec "$@"
fi
