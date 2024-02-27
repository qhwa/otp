#!/bin/bash
set -xeuo pipefail

(
  OPEN_SSL_DIR=/opt/openssl-darwin64-x86_64
  
  export LIBS=${OPEN_SSL_DIR}/lib/libcrypto.a
  export INSTALL_PROGRAM="/usr/bin/install -c"
  export MAKEFLAGS="-j10 -O"
  export RELEASE_LIBBEAM="yes"

  # make clean

  ./otp_build configure \
    --prefix=$(pwd)/_build/darwin64-x86_64 \
    --xcomp-conf=./xcomp/erl-xcomp-x86_64-darwin.conf \
    --with-ssl=${OPEN_SSL_DIR} \
    --disable-dynamic-ssl-lib \
    --without-termcap \
    --without-wx \
    --without-javac \
    --without-odbc \
    --without-debugger \
    --without-observer \
    --without-cdv \
    --without-et \
    --enable-builtin-zlib \
    --enable-static-nifs=$(pwd)/lib/crypto/priv/lib/x86_64-apple-darwin/crypto.a,$(pwd)/lib/asn1/priv/lib/x86_64-apple-darwin/asn1rt_nif.a \
    --enable-static-drivers \
    --disable-jit
    
  ./otp_build boot -a

  ./otp_build release -a
  
  libtool \
    -static \
    -o liberlang-x86_64.a \
    bin/x86_64-apple-darwin/libbeam.a \
    erts/lib/internal/x86_64-apple-darwin/*.a \
    erts/emulator/*/obj/x86_64-apple-darwin/opt/*.a \
    lib/*/priv/lib/x86_64-apple-darwin/*.a \
    ${OPEN_SSL_DIR}/lib/libcrypto.a

  # rm -rf liberlang.xcframework
  # xcodebuild -create-xcframework -output ./liberlang.xcframework -library liberlang.a
  # \cp -a liberlang.xcframework ~/Projects/GiraClient/
  # cd ~/Projects/GiraClient
  # xcodebuild -scheme GiraClient
)
