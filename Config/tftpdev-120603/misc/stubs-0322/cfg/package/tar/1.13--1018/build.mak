#!/bin/gmake
## based on LFS v3.2

include ${CONF}
#include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

check-be:
	if [ ! -r /dev/null ] ; then \
		mknod /dev/null c 1 3 ;\
	fi

prelim:
	( cd ${INSTTMP} && \
		mkdir bin usr && \
		mkdir usr/info \
	)

build: check-be prelim
	CC=`which gcc` ./configure --prefix=/usr \
		--host=`uname -m` \
		--target=${TARGET_ARCH} \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-largefile --disable-nls
	make
	make prefix=${INSTTMP}/usr bindir=${INSTTMP}/bin libexecdir=${INSTTMP}/usr/bin install

build-static: check-be prelim
	CC=gcc ./configure --prefix=/usr \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-nls
	make LDFLAGS=-static
	make prefix=${INSTTMP}/usr bindir=${INSTTMP}/bin libexecdir=${INSTTMP}/usr/bin install
