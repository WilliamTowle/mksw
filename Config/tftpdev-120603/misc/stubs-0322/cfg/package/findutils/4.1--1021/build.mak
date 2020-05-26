#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be prelim

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
	make localstatedir=/var/lib/misc
	make prefix=${INSTTMP}/usr localstatedir=${INSTTMP}/var/lib/misc libexecdir=${INSTTMP}/usr/bin install

build-static:
	./configure --prefix=/usr
	make LDFLAGS=-static localstatedir=/var/lib/misc
	make prefix=${INSTTMP}/usr localstatedir=/var/lib/misc libexecdir=${INSTTMP}/usr/bin install
