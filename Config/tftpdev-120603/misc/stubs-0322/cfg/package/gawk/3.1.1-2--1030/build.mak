#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

#
#
#

#check-be:
#	which patch

##prelim: extras.tgz
#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir bin lib usr	;\
#		mkdir usr/include usr/lib ;\
#		mkdir usr/share usr/share/man usr/share/man/man1 \
#	) || exit 1 )

build:
	cp awklib/Makefile.in awklib/Makefile.in.backup
	sed	-e '/^datadir/s/awk/gawk/' \
		-e '/^libexecdir/s%/awk%%' awklib/Makefile.in.backup \
		> awklib/Makefile.in
	./configure --prefix=/usr --disable-nls \
			--libexecdir=/usr/bin
	make
	make prefix=${INSTTMP}/usr libexecdir=${INSTTMP}/usr/bin install
	( cd ${INSTTMP}/usr/bin && rm gawk-${PKGVER} )

# don't influence CPPFLAGS for glibc 2.2.x
build-static:
	cp awklib/Makefile.in awklib/Makefile.in.backup
	sed	-e '/^datadir/s/awk/gawk/' \
		-e '/^libexecdir/s%/awk%%' awklib/Makefile.in.backup \
		> awklib/Makefile.in
	CPPFLAGS=-Dre_max_failures=re_max_failures2 \
		./configure --prefix=/usr --disable-nls \
			--libexecdir=/usr/bin
	make LDFLAGS=-static
	make prefix=${INSTTMP}/usr libexecdir=${INSTTMP}/usr/bin install
