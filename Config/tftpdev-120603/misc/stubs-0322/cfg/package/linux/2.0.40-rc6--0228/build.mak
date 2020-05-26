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

build-cross \
build-toolroot:
	${MAKE} -f ${MAKEFILE} INSTROOT=${INSTTMP} prelim
##	ln -s /static/bin/pwd /bin/pwd
	make mrproper
	make include/linux/version.h
	make symlinks
	mkdir -p ${TOOLROOT}/usr/include/asm || rm -rf ${TOOLROOT}/usr/include/asm/*
	cp include/asm/* ${TOOLROOT}/usr/include/asm
	cp -R include/asm-generic ${TOOLROOT}/usr/include
	cp -R include/linux ${TOOLROOT}/usr/include
	touch ${TOOLROOT}/usr/include/linux/autoconf.h
##	rm /bin/pwd
##
	cat .config \
		| sed 's%#* *CONFIG_PARIDE_PCD[= ].*%##CONFIG_PARIDE_PCD: %' \
		| sed 's%#* *CONFIG_PARIDE_PT[= ].*%##CONFIG_PARIDE_PT: %' \
		| sed 's%#* *CONFIG_AFFS_FS[= ].*%##CONFIG_AFFS_FS: %' \
		> .config.NEW
	cp .config.NEW .config
	echo "CONFIG_PARIDE_PCD=y" >> .config
	echo "CONFIG_PARIDE_PT=y" >> .config
	echo "CONFIG_AFFS_FS=y" >> .config
##
	[ -d ${TOOLROOT}/usr/src/${PKGNAME}-${PATCHVER} ] || mkdir -p ${TOOLROOT}/usr/src/${PKGNAME}-${PATCHVER}
	tar cvf - .config * | ( cd ${TOOLROOT}/usr/src && \
		( cd ${PKGNAME}-${PATCHVER} && tar xvf - ) ;\
		ln -sf ${PKGNAME}-${PATCHVER} linux \
		)
#
	mkdir -p ${INSTTMP}/${PKGNAME}${PATCHVER}-headers/usr/src/
	tar cvf - .config * | ( cd ${INSTTMP}/${PKGNAME}${PATCHVER}-headers/usr/src/ && \
		( mkdir ${PKGNAME}-${PATCHVER} ; cd ${PKGNAME}-${PATCHVER} && tar xvf - ) && \
		ln -sf ${PKGNAME}-${PATCHVER} linux \
		)
