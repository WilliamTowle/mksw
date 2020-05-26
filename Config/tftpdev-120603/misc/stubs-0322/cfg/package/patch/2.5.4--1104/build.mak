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

#check-be:
#	which cmp
#	which find
#	which make
#	which sed

###prelim: extras.tgz
#prelim:
#	if [ ! -r /dev/null ] ; then \
#		mknod /dev/null c 1 3 ;\
#	fi
#	( cd ${INSTTMP} && ( \
#		mkdir tmp ;\
#	) || exit 1 )

.PHONY: build-native

#build-native: check-be prelim
build-native:
	CC=gcc CPPFLAGS=-D_GNU_SOURCE ./configure --prefix=${TOOLROOT}/usr
	make
	make prefix=${TOOLROOT}/usr install

#build-static: check-be prelim
#	CC=gcc CPPFLAGS=-D_GNU_SOURCE ./configure --prefix=/usr
#	make LDFLAGS=-static
#	make prefix=${INSTTMP}/usr install
