#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross

build-cross:
	mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
	for ARCHIVE in `ls *.tgz` ; do \
		cat $${ARCHIVE} | gzip -d | ( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && tar xvf - ) ;\
	done
	./bin/mkdpy ${PKGVER} > ${INSTTMP}/${PKGNAME}-${PKGVER}/root/syslinux.dpy
	echo "FRANKI/EARLGREY LINUX v${PKGVER}" > ${INSTTMP}/${PKGNAME}-${PKGVER}/etc/issue
