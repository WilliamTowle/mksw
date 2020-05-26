#!/bin/make
## based on LFS v3.3

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be merge-package prelim

default: build

#
#
#

#check-be:
#	which pwd
#	which tail
#	which test

#merge-package:
#	[ -n "${PACKAGE}" ] && [ -r ${PACKAGE} ]
#	case ${PACKAGE} in \
#	*.tgz|*.tar.gz)\
#		cat ${PACKAGE} | gzip -d -c | tar xvf - \
#		;;\
#	*.tbz|*.tar.bz2)\
#		cat ${PACKAGE} | bzip2 -d | tar xvf - \
#		;;\
#	*)\
#		exit 1 \
#		;;\
#	esac

#prelim: ${BUILDDIR}/extras.tgz
#	( cd ${BUILDDIR} && ( \
#		if [ ! -d extras ] ; then \
#			mkdir extras ;\
#			( cd extras && tar xzf ${BUILDDIR}/extras.tgz );\
#		fi \
#	) || exit 1 )
##	( cd ${INSTTMP} && ( \
##		mkdir etc \
##	) || exit 1 )
##	( cd ${INSTTMP} && ( \
##		mkdir etc \
##	) || exit 1 )

# CPPFLAGS setting suggested for glibc=2.1.x:
#build: check-be prelim
build:
	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=/usr --bindir=/bin --disable-nls
	make
	make prefix=${INSTTMP}/usr bindir=${INSTTMP}/bin install
#	( cd ${INSTTMP} && cp -R ${BUILDDIR}/extras/* ./ )

#build-static: check-be prelim
build-static:
	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=/usr --bindir=/bin --disable-nls
	make LDFLAGS=-static
	make prefix=${INSTTMP}/usr bindir=${INSTTMP}/bin install
#	( cd ${INSTTMP} && cp -R ${BUILDDIR}/extras/* ./ )
