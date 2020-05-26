# xkbcomp v1.2.0		[ since v1.1.1, c.2013-04-13 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_XKBCOMP_CONFIG},y)
HAVE_XKBCOMP_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xkbcomp' -- xkbcomp"

ifeq (${XKBCOMP_VERSION},)
XKBCOMP_VERSION=1.2.0
endif

XKBCOMP_SRC=${SOURCES}/x/xkbcomp-${XKBCOMP_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/everything/xkbcomp-1.1.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/everything/xkbcomp-${XKBCOMP_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.6/xkbfile/v1.0.7.mak

NTI_XKBCOMP_TEMP=nti-xkbcomp-${XKBCOMP_VERSION}

NTI_XKBCOMP_EXTRACTED=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/configure
NTI_XKBCOMP_CONFIGURED=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/config.status
NTI_XKBCOMP_BUILT=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/xkbcomp
NTI_XKBCOMP_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xkbcomp


## ,-----
## |	Extract
## +-----

${NTI_XKBCOMP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION} ] || rm -rf ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION}
	bzcat ${XKBCOMP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XKBCOMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XKBCOMP_TEMP}
	mv ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION} ${EXTTEMP}/${NTI_XKBCOMP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XKBCOMP_CONFIGURED}: ${NTI_XKBCOMP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
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

${NTI_XKBCOMP_BUILT}: ${NTI_XKBCOMP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XKBCOMP_INSTALLED}: ${NTI_XKBCOMP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xkbcomp
nti-xkbcomp: nti-pkg-config \
	nti-libX11 nti-libxkbfile ${NTI_XKBCOMP_INSTALLED}

ALL_NTI_TARGETS+= nti-xkbcomp

endif	# HAVE_XKBCOMP_CONFIG
