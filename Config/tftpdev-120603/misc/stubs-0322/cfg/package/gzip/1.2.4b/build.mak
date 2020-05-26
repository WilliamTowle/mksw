#!/bin/gmake
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

#.PHONY: build build-static check-be prelim
#
##check-be:
##	which patch

.PHONY: build-cross build-toolroot prelim

prelim:
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
		mkdir bin usr ;\
		mkdir usr/bin usr/info \
	) || exit 1 )

build-cross:
	${MAKE} -f ${MAKEFILE} INSTROOT=${INSTTMP}/${PKGNAME}-${PKGVER} prelim
	CC=${CROSS_PREFIX}-gcc ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr
	if [ ! -r gzexe.in.backup ] ; then \
		cp gzexe.in gzexe.in.backup ;\
		sed 's%"BINDIR"%/bin%' gzexe.in.backup > gzexe.in ;\
	fi
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make
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

build-toolroot:
	${MAKE} -f ${MAKEFILE} INSTROOT=${TOOLROOT} prelim
	./configure --prefix=${TOOLROOT}/usr
	if [ ! -r gzexe.in.backup ] ; then \
		cp gzexe.in gzexe.in.backup ;\
		sed 's%"BINDIR"%/bin%' gzexe.in.backup > gzexe.in ;\
	fi
	make
	make install
	( cd ${TOOLROOT}/usr/bin && \
		rm zcmp && ln -s zdiff zcmp && \
		mv gzip ../../bin/ && \
		rm gunzip zcat && \
		cd ../../bin && \
		ln -sf gzip gunzip && \
		ln -sf gzip zcat && \
		ln -sf gunzip uncompress \
	)
