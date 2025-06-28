#!/bin/bash -ex

# Clone Eden, fallback to mirror if upstream repo fails to clone
if ! git clone 'https://git.eden-emu.dev/eden-emu/eden.git' ./eden; then
    echo "Using mirror instead..."
    rm -rf ./eden || true
    git clone 'http://git.bixed.xyz/Bix/eden.git' ./eden
fi

cd ./eden
git submodule update --init --recursive

# Workaround for prebuilt ffmpeg download failure
# Use prebuilt ffmpeg from http://git.bixed.xyz/Bix/eden/
# Content is unchanged
sed -i 's|set(package_base_url "https://git.eden-emu.dev/eden-emu/")|set(package_base_url "http://git.bixed.xyz/Bix/eden/")|' CMakeModules/DownloadExternals.cmake
sed -i 's|set(package_repo "ext-android-bin/raw/master/")|set(package_repo "raw/refs/heads/main/")|' CMakeModules/DownloadExternals.cmake

# Optimised string.
if [ "$TARGET" = "Optimised" ]; then
    sed -i 's/resValue("string", "app_name_suffixed", "eden")/resValue("string", "app_name_suffixed", "eden optimised")/' src/android/app/build.gradle.kts
fi 
COUNT="$(git rev-list --count HEAD)"
APK_NAME="Eden-${COUNT}-Android-Unofficial-${TARGET}"

cd src/android
chmod +x ./gradlew
if [ "$TARGET" = "Optimised" ]; then
    ./gradlew assembleGenshinSpoofRelease --console=plain --info -Dorg.gradle.caching=true
fi

APK_PATH=$(find app/build/outputs/apk -type f -name "*.apk" | head -n 1)
if [ -z "$APK_PATH" ]; then
    echo "Error: APK not found in expected directory."
    exit 1
fi

mkdir -p artifacts
mv "$APK_PATH" "artifacts/$APK_NAME.apk"
