# sidplay v1.36.29		[ EARLIEST v1.36.29, c.2014-04-20 ]
# last mod WmT, 2017-04-20	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SIDPLAY_CONFIG},y)
HAVE_SIDPLAY_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SIDPLAY_VERSION},)
SIDPLAY_VERSION=1.36.29
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


SIDPLAY_SRC=${SOURCES}/s/sidplay-${SIDPLAY_VERSION}.tar.gz
URLS+= ftp://ftp.ibiblio.org/pub/Linux/apps/sound/players/sidplay-1.36.29.tar.gz


##include ${CFG_ROOT}/tui/ncurses/v5.9.mak
#include ${CFG_ROOT}/tui/ncurses/v6.0.mak


NTI_SIDPLAY_TEMP=nti-sidplay-${SIDPLAY_VERSION}

NTI_SIDPLAY_EXTRACTED=${EXTTEMP}/${NTI_SIDPLAY_TEMP}/COPYING
NTI_SIDPLAY_CONFIGURED=${EXTTEMP}/${NTI_SIDPLAY_TEMP}/Makefile
NTI_SIDPLAY_BUILT=${EXTTEMP}/${NTI_SIDPLAY_TEMP}/sidplay
NTI_SIDPLAY_INSTALLED=${NTI_TC_ROOT}/usr/bin/sidplay


## ,-----
## |	Extract
## +-----

${NTI_SIDPLAY_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/sidplay-${SIDPLAY_VERSION} ] || rm -rf ${EXTTEMP}/sidplay-${SIDPLAY_VERSION}
	zcat ${SIDPLAY_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SIDPLAY_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SIDPLAY_TEMP}
	mv ${EXTTEMP}/sidplay-${SIDPLAY_VERSION} ${EXTTEMP}/${NTI_SIDPLAY_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SIDPLAY_CONFIGURED}: ${NTI_SIDPLAY_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SIDPLAY_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)


## ,-----
## |	Build
## +-----

${NTI_SIDPLAY_BUILT}: ${NTI_SIDPLAY_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SIDPLAY_TEMP} || exit 1 ;\
		make sidplay \
	)


## ,-----
## |	Install
## +-----

${NTI_SIDPLAY_INSTALLED}: ${NTI_SIDPLAY_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SIDPLAY_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-sidplay
#nti-sidplay: nti-ncurses ${NTI_SIDPLAY_INSTALLED}
nti-sidplay: ${NTI_SIDPLAY_INSTALLED}

ALL_NTI_TARGETS+= nti-sidplay

endif	# HAVE_SIDPLAY_CONFIG
