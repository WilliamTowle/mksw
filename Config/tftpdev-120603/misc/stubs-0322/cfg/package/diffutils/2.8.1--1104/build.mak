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
#	which patch

#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

.PHONY: build-native

build-native:
	./configure --prefix=${TOOLROOT}/usr
	make
	make install

## don't influence CPPFLAGS for glibc 2.2.x
#build-static:
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 \
#		./configure --prefix=/usr --disable-nls
#	make LDFLAGS=-static
#	make prefix=${INSTTMP}/usr install
