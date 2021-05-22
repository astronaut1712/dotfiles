#!/bin/bash
GO_VERSION=${GO_VERSION:-1.16.4}
CWD=$PWD
OSKERNEL=$(uname -s | awk '{print tolower($0)}')
OSARCH=$(uname -m | awk '{print tolower($0)}')

if [[ "$OSKERNEL" == "darwin*" ]]; then
    ./macos.sh
elif [[ "$OSKERNEL" == "linux" ]]; then
    ./ubuntu.sh
fi

