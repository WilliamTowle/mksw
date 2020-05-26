#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

#
#
#

check-be:
	which cmp
	which find
	which make
	which sed

##prelim: extras.tgz
prelim:
	if [ ! -r /dev/null ] ; then \
		mknod /dev/null c 1 3 ;\
	fi
	( cd ${INSTTMP} && ( \
		mkdir tmp ;\
	) || exit 1 )

build: check-be prelim
	CC=gcc CPPFLAGS=-D_GNU_SOURCE ./configure --prefix=/usr
	make
	make prefix=${INSTTMP}/usr install

build-static: check-be prelim
	CC=gcc CPPFLAGS=-D_GNU_SOURCE ./configure --prefix=/usr
	make LDFLAGS=-static
	make prefix=${INSTTMP}/usr install
