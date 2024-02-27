#!/bin/bash
set -xeuo pipefail

lipo -create -output liberlang-universal.a liberlang-arm64.a liberlang-x86_64.a

rm -rf liberlang.xcframework
xcodebuild -create-xcframework -output ./liberlang.xcframework -library liberlang-universal.a
