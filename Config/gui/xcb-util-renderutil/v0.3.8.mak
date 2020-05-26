# xcb-util-renderutil v0.3.8	[ since v0.2, c.2017-04-13 ]
# last mod WmT, 2017-04-18	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XCB_UTIL_RENDERUTIL_CONFIG},y)
HAVE_XCB_UTIL_RENDERUTIL_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xcb-util-renderutil' -- xcb-util-renderutil"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${XCB_UTIL_RENDERUTIL_VERSION},)
XCB_UTIL_RENDERUTIL_VERSION=0.3.8
endif

XCB_UTIL_RENDERUTIL_SRC=${SOURCES}/x/xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION}.tar.bz2
URLS+= https://xcb.freedesktop.org/dist/xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION}.tar.bz2

# Deps: needs X11 r7.6+
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.6/libxcb/v1.7.mak

NTI_XCB_UTIL_RENDERUTIL_TEMP=nti-xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION}

NTI_XCB_UTIL_RENDERUTIL_EXTRACTED=${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP}/configure
NTI_XCB_UTIL_RENDERUTIL_CONFIGURED=${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP}/config.status
NTI_XCB_UTIL_RENDERUTIL_BUILT=${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP}/renderutil/xcb-renderutil.pc
NTI_XCB_UTIL_RENDERUTIL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb-renderutil.pc


## ,-----
## |	Extract
## +-----

${NTI_XCB_UTIL_RENDERUTIL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION} ] || rm -rf ${EXTTEMP}/xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION}
	bzcat ${XCB_UTIL_RENDERUTIL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP}
	mv ${EXTTEMP}/xcb-util-renderutil-${XCB_UTIL_RENDERUTIL_VERSION} ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XCB_UTIL_RENDERUTIL_CONFIGURED}: ${NTI_XCB_UTIL_RENDERUTIL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/^pkgconfigdir/	s%$${libdir}/pkgconfig%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> configure ;\
		chmod a+x configure ;\
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

${NTI_XCB_UTIL_RENDERUTIL_BUILT}: ${NTI_XCB_UTIL_RENDERUTIL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XCB_UTIL_RENDERUTIL_INSTALLED}: ${NTI_XCB_UTIL_RENDERUTIL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_RENDERUTIL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xcb-util-renderutil
nti-xcb-util-renderutil: nti-pkg-config \
	nti-libxcb \
	${NTI_XCB_UTIL_RENDERUTIL_INSTALLED}

ALL_NTI_TARGETS+= nti-xcb-util-renderutil

endif	# HAVE_XCB_UTIL_RENDERUTIL_CONFIG
