#!/bin/bash
export GO_VERSION=${GO_VERSION:-1.16.4}
export CWD=$PWD
OSKERNEL=$(uname -s | awk '{print tolower($0)}')
OSARCH=$(uname -m | awk '{print tolower($0)}')
GOARCH="amd64"
if [[ "$OSARCH" == "arm64" ]]; then
    GOARCH="arm64"
fi

export GOARCH=$GOARCH
export OSKERNEL=$OSKERNEL

echo "Seting up for $OSKERNEL - $OSARCH..."

if [[ "$OSKERNEL" == "darwin" ]]; then
    ./macos.sh
elif [[ "$OSKERNEL" == "linux" ]]; then
    ./ubuntu.sh
fi

echo "Verify setting..."
source ~/.zshrc
go version
tf version
node --version
