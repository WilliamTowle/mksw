#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: build build-static check-be prelim
PHONY: default build

default: build

#
#
#

#check-be:
#	which patch

##prelim: extras.tgz
#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

build:
	./configure --prefix=/usr
	make
	make prefix=${INSTTMP}/usr install

## don't influence CPPFLAGS for glibc 2.2.x
#build-static:
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 \
#		./configure --prefix=/usr --disable-nls
#	make LDFLAGS=-static
#	make prefix=${INSTTMP}/usr install
