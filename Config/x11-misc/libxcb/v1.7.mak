# libxcb v1.7			[ since v1.9, c.2013-01-04 ]
# last mod WmT, 2013-05-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBXCB_CONFIG},y)
HAVE_LIBXCB_CONFIG:=y

#DESCRLIST+= "'nti-libxcb' -- libxcb"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXCB_VERSION},)
LIBXCB_VERSION=1.7
endif

LIBXCB_SRC=${SOURCES}/l/libxcb-1.7.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/xcb/libxcb-1.7.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
include ${CFG_ROOT}/gui/x11proto-xcb/v1.6.mak
include ${CFG_ROOT}/gui/libXau/v1.0.6.mak

NTI_LIBXCB_TEMP=nti-libxcb-${LIBXCB_VERSION}

NTI_LIBXCB_EXTRACTED=${EXTTEMP}/${NTI_LIBXCB_TEMP}/configure
NTI_LIBXCB_CONFIGURED=${EXTTEMP}/${NTI_LIBXCB_TEMP}/config.status
NTI_LIBXCB_BUILT=${EXTTEMP}/${NTI_LIBXCB_TEMP}/xcb.pc
NTI_LIBXCB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXCB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxcb-${LIBXCB_VERSION} ] || rm -rf ${EXTTEMP}/libxcb-${LIBXCB_VERSION}
	bzcat ${LIBXCB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXCB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXCB_TEMP}
	mv ${EXTTEMP}/libxcb-${LIBXCB_VERSION} ${EXTTEMP}/${NTI_LIBXCB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXCB_CONFIGURED}: ${NTI_LIBXCB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
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

${NTI_LIBXCB_BUILT}: ${NTI_LIBXCB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXCB_INSTALLED}: ${NTI_LIBXCB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xcb.pc ${NTI_TC_ROOT}/usr/lib/xcb-*.pc ${NTI_LIBXCB_INSTALLED} \
	)

.PHONY: nti-libxcb
nti-libxcb: nti-pkg-config nti-x11proto nti-x11proto-xcb nti-libXau ${NTI_LIBXCB_INSTALLED}

ALL_NTI_TARGETS+= nti-libxcb

endif	# HAVE_LIBXCB_CONFIG
