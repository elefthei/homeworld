#!/bin/bash

# restrip-coreos.sh exists because coreos distributions are rather big, and
# we'd rather just have the crucial parts, rather than everything, especially
# for storage in git.
# it will take in a production image and spit out a restructured and much, much
# smaller image.

set -e -u

if [ ! -e "rkt-1.29.0" ]
then
    echo "Cannot find unpacked rkt source archive in current directory." 1>&2
    exit 1
fi

if [ ! -e "coreos_production_pxe_image.cpio.gz" ]
then
    echo "Cannot find downloaded coreos_production_pxe_image.cpio.gz in current directory." 1>&2
    exit
fi

find rkt-1.29.0/ -name '*.manifest' -print0 | grep -z amd64 | xargs -0 cat -- | sort -u >coreos-manifest.txt
zcat coreos_production_pxe_image.cpio.gz | cpio -i --to-stdout usr.squashfs >coreos_squashfs
rm -rf coreos_minimal_dir
unsquashfs -no-xattrs -d coreos_minimal_dir -e coreos-manifest.txt coreos_squashfs
rm coreos-manifest.txt coreos_squashfs

tar -cJf "coreos_binaries-1478.0.0.tar.xz" "coreos_minimal_dir/"
rm -rf coreos_minimal_dir

echo "output in coreos_binaries-1478.0.0.tar.xz"
