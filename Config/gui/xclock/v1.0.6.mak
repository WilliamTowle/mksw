# xclock v1.0.6			[ since v1.0.1	2009-09-04 ]
# last mod WmT, 2015-12-23	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_XCLOCK_CONFIG},y)
HAVE_XCLOCK_CONFIG:=y

DESCRLIST+= "'nti-xclock' -- xclock"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XCLOCK_VERSION},)
#XCLOCK_VERSION=1.0.1
#XCLOCK_VERSION=1.0.5
XCLOCK_VERSION=1.0.6
#XCLOCK_SRC=${SOURCES}/x/xclock_1.0.1.orig.tar.gz
#XCLOCK_SRC=${SOURCES}/x/xclock-1.0.1.tar.bz2
#XCLOCK_SRC=${SOURCES}/x/xclock-1.0.5.tar.bz2
XCLOCK_SRC=${SOURCES}/x/xclock-1.0.6.tar.bz2
endif

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/x/xclock/xclock_1.0.1.orig.tar.gz
#URLS+= http://xorg.freedesktop.org/releases/individual/app/xclock-1.0.1.tar.bz2
#URLS+= http://xorg.freedesktop.org/releases/individual/app/xclock-1.0.5.tar.bz2
URLS+= http://xorg.freedesktop.org/releases/individual/app/xclock-${XCLOCK_VERSION}.tar.bz2

#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/libXaw/v1.0.7.mak
include ${CFG_ROOT}/x11-r7.6/libXaw/v1.0.8.mak
#include ${CFG_ROOT}/gui/libXmu/v1.0.5.mak
include ${CFG_ROOT}/x11-r7.6/libXmu/v1.1.0.mak
#include ${CFG_ROOT}/gui/libXrender/v0.9.5.mak
include ${CFG_ROOT}/x11-r7.6/libXrender/v0.9.6.mak

NTI_XCLOCK_TEMP=nti-xclock-${XCLOCK_VERSION}

NTI_XCLOCK_EXTRACTED=${EXTTEMP}/${NTI_XCLOCK_TEMP}/README
NTI_XCLOCK_CONFIGURED=${EXTTEMP}/${NTI_XCLOCK_TEMP}/config.log
NTI_XCLOCK_BUILT=${EXTTEMP}/${NTI_XCLOCK_TEMP}/xclock
NTI_XCLOCK_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xclock



## ,-----
## |	Extract
## +-----

${NTI_XCLOCK_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xclock-${XCLOCK_VERSION} ] || rm -rf ${EXTTEMP}/xclock-${XCLOCK_VERSION}
	bzcat ${XCLOCK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XCLOCK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XCLOCK_TEMP}
	mv ${EXTTEMP}/xclock-${XCLOCK_VERSION} ${EXTTEMP}/${NTI_XCLOCK_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_XCLOCK_CONFIGURED}: ${NTI_XCLOCK_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--without-xft \
			--without-xkb \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_XCLOCK_BUILT}: ${NTI_XCLOCK_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XCLOCK_INSTALLED}: ${NTI_XCLOCK_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xclock
nti-xclock: nti-pkg-config \
	nti-libX11 nti-libXaw nti-libXmu nti-libXrender \
	${NTI_XCLOCK_INSTALLED}
#nti-xclock: nti-pkg-config nti-libX11 nti-libXaw nti-libXrender nti-xclock-installed

ALL_NTI_TARGETS+= nti-xclock

endif	# HAVE_XCLOCK_CONFIG
