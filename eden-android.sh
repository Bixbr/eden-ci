#!/bin/bash -ex

# Clone Eden, fallback to mirror if upstream repo fails to clone
if ! git clone 'https://git.eden-emu.dev/eden-emu/eden.git' ./eden; then
    echo "Using mirror instead..."
    rm -rf ./eden || true
    git clone 'http://git.bixed.xyz/Bix/eden.git' ./eden
fi

cd ./eden
git submodule update --init --recursive

sed -i 's/resValue("string", "app_name_suffixed", "Eden")/resValue("string", "app_name_suffixed", "Eden Optimised")/' src/android/app/build.gradle.kts

# Count commits and set output APK name
COUNT="$(git rev-list --count HEAD)"
APK_NAME="Eden-${COUNT}-Android-Unofficial-${TARGET}"

cd src/android
chmod +x ./gradlew

# Build APK based on target
if [ "$TARGET" = "Optimised" ]; then
    ./gradlew assembleGenshinSpoofRelease --console=plain --info -Dorg.gradle.caching=true
fi

# Find and move the APK to the artifacts folder
APK_PATH=$(find app/build/outputs/apk -type f -name "*.apk" | head -n 1)

if [ -z "$APK_PATH" ]; then
    echo "Error: APK not found in expected directory."
    exit 1
fi

mkdir -p artifacts
mv "$APK_PATH" "artifacts/$APK_NAME.apk"
