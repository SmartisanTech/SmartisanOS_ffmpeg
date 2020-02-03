#!/bin/bash

echo "ANDROID_NDK=$ANDROID_NDK"

if [ -z "$ANDROID_NDK" ]; then
    echo "You must define ANDROID_NDK before compile."
    echo "It must point to your NDK directories."
    echo ""
    exit 1
fi

PLATFORM=${ANDROID_NDK}/platforms/android-24

git apply FFMPEG.patch

COMMON_OPTIONS="\
    --target-os=android \
    --disable-static \
    --enable-shared \
    --disable-doc \
    --disable-programs \
    --disable-everything \
    --disable-avdevice \
    --disable-postproc \
    --disable-avfilter \
    --disable-symver \
    --disable-stripping \
    --enable-protocols \
    --enable-demuxers \
    --enable-parsers \
    --enable-decoders \
    --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb \
    " && \
./configure \
    --incdir=./ffbuild/armeabi-v7a/inc \
    --libdir=./ffbuild/armeabi-v7a \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-" \
    --sysroot="${PLATFORM}/arch-arm/" \
    --extra-cflags="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16" \
    --extra-ldflags="-Wl,--fix-cortex-a8" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS} \
    && \
make -j4 && make install-libs install-headers && \
make clean && mv config.h ffbuild/config.mak ./ffbuild/armeabi-v7a/ && ./configure \
    --incdir=./ffbuild/arm64-v8a/inc \
    --libdir=./ffbuild/arm64-v8a \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cross-prefix="${ANDROID_NDK}/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-" \
    --sysroot="${PLATFORM}/arch-arm64/" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS} \
    && \
make -j4 && make install-libs install-headers && \
make clean && mv config.h ffbuild/config.mak ./ffbuild/arm64-v8a

