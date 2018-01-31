#!/bin/bash
set -eu
source ../common/package-build-helpers.sh

importgo
upstream "rkt-${VERSION}.tar.xz"
upstream "qemu-2.11.0.tar.xz"
upstream "coreos_restructured-1478.0.0.cpio.gz"
upstream "linux-4.14.16.tar.xz"
exportorig "rkt-${VERSION}.tar.xz"
build
