#!/bin/gmake
# syslinux (1.76, 21/10/2002)

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
	[ -r DEFAULTS/Defaults.linux.OLD ] || cp DEFAULTS/Defaults.linux DEFAULTS/Defaults.linux.OLD

build-native: prelim
	cat DEFAULTS/Defaults.linux.OLD \
		| sed "s%^INS_BASE=.*%INS_BASE=${TOOLROOT}/usr%" \
		> DEFAULTS/Defaults.linux
	make
	make install
