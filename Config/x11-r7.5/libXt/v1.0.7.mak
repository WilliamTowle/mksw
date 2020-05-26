# libXt v1.0.7			[ since v1.0.5 c.2009-09-08 ]
# last mod WmT, 2013-01-04	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBXT_CONFIG},y)
HAVE_LIBXT_CONFIG:=y

#DESCRLIST+= "'nti-libXt' -- libXt"

include ${CFG_ROOT}/ENV/buildtype.mak

#ifneq (${HAVE_CROSS_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VERSION}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VERSION}.mak
#endif

ifeq (${LIBXT_VERSION},)
LIBXT_VERSION=1.0.7
endif

LIBXT_SRC=${SOURCES}/l/libXt-${LIBXT_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXt-1.0.7.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.5/libSM/v1.1.1.mak
#include ${CFG_ROOT}/gui/libSM/v1.2.1.mak
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/gui/libX11/v1.5.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.23.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-kb/v1.0.4.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.6.mak


NTI_LIBXT_TEMP=nti-libXt-${LIBXT_VERSION}

NTI_LIBXT_EXTRACTED=${EXTTEMP}/${NTI_LIBXT_TEMP}/configure
NTI_LIBXT_CONFIGURED=${EXTTEMP}/${NTI_LIBXT_TEMP}/config.status
NTI_LIBXT_BUILT=${EXTTEMP}/${NTI_LIBXT_TEMP}/xt.pc
NTI_LIBXT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xt.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXt-${LIBXT_VERSION} ] || rm -rf ${EXTTEMP}/libXt-${LIBXT_VERSION}
	bzcat ${LIBXT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXT_TEMP}
	mv ${EXTTEMP}/libXt-${LIBXT_VERSION} ${EXTTEMP}/${NTI_LIBXT_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXT_CONFIGURED}: ${NTI_LIBXT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXT_BUILT}: ${NTI_LIBXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXT_INSTALLED}: ${NTI_LIBXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXt
nti-libXt: nti-pkg-config nti-libSM nti-libX11 nti-x11proto nti-x11proto-kb ${NTI_LIBXT_INSTALLED}

ALL_NTI_TARGETS+= nti-libXt

endif	# HAVE_LIBXT_CONFIG
