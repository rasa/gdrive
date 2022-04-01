#!/bin/bash

APP_NAME="gdrive"
PLATFORMS="$(go tool dist list)"

BIN_PATH="_release/bin"

# Initialize bin dir
mkdir -p $BIN_PATH
rm $BIN_PATH/* 2> /dev/null

# Build binary for each platform
for PLATFORM in $PLATFORMS; do
    GOOS=${PLATFORM%/*}
    GOARCH=${PLATFORM#*/}
    BIN_NAME="${APP_NAME}-${GOOS/darwin/osx}-${GOARCH/amd64/x64}"

    if [ $GOOS == "windows" ]; then
        BIN_NAME="${BIN_NAME}.exe"
    fi

    # Raspberrypi seems to need arm5 binaries
    if [ $GOARCH == "rpi" ]; then
        export GOARM=5
        GOARCH="arm"
    else
        unset GOARM
    fi

    export GOOS=$GOOS
    export GOARCH=$GOARCH

    echo "Building $BIN_NAME"
    go build -ldflags '-w -s' -o ${BIN_PATH}/${BIN_NAME}
done

echo "All done"
