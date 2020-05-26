# SDL_mixer v1.2.12		[ EARLIEST v?.?? ]
# last mod WmT, 2013-01-12	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_SDL_MIXER_CONFIG},y)
HAVE_SDL_MIXER_CONFIG:=y

#DESCRLIST+= "'nti-SDL_mixer' -- SDL_mixer"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${SDL_MIXER_VERSION},)
SDL_MIXER_VERSION=1.2.12
endif

SDL_MIXER_SRC=${SOURCES}/s/SDL_mixer-${SDL_MIXER_VERSION}.tar.gz
URLS+= http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-${SDL_MIXER_VERSION}.tar.gz

include ${CFG_ROOT}/audvid/libogg/v1.3.2.mak
include ${CFG_ROOT}/audvid/libvorbis/v1.3.5.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak


NTI_SDL_MIXER_TEMP=nti-SDL_mixer-${SDL_MIXER_VERSION}

NTI_SDL_MIXER_EXTRACTED=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/Makefile
NTI_SDL_MIXER_CONFIGURED=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/config.log
NTI_SDL_MIXER_BUILT=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/build/.libs/libSDL_mixer.a
NTI_SDL_MIXER_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/SDL_mixer.pc


## ,-----
## |	Extract
## +-----

${NTI_SDL_MIXER_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL_mixer-${SDL_MIXER_VERSION} ] || rm -rf ${EXTTEMP}/SDL_mixer-${SDL_MIXER_VERSION}
	zcat ${SDL_MIXER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_MIXER_TEMP}
	mv ${EXTTEMP}/SDL_mixer-${SDL_MIXER_VERSION} ${EXTTEMP}/${NTI_SDL_MIXER_TEMP}


## ,-----
## |	Configure
## +-----

## [2015-12-24] libtool problem if we specify CC=${NTI_GCC}??

${NTI_SDL_MIXER_CONFIGURED}: ${NTI_SDL_MIXER_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^	/	s%$$(libdir)/pkgconfig%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		  CFLAGS='-I'"` ${NTI_TC_ROOT}/usr/bin/i686-provider-linux-gnu-pkg-config --variable=prefix sdl `"'/include' \
		  LDFLAGS='-L'"` ${NTI_TC_ROOT}/usr/bin/i686-provider-linux-gnu-pkg-config --variable=prefix sdl `"'/lib' \
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

${NTI_SDL_MIXER_BUILT}: ${NTI_SDL_MIXER_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_MIXER_INSTALLED}: ${NTI_SDL_MIXER_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SDL_mixer
nti-SDL_mixer: nti-pkg-config \
	nti-libogg nti-libvorbis nti-SDL ${NTI_SDL_MIXER_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL_mixer

endif	# HAVE_SDL_MIXER_CONFIG
