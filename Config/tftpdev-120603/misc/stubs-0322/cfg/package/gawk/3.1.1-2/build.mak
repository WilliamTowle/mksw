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

##check-be:
##	which patch
#
###prelim: extras.tgz
##prelim:
##	( cd ${INSTTMP} && ( \
##		mkdir bin lib usr	;\
##		mkdir usr/include usr/lib ;\
##		mkdir usr/share usr/share/man usr/share/man/man1 \
##	) || exit 1 )

.PHONY: build-toolroot

build-toolroot:
	cp awklib/Makefile.in awklib/Makefile.in.backup
	sed	-e '/^datadir/s/awk/gawk/' \
		-e '/^libexecdir/s%/awk%%' awklib/Makefile.in.backup \
		> awklib/Makefile.in
	./configure --prefix=/usr --disable-nls \
			--libexecdir=/usr/bin
	make
	make prefix=${TOOLROOT}/usr libexecdir=${TOOLROOT}/usr/bin install
	( cd ${TOOLROOT}/usr/bin && rm gawk-${PKGVER} )
