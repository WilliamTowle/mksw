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

.PHONY: build-cross build-toolroot prelim

prelim:
	[ -d "${INSTTMP}" ]
	( cd ${INSTTMP} && ( \
		[ -d ${PKGNAME}${PATCHVER}-headers ] || mkdir ${PKGNAME}${PATCHVER}-headers \
	))

#build-cross:
#	${MAKE} -f ${MAKEFILE} INSTROOT=${INSTTMP} prelim
#	${MAKE} -f ${MAKEFILE} build-toolroot

build-toolroot:
##	--
	make mrproper
	make include/linux/version.h
	make symlinks
##	--
	cat .config \
		| sed 's%#* *CONFIG_PARIDE_PCD[= ].*%##CONFIG_PARIDE_PCD: %' \
		| sed 's%#* *CONFIG_PARIDE_PT[= ].*%##CONFIG_PARIDE_PT: %' \
		| sed 's%#* *CONFIG_AFFS_FS[= ].*%##CONFIG_AFFS_FS: %' \
		> .config.NEW
	cp .config.NEW .config
	echo "CONFIG_PARIDE_PCD=y" >> .config
	echo "CONFIG_PARIDE_PT=y" >> .config
	echo "CONFIG_AFFS_FS=y" >> .config
##	--
	if [ ! -d ${TOOLROOT}/usr/src/${PKGNAME}-${PATCHVER} ] ; then \
		mkdir -p ${TOOLROOT}/usr/src/${PKGNAME}-${PATCHVER} ;\
	fi
	tar cvf - .config * | ( cd ${TOOLROOT}/usr/src && \
		( cd ${PKGNAME}-${PATCHVER} && tar xvf - ) ;\
		ln -sf ${PKGNAME}-${PATCHVER} linux \
		)
##	--
	mkdir -p ${TOOLROOT}/usr/include/asm || rm -rf ${TOOLROOT}/usr/include/asm/*
	cp include/asm/* ${TOOLROOT}/usr/include/asm
#	cp -R include/asm-generic ${TOOLROOT}/usr/include
	cp -R include/linux ${TOOLROOT}/usr/include
##	-- some kernel header files include this, but outside the kernel it
##	-- has no meaning
	touch ${TOOLROOT}/usr/include/linux/autoconf.h
	touch ${TOOLROOT}/usr/src/linux/include/linux/autoconf.h
