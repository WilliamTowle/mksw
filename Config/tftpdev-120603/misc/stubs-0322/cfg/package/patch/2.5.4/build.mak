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

.PHONY: build-cross build-toolroot

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
	CC=${CROSS_PREFIX}-gcc CPPFLAGS=-D_GNU_SOURCE \
		./configure --prefix=/usr \
			--host=`uname -m` \
			--disable-largefile
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

#build-toolroot: check-be prelim
build-toolroot:
	CC=gcc CPPFLAGS=-D_GNU_SOURCE ./configure --prefix=${TOOLROOT}/usr
	make
	make install
