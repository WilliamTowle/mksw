# libXmu v1.1.0			[ since v1.0.4 c.2009-09-08 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXMU_CONFIG},y)
HAVE_LIBXMU_CONFIG:=y

#DESCRLIST+= "'nti-libXmu' -- libXmu"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXMU_VERSION},)
#LIBXMU_VERSION=1.0.5
LIBXMU_VERSION=1.1.0
endif
#LIBXMU_SRC=${SOURCES}/l/libxmu_1.0.4.orig.tar.gz
LIBXMU_SRC=${SOURCES}/l/libXmu-${LIBXMU_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXmu-1.0.5.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libXmu-1.1.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/gui/libXext/v1.1.1.mak
include ${CFG_ROOT}/x11-r7.6/libXext/v1.2.0.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
include ${CFG_ROOT}/x11-r7.6/libXt/v1.0.9.mak
#include ${CFG_ROOT}/gui/x11proto-xext/v7.1.1.mak
include ${CFG_ROOT}/x11-r7.6/x11proto-xext/v7.1.2.mak


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
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
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
