#!/bin/make
## based on LFS v3.3

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

##check-be:
##	which pwd
##	which tail
##	which test
#
##merge-package:
##	[ -n "${PACKAGE}" ] && [ -r ${PACKAGE} ]
##	case ${PACKAGE} in \
##	*.tgz|*.tar.gz)\
##		cat ${PACKAGE} | gzip -d -c | tar xvf - \
##		;;\
##	*.tbz|*.tar.bz2)\
##		cat ${PACKAGE} | bzip2 -d | tar xvf - \
##		;;\
##	*)\
##		exit 1 \
##		;;\
##	esac
#
##prelim: ${BUILDDIR}/extras.tgz
##	( cd ${BUILDDIR} && ( \
##		if [ ! -d extras ] ; then \
##			mkdir extras ;\
##			( cd extras && tar xzf ${BUILDDIR}/extras.tgz );\
##		fi \
##	) || exit 1 )
###	( cd ${INSTTMP} && ( \
###		mkdir etc \
###	) || exit 1 )
###	( cd ${INSTTMP} && ( \
###		mkdir etc \
###	) || exit 1 )

.PHONY: build-toolroot

build-toolroot:
# CPPFLAGS setting suggested for glibc=2.1.x:
	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${TOOLROOT}/usr --bindir=${TOOLROOT}/bin --disable-nls
	[ -r src/Makefile.OLD ] || cp src/Makefile src/Makefile.OLD
	cat src/Makefile.OLD \
		| sed 's%ln -s %ln -sf %' \
		> src/Makefile
	make
	make prefix=${TOOLROOT}/usr bindir=${TOOLROOT}/bin install
