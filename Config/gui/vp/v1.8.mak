# vp v1.8			[ EARLIEST v1.8, c.2003-01-18 ]
# last mod WmT, 2013-02-14	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_VP_CONFIG},y)
HAVE_VP_CONFIG:=y

#DESCRLIST+= "'nti-vp' -- vp"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${VP_VERSION},)
VP_VERSION=1.8
endif

VP_SRC=${SOURCES}/v/vp-${VP_VERSION}.tar.bz2
URLS+= http://elfga.com/~erik/files/vp-1.8.tar.bz2

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak

NTI_VP_TEMP=nti-vp-${VP_VERSION}

NTI_VP_EXTRACTED=${EXTTEMP}/${NTI_VP_TEMP}/configure
NTI_VP_CONFIGURED=${EXTTEMP}/${NTI_VP_TEMP}/config.log
NTI_VP_BUILT=${EXTTEMP}/${NTI_VP_TEMP}/src/vp
NTI_VP_INSTALLED=${NTI_TC_ROOT}/usr/bin/vp


## ,-----
## |	Extract
## +-----

${NTI_VP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/vp-${VP_VERSION} ] || rm -rf ${EXTTEMP}/vp-${VP_VERSION}
	bzcat ${VP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VP_TEMP}
	mv ${EXTTEMP}/vp-${VP_VERSION} ${EXTTEMP}/${NTI_VP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VP_CONFIGURED}: ${NTI_VP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VP_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_VP_BUILT}: ${NTI_VP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VP_INSTALLED}: ${NTI_VP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-vp
nti-vp: ${NTI_VP_INSTALLED}
#nti-vp: nti-libogg nti-libvorbis nti-SDL nti-SDL_mixer ${NTI_VP_INSTALLED}

ALL_NTI_TARGETS+= nti-vp

endif	# HAVE_VP_CONFIG
