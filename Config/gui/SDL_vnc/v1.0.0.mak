# SDL_vnc v1.0.0		[ since v1.0.0, 2014-10-27 ]
# last mod WmT, 2014-10-27	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SDL_VNC_CONFIG},y)
HAVE_SDL_VNC_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-SDL_vnc' -- SDL_vnc"

ifeq (${SDL_VNC_VERSION},)
SDL_VNC_VERSION=1.0.0
endif

SDL_VNC_SRC=${SOURCES}/s/SDL_vnc-${SDL_VNC_VERSION}.tar.gz
URLS+= http://www.ferzkopp.net/Software/SDL_vnc/SDL_vnc-1.0.0.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

NTI_SDL_VNC_TEMP=nti-SDL_vnc-${SDL_VNC_VERSION}

NTI_SDL_VNC_EXTRACTED=${EXTTEMP}/${NTI_SDL_VNC_TEMP}/configure
NTI_SDL_VNC_CONFIGURED=${EXTTEMP}/${NTI_SDL_VNC_TEMP}/config.log
NTI_SDL_VNC_BUILT=${EXTTEMP}/${NTI_SDL_VNC_TEMP}/.libs/libSDL_vnc.a
NTI_SDL_VNC_INSTALLED=${NTI_TC_ROOT}/usr/include/SDL/SDL_vnc.h


## ,-----
## |	Extract
## +-----

${NTI_SDL_VNC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL_vnc-${SDL_VNC_VERSION} ] || rm -rf ${EXTTEMP}/SDL_vnc-${SDL_VNC_VERSION}
	zcat ${SDL_VNC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_VNC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_VNC_TEMP}
	mv ${EXTTEMP}/SDL_vnc-${SDL_VNC_VERSION} ${EXTTEMP}/${NTI_SDL_VNC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDL_VNC_CONFIGURED}: ${NTI_SDL_VNC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_VNC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_VNC_BUILT}: ${NTI_SDL_VNC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_VNC_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_VNC_INSTALLED}: ${NTI_SDL_VNC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_VNC_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SDL_vnc
nti-SDL_vnc: nti-libtool nti-pkg-config nti-SDL ${NTI_SDL_VNC_INSTALLED}
#nti-SDL_vnc: nti-libtool nti-pkg-config nti-SDL nti-freetype2 ${NTI_SDL_VNC_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL_vnc

endif	# HAVE_SDL_VNC_CONFIG
