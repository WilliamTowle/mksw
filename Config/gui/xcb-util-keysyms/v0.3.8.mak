# xcb-util-keysyms v0.3.8		[ since v0.2, c.2017-04-13 ]
# last mod WmT, 2017-04-13	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XCB_UTIL_KEYSYMS_CONFIG},y)
HAVE_XCB_UTIL_KEYSYMS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xcb-util-keysyms' -- xcb-util-keysyms"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${XCB_UTIL_KEYSYMS_VERSION},)
XCB_UTIL_KEYSYMS_VERSION=0.3.8
endif

XCB_UTIL_KEYSYMS_SRC=${SOURCES}/x/xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION}.tar.bz2
URLS+= https://xcb.freedesktop.org/dist/xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION}.tar.bz2

# Deps: needs X11 r7.6+
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.6/libxcb/v1.7.mak

NTI_XCB_UTIL_KEYSYMS_TEMP=nti-xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION}

NTI_XCB_UTIL_KEYSYMS_EXTRACTED=${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP}/configure
NTI_XCB_UTIL_KEYSYMS_CONFIGURED=${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP}/config.status
NTI_XCB_UTIL_KEYSYMS_BUILT=${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP}/libxcb-util-keysyms.la
NTI_XCB_UTIL_KEYSYMS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb-util-keysyms.pc


## ,-----
## |	Extract
## +-----

${NTI_XCB_UTIL_KEYSYMS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION} ] || rm -rf ${EXTTEMP}/xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION}
	bzcat ${XCB_UTIL_KEYSYMS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP}
	mv ${EXTTEMP}/xcb-util-keysyms-${XCB_UTIL_KEYSYMS_VERSION} ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XCB_UTIL_KEYSYMS_CONFIGURED}: ${NTI_XCB_UTIL_KEYSYMS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP} || exit 1 ;\
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

${NTI_XCB_UTIL_KEYSYMS_BUILT}: ${NTI_XCB_UTIL_KEYSYMS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XCB_UTIL_KEYSYMS_INSTALLED}: ${NTI_XCB_UTIL_KEYSYMS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_KEYSYMS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xcb-util-keysyms
nti-xcb-util-keysyms: nti-pkg-config \
	nti-libxcb \
	${NTI_XCB_UTIL_KEYSYMS_INSTALLED}

ALL_NTI_TARGETS+= nti-xcb-util-keysyms

endif	# HAVE_XCB_UTIL_KEYSYMS_CONFIG
