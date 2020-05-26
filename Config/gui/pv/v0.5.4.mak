# pv v0.5.4			[ since v0.5.4, c.2011-08-31 ]
# last mod WmT, 2014-07-02	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_PV_CONFIG},y)
HAVE_PV_CONFIG:=y

# DESCRLIST+= "'nti-pv' -- host-toolchain pv"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PV_VERSION},)
PV_VERSION=0.5.4
endif

PV_SRC=${SOURCES}/p/pv-${PV_VERSION}.tar.bz2
URLS+= http://www.trashmail.net/pv/download/pv-${PV_VERSION}.tar.bz2

##

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/audvid/libpng/v1.2.51.mak
#include ${CFG_ROOT}/audvid/libpng/v1.4.13.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL/v2.0.3.mak
include ${CFG_ROOT}/gui/SDL_gfx/v2.0.25.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_ttf/v2.0.11.mak

NTI_PV_TEMP=nti-pv-${PV_VERSION}

NTI_PV_EXTRACTED=${EXTTEMP}/${NTI_PV_TEMP}/configure
NTI_PV_CONFIGURED=${EXTTEMP}/${NTI_PV_TEMP}/config.log
NTI_PV_BUILT=${EXTTEMP}/${NTI_PV_TEMP}/src/pv
NTI_PV_INSTALLED=${NTI_TC_ROOT}/usr/bin/pv



## ,-----
## |	Extract
## +-----

${NTI_PV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pv ] || rm -rf ${EXTTEMP}/pv
	#[ ! -d ${EXTTEMP}/pv-${PV_VERSION} ] || rm -rf ${EXTTEMP}/pv-${PV_VERSION}
	bzcat ${PV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PV_TEMP}
	mv ${EXTTEMP}/pv ${EXTTEMP}/${NTI_PV_TEMP}
	#mv ${EXTTEMP}/pv-${PV_VERSION} ${EXTTEMP}/${NTI_PV_TEMP}


## ,-----
## |	Configure
## +-----

## [v0.5.4] src/Makefile insists on using arbitrary {libpng|sdl}-config

${NTI_PV_CONFIGURED}: ${NTI_PV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PV_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			--without-x \
			|| exit 1 ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD ;\
		cat src/Makefile.OLD \
			| sed '/sdl-config --/		s/sdl-config/$$(SDL_CONFIG)/' \
			| sed '/libpng-config --/	s%libpng-config%'${NTI_TC_ROOT}'/usr/bin/libpng-config%' \
			> src/Makefile \
	)
# ... insufficient to fix X{Open|Close}Display() link errors: (...?!)
#	LDFLAGS='-lX11' \
#			--x-includes=${NTI_TC_ROOT}/usr/include \
#			--x-libraries=${NTI_TC_ROOT}/usr/lib \


## ,-----
## |	Build
## +-----

${NTI_PV_BUILT}: ${NTI_PV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PV_INSTALLED}: ${NTI_PV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PV_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-pv
nti-pv: \
	 nti-libpng nti-SDL nti-SDL_gfx nti-SDL_image nti-SDL_ttf ${NTI_PV_INSTALLED}

ALL_NTI_TARGETS+= nti-pv

endif	# HAVE_PV_CONFIG
