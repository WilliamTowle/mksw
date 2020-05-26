#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#.PHONY: build-native build-static check-be prelim
#
#default: build-native
#
#
#check-be:
#	which tee
#
##prelim: extras.tgz

.PHONY: build-native prelim

prelim:
	( cd ${TOOLROOT} && ( \
		[ -d usr ] || mkdir usr	;\
		[ -d usr/bin ] || mkdir usr/bin	;\
		[ -d usr/share ] || mkdir usr/share ;\
		[ -d usr/share/man ] || mkdir usr/share/man ;\
		[ -d usr/share/man/man1 ] || mkdir usr/share/man/man1 \
	) || exit 1 )

build-native: prelim
	./configure
	make
	make BINDIR=${TOOLROOT}/usr/bin MANDIR=${TOOLROOT}/usr/share/man/man1 install

#build-static: check-be prelim
#	./configure
#	make CC="gcc -static"
#	make BINDIR=${INSTTMP}/usr/bin MANDIR=${INSTTMP}/usr/share/man/man1 install
