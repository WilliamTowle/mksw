#!/bin/sh

[ -r /mnt/sdb2/unmounted ] && mount /dev/sdb2 /mnt/sdb2

TOOLCHAIN=`pwd`/TOOLCHAIN/usr/bin
TRACKS=/mnt/sdb2/var/tmp/audio/*mp3

PATH=${TOOLCHAIN}:$PATH

jinamp -p ${TOOLCHAIN}/mpg123 ${TRACKS}
