#!/bin/bash
set -ueo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/..

build_root=${1:-build/noto-android}
version=${2:-$(git describe --tags --always)}
container_image=${CONTAINER_IMAGE:-ghcr.io/jeppeklitgaard/font_builder:latest}
container_build_dir="/mnt/$build_root/font-build"
host_build_dir="$build_root/font-build"
font_output_dir="$build_root/font"

if [[ -t 1 ]]; then
    tty=(--tty --interactive)
else
    tty=()
fi

case "${CONTAINER_ENGINE:-unset}" in
podman)
    container_engine=podman
    ;;
docker)
    container_engine=docker
    ;;
*)
    for ce in podman docker; do
        if type -t "$ce" >/dev/null; then
            container_engine=$ce
            break
        fi
    done
    ;;
esac

if [[ -z "${container_engine:-}" ]]; then
    echo "Could not find podman or docker in PATH" >&2
    exit 1
fi

mkdir -p "$font_output_dir"

"$container_engine" run \
  --volume="$PWD":/mnt:Z \
  --rm \
  "${tty[@]}" \
  --pull=always \
  "$container_image" \
  /mnt/helpers/generate-noto-android-font-runner.sh \
    "$container_build_dir" "$version"

cp -f \
  "$host_build_dir/fonts/OpenMoji-color-cbdt/OpenMoji-color-cbdt.ttf" \
  "$font_output_dir/OpenMoji-color-cbdt.ttf"
