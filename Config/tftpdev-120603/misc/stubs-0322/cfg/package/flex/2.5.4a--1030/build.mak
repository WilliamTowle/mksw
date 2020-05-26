#!/bin/make
## based on LFS v3.2

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

#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir etc \
#	) || exit 1 )

#build: check-be prelim
build:
	./configure --prefix=${INSTTMP}/usr
	make
	make install

#build-static: check-be prelim
build-static:
	./configure --prefix=${INSTTMP}/usr
	make LDFLAGS=-static
	make install
