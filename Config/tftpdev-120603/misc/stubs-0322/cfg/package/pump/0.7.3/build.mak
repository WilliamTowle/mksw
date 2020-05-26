#!/bin/gmake
# syslinux (1.76, 21/10/2002)

include ${CONF}
include ${UNIT}

.PHONY: default

default:
##
#	which cmp
#
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross build-native

#prelim:
#	( cd ${TOOLROOT} && ( \
#		[ -d usr/bin ] || mkdir -p usr/bin ;\
#		[ -d usr/man/man1 ] || mkdir -p usr/man/man1 \
#	) || exit 1 ) || exit 1

build-cross:
#- begin build-pump.txt
## make pump CC=arm-linux-gcc \
## 	RPM_OPT_FLAGS=-I/usr/arm-linux/include/ \
## 	LODLIBES="-lpopt -lresolv -L/usr/arm-linux/lib"
## mkdir _install _install/sbin
## make install RPM_BUILD_ROOT=`pwd`/_install
#- end build-pump.txt
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-uclibc/bin:${PATH} make CC=${TARGET_MACH}-uclibc-gcc
	make install
