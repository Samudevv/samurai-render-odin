#! /bin/sh

echo Building opengl_bounce example ...
odin build examples/opengl_bounce \
"-extra-linker-flags=$(pkg-config --libs samurai-render egl gl)" \
-out:examples/opengl_bounce/opengl_bounce \
-o:minimal
