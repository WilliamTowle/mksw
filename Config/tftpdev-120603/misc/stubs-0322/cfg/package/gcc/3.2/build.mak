#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: check-be default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-native

##check-be:
##	if [ ! -r /dev/null ] ; then \
##		mknod /dev/null c 1 3 ;\
##	fi
#
###prelim: extras.tgz
#prelim:
#	( cd ${INSTTMP} ;\
#		mkdir lib \
#	)

##build: check-be prelim
build-native:
#	./configure --prefix=${INSTTMP}/usr --enable-languages=c,c++ \
#		--disable-nls --disable-shared --enable-threads=posix
	./configure --prefix=/usr --enable-languages=c \
		--enable-shared --enable-threads=posix
	make bootstrap
	make prefix=${INSTTMP}/usr install
#	( cd ${INSTTMP}/lib && ln -sf ../usr/bin/cpp )
	( cd ${INSTTMP}/usr/lib && ln -sf ../bin/cpp )
	( cd ${INSTTMP}/usr/bin && ln -sf gcc cc )

##build-static: check-be prelim
#build-static: prelim
##	./configure --prefix=${INSTTMP}/usr --enable-languages=c,c++ \
##		--disable-nls --disable-shared --enable-threads=posix
#	./configure --prefix=/usr --enable-languages=c \
#		--disable-nls --disable-shared --enable-threads=posix
#	make BOOT_LDFLAGS=-static bootstrap
#	make prefix=${INSTTMP}/usr install
#	( cd ${INSTTMP}/lib && ln -sf ../usr/bin/cpp )
#	( cd ${INSTTMP}/usr/lib && ln -sf ../bin/cpp )
#	( cd ${INSTTMP}/usr/bin && ln -sf gcc cc )
#include ${CONF}
#include ${UNIT}
#
#.PHONY: build build-static check-be prelim
#
#default: build
#
##
##
##
#
##check-be:
##	if [ ! -r /dev/null ] ; then \
##		mknod /dev/null c 1 3 ;\
##	fi
#
###prelim: extras.tgz
#prelim:
#	( cd ${INSTTMP} ;\
#		mkdir lib \
#	)
#
##build: check-be prelim
#build: prelim
##	./configure --prefix=${INSTTMP}/usr --enable-languages=c,c++ \
##		--disable-nls --disable-shared --enable-threads=posix
#	./configure --prefix=/usr --enable-languages=c \
#		--enable-shared --enable-threads=posix
#	make bootstrap
#	make prefix=${INSTTMP}/usr install
#	( cd ${INSTTMP}/lib && ln -sf ../usr/bin/cpp )
#	( cd ${INSTTMP}/usr/lib && ln -sf ../bin/cpp )
#	( cd ${INSTTMP}/usr/bin && ln -sf gcc cc )
#
##build-static: check-be prelim
#build-static: prelim
##	./configure --prefix=${INSTTMP}/usr --enable-languages=c,c++ \
##		--disable-nls --disable-shared --enable-threads=posix
#	./configure --prefix=/usr --enable-languages=c \
#		--disable-nls --disable-shared --enable-threads=posix
#	make BOOT_LDFLAGS=-static bootstrap
#	make prefix=${INSTTMP}/usr install
#	( cd ${INSTTMP}/lib && ln -sf ../usr/bin/cpp )
#	( cd ${INSTTMP}/usr/lib && ln -sf ../bin/cpp )
#	( cd ${INSTTMP}/usr/bin && ln -sf gcc cc )
