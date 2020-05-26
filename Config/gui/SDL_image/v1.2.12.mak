# SDL_image v1.2.12		[ since v1.2.10, c.2010-12-17 ]
# last mod WmT, 2014-06-11	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SDL_IMAGE_CONFIG},y)
HAVE_SDL_IMAGE_CONFIG:=y

#DESCRLIST+= "'nti-SDL_image' -- SDL_image"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SDL_IMAGE_VERSION},)
SDL_IMAGE_VERSION=1.2.12
endif

SDL_IMAGE_SRC=${SOURCES}/s/SDL_image-${SDL_IMAGE_VERSION}.tar.gz
URLS+= http://www.libsdl.org/projects/SDL_image/release/SDL_image-${SDL_IMAGE_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak


NTI_SDL_IMAGE_TEMP=nti-SDL_image-${SDL_IMAGE_VERSION}

NTI_SDL_IMAGE_EXTRACTED=${EXTTEMP}/${NTI_SDL_IMAGE_TEMP}/configure
NTI_SDL_IMAGE_CONFIGURED=${EXTTEMP}/${NTI_SDL_IMAGE_TEMP}/config.log
NTI_SDL_IMAGE_BUILT=${EXTTEMP}/${NTI_SDL_IMAGE_TEMP}/.libs/libSDL_image.a
NTI_SDL_IMAGE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/SDL_image.pc


## ,-----
## |	Extract
## +-----

${NTI_SDL_IMAGE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL_image-${SDL_IMAGE_VERSION} ] || rm -rf ${EXTTEMP}/SDL_image-${SDL_IMAGE_VERSION}
	zcat ${SDL_IMAGE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP}
	mv ${EXTTEMP}/SDL_image-${SDL_IMAGE_VERSION} ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDL_IMAGE_CONFIGURED}: ${NTI_SDL_IMAGE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$(libdir)/pkgconfig%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		CPPFLAGS=-I${NTI_TC_ROOT}/usr/include \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			--without-x \
			--enable-jpg \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_IMAGE_BUILT}: ${NTI_SDL_IMAGE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_IMAGE_INSTALLED}: ${NTI_SDL_IMAGE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_IMAGE_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SDL_image
nti-SDL_image: nti-jpegsrc nti-SDL ${NTI_SDL_IMAGE_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL_image

endif	# HAVE_SDL_IMAGE_CONFIG
