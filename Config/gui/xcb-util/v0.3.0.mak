# xcb-util v0.3.0		[ since v0.2, c.2017-04-13 ]
# last mod WmT, 2017-04-13	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XCB_UTIL_CONFIG},y)
HAVE_XCB_UTIL_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xcb-util' -- xcb-util"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${XCB_UTIL_VERSION},)
#XCB_UTIL_VERSION=0.1	# broken re xcb.h; need 0.2+
#XCB_UTIL_VERSION=0.2	# missing xcb_size_hints_t (uwm dependency)
XCB_UTIL_VERSION=0.3.0
endif

XCB_UTIL_SRC=${SOURCES}/x/xcb-util-${XCB_UTIL_VERSION}.tar.bz2
URLS+= https://xcb.freedesktop.org/dist/xcb-util-${XCB_UTIL_VERSION}.tar.bz2

# Deps: needs X11 r7.6+
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.6/libxcb/v1.7.mak

NTI_XCB_UTIL_TEMP=nti-xcb-util-${XCB_UTIL_VERSION}

NTI_XCB_UTIL_EXTRACTED=${EXTTEMP}/${NTI_XCB_UTIL_TEMP}/configure
NTI_XCB_UTIL_CONFIGURED=${EXTTEMP}/${NTI_XCB_UTIL_TEMP}/config.status
NTI_XCB_UTIL_BUILT=${EXTTEMP}/${NTI_XCB_UTIL_TEMP}/atom/libxcb-atom.la
#NTI_XCB_UTIL_INSTALLED=${NTI_TC_ROOT}/usr/lib/libxcb-atom.a
NTI_XCB_UTIL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb-atom.pc


## ,-----
## |	Extract
## +-----

${NTI_XCB_UTIL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xcb-util-${XCB_UTIL_VERSION} ] || rm -rf ${EXTTEMP}/xcb-util-${XCB_UTIL_VERSION}
	bzcat ${XCB_UTIL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XCB_UTIL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XCB_UTIL_TEMP}
	mv ${EXTTEMP}/xcb-util-${XCB_UTIL_VERSION} ${EXTTEMP}/${NTI_XCB_UTIL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XCB_UTIL_CONFIGURED}: ${NTI_XCB_UTIL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_TEMP} || exit 1 ;\
		case ${XCB_UTIL_VERSION} in \
		testing--0.1--fails) \
			[ -r atom/atoms.gperf.m4.OLD ] || mv atom/atoms.gperf.m4 atom/atoms.gperf.m4.OLD || exit 1 ;\
			cat atom/atoms.gperf.m4.OLD \
				| sed '/#include/	s%X11/XCB%xcb%' \
				> atom/atoms.gperf.m4 \
		;; \
		esac ;\
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

${NTI_XCB_UTIL_BUILT}: ${NTI_XCB_UTIL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XCB_UTIL_INSTALLED}: ${NTI_XCB_UTIL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XCB_UTIL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xcb-util
nti-xcb-util: nti-pkg-config \
	nti-libxcb \
	${NTI_XCB_UTIL_INSTALLED}

ALL_NTI_TARGETS+= nti-xcb-util

endif	# HAVE_XCB_UTIL_CONFIG
