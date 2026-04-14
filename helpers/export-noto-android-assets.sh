#!/bin/bash
set -ueo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/..

build_root=${1:-build/noto-android}
size=${SIZE:-160}
output_dir="$build_root/png"

mkdir -p "$output_dir"

export SCALE="$size"
node helpers/generate-noto-asset-plan.js "$output_dir" "color/svg" |
  helpers/lib/optimize-build.sh \
    "export-noto-android-assets-$size" \
    helpers/lib/export-png.sh
