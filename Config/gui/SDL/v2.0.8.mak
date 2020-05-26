# SDL v2.0.8			[ since v1.2.9, c.2004-06-29 ]
# last mod WmT, 2018-03-13	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_SDL2_CONFIG},y)
HAVE_SDL2_CONFIG:=y

#DESCRLIST+= "'nti-SDL' -- SDL"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.13.mak


ifeq (${SDL2_VERSION},)
#SDL2_VERSION=2.0.3
#SDL2_VERSION=2.0.5
SDL2_VERSION=2.0.8
endif

SDL2_SRC=${SOURCES}/s/SDL2-${SDL2_VERSION}.tar.gz
URLS+= http://www.libsdl.org/release/SDL2-${SDL2_VERSION}.tar.gz


ifeq (${SDL_WITH_X11},true)
include ${CFG_ROOT}/x11-r7.7/libXext/v1.3.1.mak
endif


NTI_SDL2_TEMP=nti-SDL2-${SDL2_VERSION}

NTI_SDL2_EXTRACTED=${EXTTEMP}/${NTI_SDL2_TEMP}/sdl2.pc.in
NTI_SDL2_CONFIGURED=${EXTTEMP}/${NTI_SDL2_TEMP}/sdl2.pc
NTI_SDL2_BUILT=${EXTTEMP}/${NTI_SDL2_TEMP}/build/libSDL2.la
NTI_SDL2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sdl2.pc


## ,-----
## |	Extract
## +-----

${NTI_SDL2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL2-${SDL2_VERSION} ] || rm -rf ${EXTTEMP}/SDL2-${SDL2_VERSION}
	zcat ${SDL2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL2_TEMP}
	mv ${EXTTEMP}/SDL2-${SDL2_VERSION} ${EXTTEMP}/${NTI_SDL2_TEMP}


## ,-----
## |	Configure
## +-----

ifeq (${SDL_WITH_X11},true)
# TODO: maybe include libXrender? is X11 built sanely?
SDL_CONFIGURE_OPTS=	--enable-video-x11 \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib
else
SDL_CONFIGURE_OPTS=	--without-x
endif

${NTI_SDL2_CONFIGURED}: ${NTI_SDL2_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${LIBTOOL_HOST_TOOL} \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  ${SDL_CONFIGURE_OPTS} \
			--disable-video-opengl \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^	/	s%$$(libdir)/pkgconfig%'${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL2_BUILT}: ${NTI_SDL2_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
		make LIBTOOL=${LIBTOOL_HOST_TOOL} \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL2_INSTALLED}: ${NTI_SDL2_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
		make install LIBTOOL=${LIBTOOL_HOST_TOOL} \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/sdl2.pc ${NTI_SDL2_INSTALLED} \

##

.PHONY: nti-SDL2
ifeq (${SDL_WITH_X11},true)
nti-SDL2: \
	nti-libtool nti-pkg-config \
	nti-libXext \
	${NTI_SDL2_INSTALLED}
else
nti-SDL2: \
	nti-libtool nti-pkg-config \
	${NTI_SDL2_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-SDL2

endif	# HAVE_SDL2_CONFIG
