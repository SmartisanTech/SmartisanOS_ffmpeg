The FFmpeg code used for Android
===========================================


Build
-----

0. Install git, Android ndk
1. `$ export ANDROID_NDK=/path/to/your/android-ndk`
2. `$ ./config.sh`
3. libavcodec.so  libavformat.so  libavutil.so  libswresample.so  libswscale.so
   will be built to `./ffbuild/{arm64-v8a, armeabe-v7a}/`
   and the header file will be built to `./ffbuild/{arm64-v8a, armeabe-v7a}/inc/`
