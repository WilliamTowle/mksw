# xclock v1.0.6			[ since v1.0.1	2009-09-04 ]
# last mod WmT, 2015-10-26	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_XCLOCK_CONFIG},y)
HAVE_XCLOCK_CONFIG:=y

#DESCRLIST+= "'cui-xclock' -- xclock"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XCLOCK_VERSION},)
XCLOCK_VERSION=1.0.6
endif

XCLOCK_SRC=${SOURCES}/x/xclock-${XCLOCK_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/app/xclock-1.0.6.tar.bz2

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/libXaw/v1.0.7.mak
include ${CFG_ROOT}/x11-r7.6/libXaw/v1.0.8.mak
#include ${CFG_ROOT}/gui/libXrender/v0.9.5.mak
include ${CFG_ROOT}/x11-r7.6/libXrender/v0.9.6.mak
include ${CFG_ROOT}/x11-r7.6/xkbfile/v1.0.7.mak

NTI_XCLOCK_TEMP=nti-xclock-${XCLOCK_VERSION}
NTI_XCLOCK_EXTRACTED=${EXTTEMP}/${NTI_XCLOCK_TEMP}/configure
NTI_XCLOCK_CONFIGURED=${EXTTEMP}/${NTI_XCLOCK_TEMP}/config.log
NTI_XCLOCK_BUILT=${EXTTEMP}/${NTI_XCLOCK_TEMP}/xclock
NTI_XCLOCK_INSTALLED=${NTI_TC_ROOT}/usr/bin/xclock


# ,-----
# |	Extract
# +-----

${NTI_XCLOCK_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xclock-${XCLOCK_VERSION} ] || rm -rf ${EXTTEMP}/xclock-${XCLOCK_VERSION}
	bzcat ${XCLOCK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XCLOCK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XCLOCK_TEMP}
	mv ${EXTTEMP}/xclock-${XCLOCK_VERSION} ${EXTTEMP}/${NTI_XCLOCK_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_XCLOCK_CONFIGURED}: ${NTI_XCLOCK_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--with-appdefaultdir=${NTI_TC_ROOT}/etc/X11/app-defaults \
				--without-xft \
	)


# ,-----
# |	Build
# +-----

${NTI_XCLOCK_BUILT}: ${NTI_XCLOCK_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_XCLOCK_INSTALLED}: ${NTI_XCLOCK_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XCLOCK_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xclock
nti-xclock: nti-pkg-config \
	nti-libX11 nti-libXaw nti-libXmu nti-libXrender \
	nti-libxkbfile \
	${NTI_XCLOCK_INSTALLED}

ALL_NTI_TARGETS+= nti-xclock

endif	# HAVE_XCLOCK_CONFIG
