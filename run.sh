#!/usr/bin/env bash

export CC="arm-bemos-linux-musleabihf-gcc -march=armv7-a -mfloat-abi=hard -mtune=cortex-a9 -flax-vector-conversions"
export CXX="arm-bemos-linux-musleabihf-g++ -march=armv7-a -mfloat-abi=hard -mtune=cortex-a9"
export CC_host="gcc -m32"
export CXX_host="g++ -m32"

cd /work

wcurl https://nodejs.org/dist/$1/node-$1.tar.gz || exit 1
tar -xf node-$1.tar.gz
cd node-$1
patch -p1 < ../fix_ninja_build.patch || exit 1

./configure --ninja --prefix=./dist --dest-cpu=arm --cross-compiling --fully-static --dest-os=linux --with-arm-float-abi=hard || exit 1

ninja -C out/Release node || exit 1

mkdir -p archive/node-${1}/bin
cp out/Release/node archive/node-${1}/bin
cp LICENSE archive/node-${1}/

tmp_archive="$(mktemp /tmp/node-${1}-out-XXXXXX.tar.gz)" || exit 1
tar -C archive -czf "$tmp_archive" . || exit 1
mv "$tmp_archive" /out/ || exit 1
chmod 644 /out/node-${1}-out-*.tar.gz
