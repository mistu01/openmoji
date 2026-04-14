#!/bin/bash
set -ueo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/..

build_root=${1:-build/noto-android}
version=${2:-$(git describe --tags --always)}
release_dir="$build_root/release"
bundle_root="$release_dir/openmoji-noto-android-$version"

rm -rf "$bundle_root"
mkdir -p "$bundle_root/assets" "$bundle_root/font" "$release_dir"

./helpers/export-noto-android-assets.sh "$build_root"
./helpers/generate-noto-android-font.sh "$build_root" "$version"

cp -r "$build_root/png" "$bundle_root/assets/png"
cp -f "$build_root/font/OpenMoji-color-cbdt.ttf" "$bundle_root/font/OpenMoji-color-cbdt.ttf"
cp -f LICENSE.txt "$bundle_root/LICENSE.txt"

(
  cd "$release_dir"
  rm -f \
    "openmoji-noto-android-$version.zip" \
    "openmoji-noto-android-assets-$version.zip" \
    "openmoji-noto-android-font-$version.zip"
  zip -rq "openmoji-noto-android-$version.zip" "openmoji-noto-android-$version"
)

(
  cd "$build_root"
  zip -rq "release/openmoji-noto-android-assets-$version.zip" png
  zip -jq "release/openmoji-noto-android-font-$version.zip" font/OpenMoji-color-cbdt.ttf
)
