# bombic v0.0.1			[ EARLIEST v0.0.1, c.2013-01-21 ]
# last mod WmT, 2013-01-25	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_BOMBIC_CONFIG},y)
HAVE_BOMBIC_CONFIG:=y

#DESCRLIST+= "'nti-bombic' -- bombic"

ifeq (${BOMBIC_VERSION},)
BOMBIC_VERSION=0.0.1
endif

BOMBIC_SRC=${SOURCES}/b/bombic-${BOMBIC_VERSION}-src.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/bombic/bombic/Bombic%200.0.1/bombic-0.0.1-src.tar.gz?r=&ts=1358433034&use_mirror=heanet'

## [2012-09-13] testing: menu has ogg music
#include ${CFG_ROOT}/audvid/libogg/v1.3.2.mak
#include ${CFG_ROOT}/audvid/libvorbis/v1.3.5.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_ttf/v2.0.11.mak
include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak

NTI_BOMBIC_TEMP=nti-bombic-${BOMBIC_VERSION}

NTI_BOMBIC_EXTRACTED=${EXTTEMP}/${NTI_BOMBIC_TEMP}/configure
NTI_BOMBIC_CONFIGURED=${EXTTEMP}/${NTI_BOMBIC_TEMP}/config.log
NTI_BOMBIC_BUILT=${EXTTEMP}/${NTI_BOMBIC_TEMP}/src/bombic
NTI_BOMBIC_INSTALLED=${NTI_TC_ROOT}/usr/bin/bombic


## ,-----
## |	Extract
## +-----

${NTI_BOMBIC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/bombic-${BOMBIC_VERSION} ] || rm -rf ${EXTTEMP}/bombic-${BOMBIC_VERSION}
	zcat ${BOMBIC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BOMBIC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BOMBIC_TEMP}
	mv ${EXTTEMP}/bombic-${BOMBIC_VERSION}-src ${EXTTEMP}/${NTI_BOMBIC_TEMP}
#	mv ${EXTTEMP}/bombic-${BOMBIC_VERSION} ${EXTTEMP}/${NTI_BOMBIC_TEMP}


## ,-----
## |	Configure
## +-----

## Munged for v0.0.1

${NTI_BOMBIC_CONFIGURED}: ${NTI_BOMBIC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_BOMBIC_TEMP} || exit 1 ;\
		[ -r src/Makefile.in.OLD ] || cp src/Makefile.in src/Makefile.in.OLD || exit 1 ;\
		cat src/Makefile.in.OLD \
			| sed '/bombic_LDFLAGS/	s/$$/ -lSDL_mixer -lSDL_ttf/' \
			> src/Makefile.in ;\
	  CFLAGS='-O2' \
		  SDL_CONFIG=${SDL_CONFIG_TOOL} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BOMBIC_BUILT}: ${NTI_BOMBIC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_BOMBIC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BOMBIC_INSTALLED}: ${NTI_BOMBIC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_BOMBIC_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-bombic
nti-bombic: nti-SDL nti-SDL_image nti-SDL_mixer nti-SDL_ttf \
	nti-libgl-mesa \
	${NTI_BOMBIC_INSTALLED}

ALL_NTI_TARGETS+= nti-bombic

endif	# HAVE_BOMBIC_CONFIG
