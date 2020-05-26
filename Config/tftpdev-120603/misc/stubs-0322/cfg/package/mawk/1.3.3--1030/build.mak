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
	which tee

#prelim: extras.tgz
prelim:
	( cd ${INSTTMP} && ( \
		mkdir usr	;\
		mkdir usr/bin	;\
		mkdir usr/share usr/share/man usr/share/man/man1 \
	) || exit 1 )

build: check-be prelim
	./configure
	make
	make BINDIR=${INSTTMP}/usr/bin MANDIR=${INSTTMP}/usr/share/man/man1 install

build-static: check-be prelim
	./configure
	make CC="gcc -static"
	make BINDIR=${INSTTMP}/usr/bin MANDIR=${INSTTMP}/usr/share/man/man1 install
