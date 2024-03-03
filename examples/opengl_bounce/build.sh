#! /bin/sh

set -ex

echo Building opengl_bounce example ...
odin build examples/opengl_bounce \
-extra-linker-flags=-L$link_dir \
-out:examples/opengl_bounce/opengl_bounce \
-o:minimal
