#!/bin/make
## based on LFS v3.2
include ${BUILDDIR}/current.cfg

.PHONY: build build-static check-be prelim

default: build

#
#
#

#check-be:
#	which pwd
#	which tail
#	which test

#prelim: extras.tgz
prelim:
	[ -d /usr/src/linux ]
	[ -d /dev ] || mkdir /dev
	[ -r /dev/null ] || mknod /dev/null c 1 3
	cat ${PKGDIR}/glibc-crypt-2.1.tar.gz | gzip -d -c | tar xvf -
	cat ${PKGDIR}/glibc-linuxthreads-${PKGVER}.tar.gz | gzip -d -c | tar xvf -
	( cd ${TEMPROOT} && ( \
		mkdir etc \
	) || exit 1 )

#build: check-be prelim
build: prelim
#	mknod -m 0666 /dev/null c 1 3
	touch ${TEMPROOT}/etc/ld.so.conf
	cp malloc/Makefile malloc/Makefile.backup
## no perl, can't autodetect it...
	sed 's%$$(PERL)%/usr/bin/perl%' malloc/Makefile.backup > malloc/Makefile
	cp login/Makefile login/Makefile.backup
## sim. no glibc; can't resolve UID mappings...
	sed 's/root/0/' login/Makefile.backup > login/Makefile
#	mkdir ../glibc-build
#	cd ../glibc-build
#	../glibc-2.2.5 ...
	./configure --prefix=${TEMPROOT}/usr --enable-add-ons=linuxthreads,crypt --libexecdir=${TEMPROOT}/usr/bin
	echo "cross-compiling = no" > configparms
	make
	make install
	make localedata/install-locales
#	exec /bin/bash --login

##build-static: check-be prelim
#build-static: prelim
