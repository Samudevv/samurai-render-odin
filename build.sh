#! /bin/sh

set -e

echo Building C Library samurai-render ...
xmake -P lib/samurai-render
ln -fs libsamurai-render.a $(pwd)/build/linux/x86_64/release/libsamurai_render.a

examples/blank/build.sh
