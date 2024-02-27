#!/bin/bash
set -xeuo pipefail

(
  OPEN_SSL_DIR=/opt/openssl-ios64
  
  export LIBS=${OPEN_SSL_DIR}/lib/libcrypto.a
  
  ./otp_build configure \
    --prefix=$(pwd)/_build/ios64 \
    --xcomp-conf=./xcomp/erl-xcomp-arm64-ios.conf \
    --with-ssl=${OPEN_SSL_DIR} \
    --disable-dynamic-ssl-lib
  
  ./otp_build boot
)
