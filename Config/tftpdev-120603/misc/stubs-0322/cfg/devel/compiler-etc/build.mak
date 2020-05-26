#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: check-be default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
#	[ -d "${SRCXPATH}" ]
#	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}
	cd ${SRCTMP} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-toolroot

build-toolroot:
	[ -d binutils ] || mkdir binutils
	( cd binutils && ${MAKE} -f ${MAKEFILE} build-binutils-toolroot )
	[ -d gcc ] || mkdir gcc
	( cd gcc && ${MAKE} -f ${MAKEFILE} build-gcc-toolroot )
#	( cd ${LX_SRCXPATH} && ${MAKE} -f ${MAKEFILE} build-linux-toolroot )

.PHONY: build-binutils-toolroot

build-binutils-toolroot:
	( \
		../${BU_SRCXPATH}/configure \
		 --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr \
		 --disable-nls --disable-largefile \
		 --target=${TARGET_MACH}-linux \
			|| exit 1 ;\
		make || exit 1 ;\
		make install || exit 1 \
	) || exit 1

.PHONY: build-gcc-toolroot

build-gcc-toolroot:
	( \
		../${GCC_SRCXPATH}/configure \
		 --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr \
		 --enable-languages=c,c++ \
		 --disable-nls --disable-largefile \
		 --target=${TARGET_MACH}-linux \
			|| exit 1 ;\
		make || exit 1 \
	) || exit 1
#	( cd ${TOOLROOT}/lib && ln -sf ../usr/bin/cpp )
#	( cd ${TOOLROOT}/usr/lib && ln -sf ../bin/cpp )
#	( cd ${TOOLROOT}/usr/bin && ln -sf gcc cc )
