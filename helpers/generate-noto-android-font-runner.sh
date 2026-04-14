#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

build_dir=$1
version=$2

mkdir -p "$build_dir/color" "$build_dir/fonts/OpenMoji-color-cbdt"

cat >"$build_dir/color/OpenMoji-color-cbdt.toml" <<-EOF
output_file = "$build_dir/color/OpenMoji-color-cbdt.ttf"
color_format = "cbdt"
ascender = 1045
descender = -275

[axis.wght]
name = "Weight"
default = 400

[master.regular]
style_name = "Regular"
srcs = ["/mnt/color/svg/*.svg"]

[master.regular.position]
wght = 400
EOF

nanoemoji --build_dir="$build_dir/color" "$build_dir/color/OpenMoji-color-cbdt.toml"

cp /mnt/data/OpenMoji-Color.ttx "$build_dir/color/OpenMoji-color-cbdt.ttx"

xmlstarlet edit --inplace --update \
    '/ttFont/name/namerecord[@nameID="5"][@platformID="3"]' \
    --value "$version" \
    "$build_dir/color/OpenMoji-color-cbdt.ttx"

ttx -m "$build_dir/color/OpenMoji-color-cbdt.ttf" \
    -o "$build_dir/fonts/OpenMoji-color-cbdt/OpenMoji-color-cbdt.ttf" \
    "$build_dir/color/OpenMoji-color-cbdt.ttx"
