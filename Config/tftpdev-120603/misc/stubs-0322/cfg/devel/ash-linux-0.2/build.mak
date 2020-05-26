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

##check-be:
##	which patch
#
###prelim: extras.tgz
##prelim:
##	( cd ${INSTTMP} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

#.PHONY: build-cross build-toolroot
.PHONY: build-toolroot

build-toolroot:
	make
	make prefix=${TOOLROOT}/usr install
	( cd ${TOOLROOT}/usr/bin && ln -s make gmake )
