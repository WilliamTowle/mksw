#!/bin/sh

# http://www.fireflymediaserver.org/

LD_LIBRARY_PATH=`pwd`/toolchain/usr/lib/ `pwd`/toolchain/usr/sbin/mt-daapd ${1+$@}
