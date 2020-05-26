#!/bin/make
## based on LFS v3.2
include ${BUILDDIR}/current.cfg

.PHONY: build build-static check-be merge-package prelim

default: build

#
#
#

#check-be:
#	which pwd
#	which tail
#	which test

merge-package:
	[ -n "${PACKAGE}" ] && [ -r ${PACKAGE} ]
	case ${PACKAGE} in \
	*.tgz|*.tar.gz)\
		cat ${PACKAGE} | gzip -d -c | tar xvf - \
		;;\
	*.tbz|*.tar.bz2)\
		cat ${PACKAGE} | bzip2 -d | tar xvf - \
		;;\
	*)\
		exit 1 \
		;;\
	esac

#prelim: extras.tgz
prelim:
	[ -d /usr/src/linux ]
	[ -d /dev ] || mkdir /dev
	[ -r /dev/null ] || mknod /dev/null c 1 3
	make -f ${BUILDDIR}/build.mak merge-package PACKAGE=`ls ${PKGDIR}/glibc-linuxthreads-${PKGVER}.t*`
	( cd ${TEMPROOT} && ( \
		mkdir etc \
	) || exit 1 )

#build: check-be prelim
build: prelim
#	mknod -m 0666 /dev/null c 1 3
	cp malloc/Makefile malloc/Makefile.backup
## no perl in current install -> fudge autodetection:
	sed 's%$$(PERL)%/usr/bin/perl%' malloc/Makefile.backup > malloc/Makefile
	cp login/Makefile login/Makefile.backup
## sim. no glibc; can't resolve UID mappings...
	sed 's/root/0/' login/Makefile.backup > login/Makefile
#	mkdir ../glibc-build
#	cd ../glibc-build
#	../glibc-2.2.5 ...
	./configure --prefix=/usr --enable-add-ons=linuxthreads --libexecdir=/usr/bin
	echo "cross-compiling = no" > configparms
	make install_root=${TEMPROOT}
	make install_root=${TEMPROOT} install
	make install_root=${TEMPROOT} localedata/install-locales
#	exec /bin/bash --login

#build-static: check-be prelim
build-static: prelim
#	mknod -m 0666 /dev/null c 1 3
	cp malloc/Makefile malloc/Makefile.backup
## no perl in current install -> fudge autodetection:
	sed 's%$$(PERL)%/usr/bin/perl%' malloc/Makefile.backup > malloc/Makefile
	cp login/Makefile login/Makefile.backup
## sim. no glibc; can't resolve UID mappings...
	sed 's/root/0/' login/Makefile.backup > login/Makefile
#	mkdir ../glibc-build
#	cd ../glibc-build
#	../glibc-2.2.5 ...
	./configure --prefix=/usr --enable-add-ons=linuxthreads --libexecdir=/usr/bin
	#echo "cross-compiling = no" > configparms
	make install_root=${TEMPROOT} LDFLAGS=-static
	make install_root=${TEMPROOT} install
	make install_root=${TEMPROOT} localedata/install-locales
#	exec /bin/bash --login
