# drtux v0.1			[ EARLIEST v0.1 c.2003-01-18 ]
# last mod WmT, 2013-01-18	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_DRTUX_CONFIG},y)
HAVE_DRTUX_CONFIG:=y

#DESCRLIST+= "'nti-drtux' -- drtux"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${DRTUX_VERSION},)
DRTUX_VERSION=0.1
endif

DRTUX_SRC=${SOURCES}/d/drtux-${DRTUX_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/drtux/drtux-source/0.1/drtux-0.1.tar.gz?r=&ts=1358433176&use_mirror=ignum'

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
## TODO: wants 'SDL/SDL_gui.h' (http://sourceforge.net/projects/sdl-gui/)
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak


NTI_DRTUX_TEMP=nti-drtux-${DRTUX_VERSION}

NTI_DRTUX_EXTRACTED=${EXTTEMP}/${NTI_DRTUX_TEMP}/configure
NTI_DRTUX_CONFIGURED=${EXTTEMP}/${NTI_DRTUX_TEMP}/Makefile.OLD
NTI_DRTUX_BUILT=${EXTTEMP}/${NTI_DRTUX_TEMP}/drtux
NTI_DRTUX_INSTALLED=${NTI_TC_ROOT}/usr/bin/drtux


## ,-----
## |	Extract
## +-----

${NTI_DRTUX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/drtux-${DRTUX_VERSION} ] || rm -rf ${EXTTEMP}/drtux-${DRTUX_VERSION}
	zcat ${DRTUX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DRTUX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DRTUX_TEMP}
	mv ${EXTTEMP}/drtux-${DRTUX_VERSION} ${EXTTEMP}/${NTI_DRTUX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DRTUX_CONFIGURED}: ${NTI_DRTUX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DRTUX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s/^/CC=gcc\n/' \
			| sed '/^CFLAGS/	s%$$% -I'${NTI_TC_ROOT}'/usr/include%' \
			> Makefile ;\
	)


## ,-----
## |	Build
## +-----

${NTI_DRTUX_BUILT}: ${NTI_DRTUX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DRTUX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DRTUX_INSTALLED}: ${NTI_DRTUX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DRTUX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-drtux
nti-drtux: nti-SDL ${NTI_DRTUX_INSTALLED}
#nti-drtux: nti-libogg nti-libvorbis nti-SDL nti-SDL_mixer ${NTI_DRTUX_INSTALLED}

ALL_NTI_TARGETS+= nti-drtux

endif	# HAVE_DRTUX_CONFIG
