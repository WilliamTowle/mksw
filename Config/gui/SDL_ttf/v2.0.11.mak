# SDL_ttf v2.0.11		[ since v1.2.9, c.2010-05-05 ]
# last mod WmT, 2014-06-11	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SDL_TTF_CONFIG},y)
HAVE_SDL_TTF_CONFIG:=y

#DESCRLIST+= "'nti-SDL_ttf' -- SDL_ttf"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${SDL_TTF_VERSION},)
SDL_TTF_VERSION=2.0.11
endif

SDL_TTF_SRC=${SOURCES}/s/SDL_ttf-${SDL_TTF_VERSION}.tar.gz
URLS+= http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-${SDL_TTF_VERSION}.tar.gz


include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/audvid/freetype/v2.4.11.mak
include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
ifeq (${SDL_WITH_X11},true)
include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak
endif

NTI_SDL_TTF_TEMP=nti-SDL_ttf-${SDL_TTF_VERSION}

NTI_SDL_TTF_EXTRACTED=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/configure
NTI_SDL_TTF_CONFIGURED=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/config.log
NTI_SDL_TTF_BUILT=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/.libs/libSDL_ttf.a
NTI_SDL_TTF_INSTALLED=${NTI_TC_ROOT}/usr/lib/libSDL_ttf.a


## ,-----
## |	Extract
## +-----

${NTI_SDL_TTF_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL_ttf-${SDL_TTF_VERSION} ] || rm -rf ${EXTTEMP}/SDL_ttf-${SDL_TTF_VERSION}
	zcat ${SDL_TTF_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_TTF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_TTF_TEMP}
	mv ${EXTTEMP}/SDL_ttf-${SDL_TTF_VERSION} ${EXTTEMP}/${NTI_SDL_TTF_TEMP}


## ,-----
## |	Configure
## +-----

ifeq (${SDL_WITH_X11},true)
SDL_TTF_CONFIGURE_OPTS=	--with-x \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib
else
SDL_TTF_CONFIGURE_OPTS=	--without-x
endif


${NTI_SDL_TTF_CONFIGURED}: ${NTI_SDL_TTF_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-freetype-prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			  ${SDL_TTF_CONFIGURE_OPTS} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_TTF_BUILT}: ${NTI_SDL_TTF_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_TTF_INSTALLED}: ${NTI_SDL_TTF_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SDL_ttf
ifeq (${SDL_WITH_X11},true)
nti-SDL_ttf: nti-libtool nti-pkg-config \
	nti-freetype2 nti-libgl-mesa nti-SDL \
	${NTI_SDL_TTF_INSTALLED}
else
nti-SDL_ttf: nti-libtool nti-pkg-config \
	nti-freetype2 nti-SDL \
	${NTI_SDL_TTF_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-SDL_ttf

endif	# HAVE_SDL_TTF_CONFIG
