# FFmpeg prebuilt binaries

## ffmpeg-win-arm64
FFmpeg 7.1.1 build for Windows ARM64

Originally from https://github.com/tordona/ffmpeg-win-arm64/releases

Trimmed unused files according to the ffmpeg 7.1.1 x64 build from eden ext-windows-bin [repo](https://git.eden-emu.dev/eden-emu/ext-windows-bin/src/branch/master/ffmpeg)

## ffmpeg-android-7.1.1-aarch64
Originally from eden ext-android-bin [repo](https://git.eden-emu.dev/eden-emu/ext-android-bin).
Unchange. Only try to resolve the frequent fatal error 522 when down the binary, causing errors like this:

`ninja: error: 'externals/ffmpeg-android-7.1.1-aarch64/lib/libavcodec.so', needed by 'bin/tests', missing and no known rule to make it`

