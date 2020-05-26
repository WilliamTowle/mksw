# SDLSasteroids v3.0.1		[ EARLIEST v3.0.1, c.2013-01-21 ]
# last mod WmT, 2013-01-21	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_SDLSASTEROIDS_CONFIG},y)
HAVE_SDLSASTEROIDS_CONFIG:=y

#DESCRLIST+= "'nti-SDLSasteroids' -- SDLSasteroids"

## [2012-09-13] testing: menu has ogg music
#include ${CFG_ROOT}/audvid/libogg/v1.3.0.mak
#include ${CFG_ROOT}/audvid/libvorbis/v1.3.3.mak

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak

ifeq (${SDLSASTEROIDS_VERSION},)
SDLSASTEROIDS_VERSION=3.0.1
endif

SDLSASTEROIDS_SRC=${SOURCES}/s/SDLSasteroids-${SDLSASTEROIDS_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/sdlsas/SDL%20Sasteroids%20Source%20Releases/3.0.1/SDLSasteroids-3.0.1.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fsdlsas%2F&ts=1483712781&use_mirror=svwh'

NTI_SDLSASTEROIDS_TEMP=nti-SDLSasteroids-${SDLSASTEROIDS_VERSION}

NTI_SDLSASTEROIDS_EXTRACTED=${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP}/sasteroids.6
NTI_SDLSASTEROIDS_CONFIGURED=${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP}/Makefile.OLD
NTI_SDLSASTEROIDS_BUILT=${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP}/src/sasteroids
NTI_SDLSASTEROIDS_INSTALLED=${NTI_TC_ROOT}/usr/bin/sasteroids


## ,-----
## |	Extract
## +-----

${NTI_SDLSASTEROIDS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDLSasteroids-${SDLSASTEROIDS_VERSION} ] || rm -rf ${EXTTEMP}/SDLSasteroids-${SDLSASTEROIDS_VERSION}
	zcat ${SDLSASTEROIDS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP}
	mv ${EXTTEMP}/SDLSasteroids-${SDLSASTEROIDS_VERSION} ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDLSASTEROIDS_CONFIGURED}: ${NTI_SDLSASTEROIDS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^[A-Z]*DIR/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDLSASTEROIDS_BUILT}: ${NTI_SDLSASTEROIDS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SDLSASTEROIDS_INSTALLED}: ${NTI_SDLSASTEROIDS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLSASTEROIDS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-SDLSasteroids
nti-SDLSasteroids: nti-SDL ${NTI_SDLSASTEROIDS_INSTALLED}

ALL_NTI_TARGETS+= nti-SDLSasteroids

endif	# HAVE_SDLSASTEROIDS_CONFIG
