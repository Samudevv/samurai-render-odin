#! /bin/sh

echo Building blank example ...
odin build examples/blank \
-extra-linker-flags='-L./build/linux/x86_64/release -lwayland-client -lwayland-cursor -lcairo' \
-out:examples/blank/blank \
-o:minimal
