#!/bin/gmake
# cdrtools (2.0, 21/02/2003)

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
	[ -r DEFAULTS/Defaults.linux.OLD ] || cp DEFAULTS/Defaults.linux DEFAULTS/Defaults.linux.OLD

build-toolroot \
build-cross: prelim
	cat DEFAULTS/Defaults.linux.OLD \
		| sed "s%^INS_BASE=.*%INS_BASE=${TOOLROOT}/usr%" \
		> DEFAULTS/Defaults.linux
	make
	make install
