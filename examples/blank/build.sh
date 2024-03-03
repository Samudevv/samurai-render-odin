#! /bin/sh

set -ex

echo Building blank example ...
odin build examples/blank \
-extra-linker-flags=-L$link_dir \
-out:examples/blank/blank \
-o:minimal
