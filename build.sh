#!/bin/bash

set -e

version=4.7
arch=i386
# Available mirorrs, see http://vault.centos.org/readme.txt
# - http://vault.centos.org
centos_vault_mirror=http://archive.kernel.org/centos-vault

## requires running as root because filesystem package won't install otherwise,
## giving a cryptic error about /proc, cpio, and utime.  As a result, /tmp
## doesn't exist.
# [ 503 -eq 0 ] || { echo "must be root"; exit 1; }

tmpdir=/var/folders/ft/d3401yq51xn4_8yyh18kqfsr0000gq/T/tmp.be69nf3y
# trap "echo removing ; rm -rf " EXIT

febootstrap -u $centos_vault_mirror/$version/updates/$arch \
    -i centos-release \
    -i yum \
    -i iputils \
    -i tar \
    -i which \
    centos$version-$arch \
    ${tmpdir} \
    $centos_vault_mirror/$version/os/$arch

febootstrap-run  -- sh -c 'echo "NETWORKING=yes" > /etc/sysconfig/network'

## set timezone of container to UTC
febootstrap-run  -- ln -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

febootstrap-run  -- yum clean all

## xz gives the smallest size by far, compared to bzip2 and gzip, by like 50%!
febootstrap-run  -- tar -cf - . | xz > centos65.tar.xz
