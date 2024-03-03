#! /bin/sh

echo Building blank example ...
odin build examples/blank \
"-extra-linker-flags=$(pkg-config --libs samurai-render cairo egl)" \
-out:examples/blank/blank \
-o:minimal
