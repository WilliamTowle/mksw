# libXmu v1.0.5			[ since v1.0.4 c.2009-09-08 ]
# last mod WmT, 2014-01-03	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_LIBXMU_CONFIG},y)
HAVE_LIBXMU_CONFIG:=y

#DESCRLIST+= "'nti-libXmu' -- libXmu"

include ${CFG_ROOT}/ENV/buildtype.mak

#ifneq (${HAVE_CROSS_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VERSION}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VERSION}.mak
#endif

ifeq (${LIBXMU_VERSION},)
LIBXMU_VERSION=1.0.5
endif

LIBXMU_SRC=${SOURCES}/l/libXmu-${LIBXMU_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXmu-1.0.5.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.5/libXext/v1.1.1.mak
#include ${CFG_ROOT}/gui/libXext/v1.3.1.mak
include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak
#include ${CFG_ROOT}/gui/libXt/v1.1.3.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak
#include ${CFG_ROOT}/gui/x11proto-xext/v7.2.1.mak


NTI_LIBXMU_TEMP=nti-libXmu-${LIBXMU_VERSION}

NTI_LIBXMU_EXTRACTED=${EXTTEMP}/${NTI_LIBXMU_TEMP}/configure
NTI_LIBXMU_CONFIGURED=${EXTTEMP}/${NTI_LIBXMU_TEMP}/config.status
NTI_LIBXMU_BUILT=${EXTTEMP}/${NTI_LIBXMU_TEMP}/xmu.pc
NTI_LIBXMU_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xmu.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXMU_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXmu-${LIBXMU_VERSION} ] || rm -rf ${EXTTEMP}/libXmu-${LIBXMU_VERSION}
	bzcat ${LIBXMU_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXMU_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXMU_TEMP}
	mv ${EXTTEMP}/libXmu-${LIBXMU_VERSION} ${EXTTEMP}/${NTI_LIBXMU_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXMU_CONFIGURED}: ${NTI_LIBXMU_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXMU_TEMP} || exit 1 ;\
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

${NTI_LIBXMU_BUILT}: ${NTI_LIBXMU_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXMU_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXMU_INSTALLED}: ${NTI_LIBXMU_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXMU_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXmu
nti-libXmu: nti-pkg-config nti-libXt nti-libXext nti-x11proto-xext ${NTI_LIBXMU_INSTALLED}

ALL_NTI_TARGETS+= nti-libXmu

endif	# HAVE_LIBXMU_CONFIG
