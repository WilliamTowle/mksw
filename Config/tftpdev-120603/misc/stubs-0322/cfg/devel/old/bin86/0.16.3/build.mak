#!/bin/gmake
## based on LFS v3.2

include ${CONF}
#include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

check-be:
	which uname
	which gcc
	which expr
#	if [ ! -r /dev/null ] ; then \
#		mknod /dev/null c 1 3 ;\
#	fi

prelim:
	( cd ${INSTTMP} && \
		mkdir usr usr/bin usr/man \
	)

build: check-be prelim
	make
	make install BINDIR=${INSTTMP}/usr/bin MANDIR=${INSTTMP}/usr/man
