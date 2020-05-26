#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	which awk
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-native build-cross prelim

prelim:
#	mkdir ${INSTTMP}/${PKGNAME}-${PKGVER} || rm -rf ${INSTTMP}/${PKGNAME}-${PKGVER}/*
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir usr usr/bin \
#	) || exit 1 ) || exit 1
	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD

build-native: prelim
	cp Makefile.OLD Makefile
	make PREFIX=${TOOLROOT}/ install

build-cross: prelim
	cp Makefile.OLD Makefile
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make CROSS=${CROSS_PREFIX}- PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER} install

#build-static: prelim
#	cat Makefile.OLD \
#		| sed 's%^DOSTATIC *=.*%DOSTATIC = true%' \
#		> Makefile
#	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER} install
