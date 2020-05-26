# SDL_gfx v2.0.13		[ earliest v2.0.13, c.2011-08-31 ]
# last mod WmT, 2014-03-12	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_SDL_GFX_CONFIG},y)
HAVE_SDL_GFX_CONFIG:=y

DESCRLIST+= "'nti-SDL_gfx' -- SDL_gfx"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

ifeq (${SDL_GFX_VERSION},)
SDL_GFX_VERSION=2.0.13
#SDL_GFX_VERSION=2.0.22
#SDL_GFX_VERSION=2.0.25
endif

SDL_GFX_SRC=${SOURCES}/s/SDL_gfx-${SDL_GFX_VERSION}.tar.gz
URLS+= http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-${SDL_GFX_VERSION}.tar.gz


NTI_SDL_GFX_TEMP=nti-SDL-${SDL_GFX_VERSION}

NTI_SDL_GFX_EXTRACTED=${EXTTEMP}/${NTI_SDL_GFX_TEMP}/Makefile
NTI_SDL_GFX_CONFIGURED=${EXTTEMP}/${NTI_SDL_GFX_TEMP}/config.log
NTI_SDL_GFX_BUILT=${EXTTEMP}/${NTI_SDL_GFX_TEMP}/build/.libs/libSDL.a
NTI_SDL_GFX_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/SDL_gfx.pc


## ,-----
## |	Extract
## +-----

${NTI_SDL_GFX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL-${SDL_GFX_VERSION} ] || rm -rf ${EXTTEMP}/SDL-${SDL_GFX_VERSION}
	zcat ${SDL_GFX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_GFX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_GFX_TEMP}
	mv ${EXTTEMP}/SDL_gfx-${SDL_GFX_VERSION} ${EXTTEMP}/${NTI_SDL_GFX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDL_GFX_CONFIGURED}: ${NTI_SDL_GFX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_GFX_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_GFX_BUILT}: ${NTI_SDL_GFX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_GFX_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_GFX_INSTALLED}: ${NTI_SDL_GFX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_GFX_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/sdl.pc ${NTI_SDL_GFX_INSTALLED} \
	)

##

.PHONY: nti-SDL_gfx
nti-SDL_gfx: ${NTI_SDL_GFX_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL_gfx

endif	# HAVE_SDL_GFX_CONFIG
