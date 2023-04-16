# build-rust.sh

#!/bin/bash

LIB_NAME="gacha_crawler"

set -e

THISDIR=$(dirname $0)
cd $THISDIR

# Build the project for the desired platforms:
cargo build --target x86_64-apple-darwin --release
cargo build --target aarch64-apple-darwin --release
mkdir -p ./target/universal-macos/release

lipo \
    ./target/aarch64-apple-darwin/release/lib${LIB_NAME}.a \
    ./target/x86_64-apple-darwin/release/lib${LIB_NAME}.a -create -output \
    ./target/universal-macos/release/lib${LIB_NAME}.a

cargo build --target aarch64-apple-ios --release

cargo build --target x86_64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release
mkdir -p ./target/universal-ios/release

lipo \
    ./target/aarch64-apple-ios-sim/release/lib${LIB_NAME}.a \
    ./target/x86_64-apple-ios/release/lib${LIB_NAME}.a -create -output \
    ./target/universal-ios/release/lib${LIB_NAME}.a