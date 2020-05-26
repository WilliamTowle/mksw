#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#check-be:
#	if [ ! -r /dev/null ] ; then \
#		mknod /dev/null c 1 3 ;\
#	fi
#	which sed
#
###prelim: extras.tgz
##prelim:
##	( cd ${TEMPROOT} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

.PHONY: build-toolroot

build-toolroot:
	[ ! -r config.sh ] || rm -f config.sh
	[ ! -r Policy.sh ] || rm -f Policy.sh
	sh Configure -de
##	--
	[ -r config.sh.OLD ] || cp config.sh config.sh.OLD
	cat config.sh.OLD \
		| sed "s^usr/local^${TOOLROOT}/usr/local^" \
		> config.sh
##	--
	make
	make test || true
	make bin=${TOOLROOT}/usr/bin scriptdir=${TOOLROOT}/usr/bin man1dir=${TOOLROOT}/usr/man/man1 man3dir=${TOOLROOT}/usr/man/man3 install
