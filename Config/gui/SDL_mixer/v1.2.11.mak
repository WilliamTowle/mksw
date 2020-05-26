# SDL_mixer v1.2.11		[ since v1.2.9, c.2010-05-05 ]
# last mod WmT, 2014-06-11	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SDL_MIXER_CONFIG},y)
HAVE_SDL_MIXER_CONFIG:=y

DESCRLIST+= "'nti-SDL_mixer' -- SDL_mixer"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${SDL_MIXER_VERSION},)
SDL_MIXER_VERSION=1.2.11
endif

SDL_MIXER_SRC=${SRCDIR}/s/SDL_mixer-1.2.11.tar.gz

URLS+=http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.11.tar.gz

NTI_SDL_MIXER_TEMP=nti-SDL_mixer-${SDL_MIXER_VERSION}

NTI_SDL_MIXER_EXTRACTED=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/Makefile
NTI_SDL_MIXER_BUILT=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/build/.libs/libSDL_mixer.a
DL_MIXER_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/SDL_mixer.pc
NTI_SDL_MIXER_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/SDL_mixer.pc


## ,-----
## |	Extract
## +-----

.PHONY: nti-SDL_mixer-extracted
nti-SDL_mixer-extracted: ${NTI_SDL_MIXER_EXTRACTED}

${NTI_SDL_MIXER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_MIXER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_MIXER_SRC}
	mv ${EXTTEMP}/SDL_mixer-${SDL_MIXER_VERSION} ${EXTTEMP}/${NTI_SDL_MIXER_TEMP}


## ,-----
## |	Configure
## +-----

NTI_SDL_MIXER_CONFIGURED=${EXTTEMP}/${NTI_SDL_MIXER_TEMP}/config.status

.PHONY: nti-SDL_mixer-configured
nti-SDL_mixer-configured: nti-SDL_mixer-extracted ${NTI_SDL_MIXER_CONFIGURED}

${NTI_SDL_MIXER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			--without-x \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

.PHONY: nti-SDL_mixer-built
nti-SDL_mixer-built: nti-SDL_mixer-configured ${NTI_SDL_MIXER_BUILT}

${NTI_SDL_MIXER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

.PHONY: nti-SDL_mixer-installed
nti-SDL_mixer-installed: nti-SDL_mixer-built ${NTI_SDL_MIXER_INSTALLED}

${NTI_SDL_MIXER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_MIXER_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/SDL_mixer.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ \
	)

.PHONY: nti-SDL_mixer
nti-SDL_mixer: nti-SDL_mixer-installed

NTARGETS+= nti-SDL_mixer

endif	# HAVE_SDL_MIXER_CONFIG
