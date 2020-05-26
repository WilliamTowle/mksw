# SDL_ttf v2.0.9		[ since v1.2.9, c.2010-05-05 ]
# last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SDL_TTF_CONFIG},y)
HAVE_SDL_TTF_CONFIG:=y

DESCRLIST+= "'nti-SDL_ttf' -- SDL_ttf"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

SDL_TTF_VER=2.0.9
SDL_TTF_SRC=${SRCDIR}/s/SDL_ttf-2.0.9.tar.gz

URLS+=http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz


## ,-----
## |	Extract
## +-----

NTI_SDL_TTF_TEMP=nti-SDL_ttf-${SDL_TTF_VER}

NTI_SDL_TTF_EXTRACTED=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/Makefile

.PHONY: nti-SDL_ttf-extracted
nti-SDL_ttf-extracted: ${NTI_SDL_TTF_EXTRACTED}

${NTI_SDL_TTF_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_SDL_TTF_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_TTF_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_TTF_SRC}
	mv ${EXTTEMP}/SDL_ttf-${SDL_TTF_VER} ${EXTTEMP}/${NTI_SDL_TTF_TEMP}

## ,-----
## |	Configure
## +-----

NTI_SDL_TTF_CONFIGURED=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/config.status

.PHONY: nti-SDL_ttf-configured
nti-SDL_ttf-configured: nti-SDL_ttf-extracted ${NTI_SDL_TTF_CONFIGURED}

${NTI_SDL_TTF_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)

## ,-----
## |	Build
## +-----

NTI_SDL_TTF_BUILT=${EXTTEMP}/${NTI_SDL_TTF_TEMP}/libSDL_ttf.la

.PHONY: nti-SDL_ttf-built
nti-SDL_ttf-built: nti-SDL_ttf-configured ${NTI_SDL_TTF_BUILT}

${NTI_SDL_TTF_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
		make \
			LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

NTI_SDL_TTF_INSTALLED=${NTI_TC_ROOT}/usr/lib/libSDL_ttf.a

.PHONY: nti-SDL_ttf-installed
nti-SDL_ttf-installed: nti-SDL_ttf-built ${NTI_SDL_TTF_INSTALLED}

${NTI_SDL_TTF_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TTF_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-SDL_ttf
nti-SDL_ttf: nti-libtool nti-SDL_ttf-installed

NTARGETS+= nti-SDL_ttf

endif	# HAVE_SDL_TTF_CONFIG
