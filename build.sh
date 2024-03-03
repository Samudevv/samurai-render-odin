#! /bin/sh

set -ex
script_dir=$(dirname $0)

mkdir -p $script_dir/build
ln -sf /usr/lib/libsamurai-render.so $script_dir/build/libsamurai_render.so

export link_dir="$(readlink -f ${script_dir}/build)"

examples/blank/build.sh
examples/opengl_bounce/build.sh
