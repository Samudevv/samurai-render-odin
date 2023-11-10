#! /bin/sh

set -e

echo Building C Library samurai-render ...
xmake config -P lib/samurai-render --backend_opengl=y --backend_cairo=n
xmake -P lib/samurai-render
ln -fs libsamurai-render.a $(pwd)/build/linux/x86_64/release/libsamurai_render.a

examples/blank/build.sh
examples/opengl_bounce/build.sh
