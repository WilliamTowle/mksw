#!/bin/gmake
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be prelim

#check-be:
#	which patch

prelim:
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
		mkdir bin usr ;\
		mkdir usr/info \
	) || exit 1 )

build: prelim
	./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr
	if [ ! -r gzexe.in.backup ] ; then \
		cp gzexe.in gzexe.in.backup ;\
		sed 's%"BINDIR"%/bin%' gzexe.in.backup > gzexe.in ;\
	fi
	make
	make install
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin && \
		rm zcmp && ln -s zdiff zcmp && \
		mv gzip ../../bin/ && \
		rm gunzip zcat && \
		cd ../../bin && \
		ln -sf gzip gunzip && \
		ln -sf gzip zcat && \
		ln -sf gunzip uncompress \
	)

build-cross: prelim
	CC=${CROSS_PREFIX}-gcc ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr
	if [ ! -r gzexe.in.backup ] ; then \
		cp gzexe.in gzexe.in.backup ;\
		sed 's%"BINDIR"%/bin%' gzexe.in.backup > gzexe.in ;\
	fi
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
	make install
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin && \
		rm zcmp && ln -s zdiff zcmp && \
		mv gzip ../../bin/ && \
		rm gunzip zcat && \
		cd ../../bin && \
		ln -sf gzip gunzip && \
		ln -sf gzip zcat && \
		ln -sf gunzip uncompress \
	)

build-static: prelim
	./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr
	make LDFLAGS=-static
	make install
	cp ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/gunzip ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/gzip ${INSTTMP}/${PKGNAME}-${PKGVER}/bin
	rm ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/gunzip ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/gzip
