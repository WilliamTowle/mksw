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

check-be:
	which gcc
	which make
	which sed

#prelim:
#	[ "${INSTTMP}" ] || ( echo "INSTTMP not set" ; false )
#	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

.PHONY: build-cross build-native prelim

prelim:
	[ -r include/ums_config.h.OLD ] || cp include/ums_config.h include/ums_config.h.OLD
	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD

build-cross: prelim
	cat include/ums_config.h.OLD \
		| sed 's%^#define BE_UVFAT.*%#define BE_UVFAT 0%' \
		| sed 's%^#define KERN_22X%/* #define KERN_22X */%' \
		> include/ums_config.h
	cat Makefile.OLD \
		| sed 's%^GPP=g++%GPP=$${CROSS}g++%' \
		| sed 's%^GCC=gcc%GCC=$${CROSS}gcc%' \
		> Makefile
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make CROSS=${CROSS_PREFIX}- all
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin
	cp util/umssync ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin/
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin && ln -sf umssync umsssetup)
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man8
	cp util/umssync.8 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man8/
	gzip -9 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man8/*8

#build-native: check-be
#	./configure --prefix=${TOOLROOT}/usr --bindir=${TOOLROOT}/bin
#	make
#	make install

#build-static: check-be prelim
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
#	make LDFLAGS=-static
#	make install
