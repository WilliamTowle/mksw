# SDL v1.2.15			[ EARLIEST v?.?? ]
# last mod WmT, 2018-03-13	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_SDL_CONFIG},y)
HAVE_SDL_CONFIG:=y

#DESCRLIST+= "'nti-SDL' -- SDL"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.13.mak


ifeq (${SDL_VERSION},)
#SDL_VERSION=1.2.14
SDL_VERSION=1.2.15
endif

SDL_SRC=${SOURCES}/s/SDL-${SDL_VERSION}.tar.gz
URLS+= http://www.libsdl.org/release/SDL-${SDL_VERSION}.tar.gz

ifeq (${SDL_WITH_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#? include ${CFG_ROOT}/x11-r7.5/libXdamage/v1.1.2.mak
include ${CFG_ROOT}/x11-r7.5/libXfixes/v4.0.4.mak
include ${CFG_ROOT}/x11-r7.5/libXrender/v0.9.5.mak
include ${CFG_ROOT}/x11-r7.5/libXxf86vm/v1.1.0.mak
endif

NTI_SDL_TEMP=nti-SDL-${SDL_VERSION}

NTI_SDL_EXTRACTED=${EXTTEMP}/${NTI_SDL_TEMP}/Makefile
NTI_SDL_CONFIGURED=${EXTTEMP}/${NTI_SDL_TEMP}/config.log
NTI_SDL_BUILT=${EXTTEMP}/${NTI_SDL_TEMP}/build/.libs/libSDL.a
NTI_SDL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sdl.pc

# Helpers for external use (post-installation)
SDL_CONFIG_TOOL= ${NTI_TC_ROOT}/usr/bin/sdl-config


## ,-----
## |	Extract
## +-----

${NTI_SDL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL-${SDL_VERSION} ] || rm -rf ${EXTTEMP}/SDL-${SDL_VERSION}
	zcat ${SDL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_TEMP}
	mv ${EXTTEMP}/SDL-${SDL_VERSION} ${EXTTEMP}/${NTI_SDL_TEMP}


## ,-----
## |	Configure
## +-----

ifeq (${SDL_WITH_X11},true)
# TODO: maybe include libXrender? is X11 built sanely?
#SDL_CONFIGURE_ENV=	CFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
#			LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib'
SDL_CONFIGURE_OPTS=	--enable-video-x11 \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib
#? SDL_CONFIGURE_OPTS+= --disable-video-x11-xrandr
#? SDL_CONFIGURE_OPTS+= --disable-x11-shared
else
# TODO: --enable-nanox-FOO?
SDL_CONFIGURE_ENV=
SDL_CONFIGURE_OPTS=	--without-x
endif

## [2015-12-24] libtool problem if we specify CC=${NTI_GCC}??

${NTI_SDL_CONFIGURED}: ${NTI_SDL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^	/	s%$$(libdir)/pkgconfig%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		  ${SDL_CONFIGURE_ENV} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  ${SDL_CONFIGURE_OPTS} \
			--enable-video-opengl=no \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_BUILT}: ${NTI_SDL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_INSTALLED}: ${NTI_SDL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SDL
ifeq (${SDL_WITH_X11},true)
#nti-SDL: nti-libtool nti-pkg-config \
#	nti-libX11 nti-libXdamage nti-libXfixes nti-libXrender nti-libXxf86vm \
#	${NTI_SDL_INSTALLED}
nti-SDL: nti-libtool nti-pkg-config \
	nti-libX11 nti-libXfixes nti-libXrender nti-libXxf86vm \
	${NTI_SDL_INSTALLED}
else
nti-SDL: nti-libtool nti-pkg-config \
	${NTI_SDL_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-SDL

endif	# HAVE_SDL_CONFIG
