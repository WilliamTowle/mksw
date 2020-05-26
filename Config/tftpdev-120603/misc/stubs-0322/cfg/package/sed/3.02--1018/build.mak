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
	which gcc
	which make
	which sed

##prelim: extras.tgz
#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

build: check-be
	CPPFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/usr --bindir=${INSTTMP}/bin
	make
	make install

build-static: check-be
	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/usr --bindir=${INSTTMP}/bin
	make LDFLAGS=-static
	make install
