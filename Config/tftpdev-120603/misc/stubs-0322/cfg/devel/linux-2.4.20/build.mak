#!/bin/gmake
# based on LFS v4.0 (c.01/11/2002)

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-native prelim

prelim:
	[ -d "${INSTTMP}" ] 
	( cd ${INSTTMP} && ( \
		[ -d ${PKGNAME}${PKGVER}-headers ] || mkdir ${PKGNAME}${PKGVER}-headers \
	))

build-native:
	${MAKE} -f ${MAKEFILE} INSTROOT=${INSTTMP} prelim
#	ln -s /static/bin/pwd /bin/pwd
	make mrproper
	make include/linux/version.h
	make symlinks
	mkdir -p ${TOOLROOT}/usr/include/asm || rm -rf ${TOOLROOT}/usr/include/asm/*
	cp include/asm/* ${TOOLROOT}/usr/include/asm
	cp -R include/asm-generic ${TOOLROOT}/usr/include
	cp -R include/linux ${TOOLROOT}/usr/include
	touch ${TOOLROOT}/usr/include/linux/autoconf.h
#	rm /bin/pwd
#
	[ -d ${TOOLROOT}/usr/src/${PKGNAME}-${PKGVER} ] || mkdir -p ${TOOLROOT}/usr/src/${PKGNAME}-${PKGVER}
	tar cvf - .config * | ( cd ${TOOLROOT}/usr/src && \
		( cd ${PKGNAME}-${PKGVER} && tar xvf - ) ;\
		ln -sf ${PKGNAME}-${PKGVER} linux \
		)
#
	mkdir -p ${INSTTMP}/${PKGNAME}${PKGVER}-headers/usr/src/
	tar cvf - .config * | ( cd ${INSTTMP}/${PKGNAME}${PKGVER}-headers/usr/src/ && \
		( mkdir ${PKGNAME}-${PKGVER} && cd ${PKGNAME}-${PKGVER} && tar xvf - ) && \
		ln -sf ${PKGNAME}-${PKGVER} linux \
		)
#
