# SDL v1.2.13			[ since v1.2.9, c.2004-06-29 ]
# last mod WmT, 2010-09-14	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_SDL_CONFIG},y)
HAVE_SDL_CONFIG:=y

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

DESCRLIST+= "'nti-SDL' -- SDL"

SDL_VER=1.2.13
SDL_SRC=${SRCDIR}/s/SDL-1.2.13.tar.gz

URLS+=http://www.libsdl.org/release/SDL-${SDL_VER}.tar.gz


## ,-----
## |	Extract
## +-----

NTI_SDL_TEMP=nti-SDL-${SDL_VER}

NTI_SDL_EXTRACTED=${EXTTEMP}/${NTI_SDL_TEMP}/Makefile

.PHONY: nti-SDL-extracted
nti-SDL-extracted: ${NTI_SDL_EXTRACTED}

${NTI_SDL_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_SDL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_SRC}
	mv ${EXTTEMP}/SDL-${SDL_VER} ${EXTTEMP}/${NTI_SDL_TEMP}


## ,-----
## |	Configure
## +-----

NTI_SDL_CONFIGURED=${EXTTEMP}/${NTI_SDL_TEMP}/config.status

.PHONY: nti-SDL-configured
nti-SDL-configured: nti-SDL-extracted ${NTI_SDL_CONFIGURED}

${NTI_SDL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_SDL_BUILT=${EXTTEMP}/${NTI_SDL_TEMP}/build/.libs/libSDL.a

.PHONY: nti-SDL-built
nti-SDL-built: nti-SDL-configured ${NTI_SDL_BUILT}

${NTI_SDL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_SDL_INSTALLED=${CTI_TC_ROOT}/usr/lib/libSDL.a

.PHONY: nti-SDL-installed
nti-SDL-installed: nti-SDL-built ${NTI_SDL_INSTALLED}

${NTI_SDL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-SDL
nti-SDL: nti-SDL-installed

TARGETS+= nti-SDL

endif	# HAVE_SDL_CONFIG
