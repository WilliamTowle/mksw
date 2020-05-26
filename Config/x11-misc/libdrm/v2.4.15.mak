# libdrm v2.4.15		[ since v2.4.15, 2014-03-06 ]
# last mod WmT, 2014-03-06	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBDRM_CONFIG},y)
HAVE_LIBDRM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-libdrm' -- libdrm"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}//gui/libpthread-stubs/v0.3.mak

ifeq (${LIBDRM_VERSION},)
LIBDRM_VERSION=2.4.15
endif

LIBDRM_SRC=${SOURCES}/l/libdrm-${LIBDRM_VERSION}.tar.bz2
URLS+= http://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VERSION}.tar.bz2

NTI_LIBDRM_TEMP=nti-libdrm-${LIBDRM_VERSION}

NTI_LIBDRM_EXTRACTED=${EXTTEMP}/${NTI_LIBDRM_TEMP}/configure
NTI_LIBDRM_CONFIGURED=${EXTTEMP}/${NTI_LIBDRM_TEMP}/config.status
NTI_LIBDRM_BUILT=${EXTTEMP}/${NTI_LIBDRM_TEMP}/libdrm/intel/libdrm_intel.la
NTI_LIBDRM_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libdrm_intel.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBDRM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libdrm-${LIBDRM_VERSION} ] || rm -rf ${EXTTEMP}/libdrm-${LIBDRM_VERSION}
	bzcat ${LIBDRM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBDRM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBDRM_TEMP}
	mv ${EXTTEMP}/libdrm-${LIBDRM_VERSION} ${EXTTEMP}/${NTI_LIBDRM_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBDRM_CONFIGURED}: ${NTI_LIBDRM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
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

${NTI_LIBDRM_BUILT}: ${NTI_LIBDRM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBDRM_INSTALLED}: ${NTI_LIBDRM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
		make install ;\
		mkdir -p ` dirname ${NTI_LIBDRM_INSTALLED} ` ;\
		cp libdrm.pc libdrm_intel.pc ` dirname ${NTI_LIBDRM_INSTALLED} ` \
	)

.PHONY: nti-libdrm
nti-libdrm: nti-pkg-config nti-libpthread-stubs ${NTI_LIBDRM_INSTALLED}
#nti-libdrm: nti-pkg-config nti-libX11 nti-libXext nti-libXmu nti-libXt nti-x11proto-xext ${NTI_LIBDRM_INSTALLED}

ALL_NTI_TARGETS+= nti-libdrm

endif	# HAVE_LIBDRM_CONFIG
