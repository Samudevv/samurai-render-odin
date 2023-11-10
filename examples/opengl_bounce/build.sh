#! /bin/sh

echo Building opengl_bounce example ...
odin build examples/opengl_bounce \
-extra-linker-flags='-L./build/linux/x86_64/release -lwayland-client -lwayland-cursor -lwayland-egl -lEGL' \
-out:examples/opengl_bounce/opengl_bounce \
-o:minimal
