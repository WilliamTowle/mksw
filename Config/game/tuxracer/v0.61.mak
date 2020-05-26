# tuxracer v0.61		[ EARLIEST v0.61, 2014-03-12 ]
# last mod WmT, 2013-04-12	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_TUXRACER_CONFIG},y)
HAVE_TUXRACER_CONFIG:=y

#DESCRLIST+= "'nti-tuxracer' -- tuxracer"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TUXRACER_VERSION},)
TUXRACER_VERSION=0.61
endif

TUXRACER_SRC=${SOURCES}/t/tuxracer-${TUXRACER_VERSION}.tar.gz
URLS+= http://download.sourceforge.net/tuxracer/tuxracer-0.61.tar.gz
#	http://download.sourceforge.net/tuxracer/tuxracer-data-0.61.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak

NTI_TUXRACER_TEMP=nti-tuxracer-${TUXRACER_VERSION}

NTI_TUXRACER_EXTRACTED=${EXTTEMP}/${NTI_TUXRACER_TEMP}/configure
NTI_TUXRACER_CONFIGURED=${EXTTEMP}/${NTI_TUXRACER_TEMP}/config.log
NTI_TUXRACER_BUILT=${EXTTEMP}/${NTI_TUXRACER_TEMP}/src/tuxracer
NTI_TUXRACER_INSTALLED=${NTI_TC_ROOT}/usr/bin/tuxracer


## ,-----
## |	Extract
## +-----

${NTI_TUXRACER_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tuxracer-${TUXRACER_VERSION} ] || rm -rf ${EXTTEMP}/tuxracer-${TUXRACER_VERSION}
	zcat ${TUXRACER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TUXRACER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TUXRACER_TEMP}
	mv ${EXTTEMP}/tuxracer-${TUXRACER_VERSION} ${EXTTEMP}/${NTI_TUXRACER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TUXRACER_CONFIGURED}: ${NTI_TUXRACER_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TUXRACER_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		sed 's/$$//' configure.OLD > configure ;\
		chmod a+x configure ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_TUXRACER_BUILT}: ${NTI_TUXRACER_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TUXRACER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TUXRACER_INSTALLED}: ${NTI_TUXRACER_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TUXRACER_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-tuxracer
nti-tuxracer: nti-SDL ${NTI_TUXRACER_INSTALLED}

ALL_NTI_TARGETS+= nti-tuxracer

endif	# HAVE_TUXRACER_CONFIG
