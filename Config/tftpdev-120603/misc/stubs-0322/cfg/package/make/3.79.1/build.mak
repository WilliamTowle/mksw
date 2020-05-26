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

#.PHONY: build build-static check-be prelim
#
#default: build
#
##
##
##
#
##check-be:
##	which patch
#
###prelim: extras.tgz
##prelim:
##	( cd ${INSTTMP} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

.PHONY: build-cross build-native

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		CC=${CROSS_PREFIX}-gcc \
		./configure --prefix=/usr \
		--disable-nls --disable-largefile
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
	make prefix=${INSTROOT}/usr install
	( cd ${INSTROOT}/usr/bin && ln -s make gmake )

build-native:
	./configure --prefix=${TOOLROOT}/usr \
		--disable-nls --disable-largefile
	make
	make prefix=${TOOLROOT}/usr install
	( cd ${TOOLROOT}/usr/bin && ln -s make gmake )

#build-static:
#	./configure --prefix=/usr \
#		--disable-nls
#	make LDFLAGS=-static
#	make prefix=${INSTTMP}/usr install
#	( cd ${INSTTMP}/usr/bin && ln -s make gmake )
