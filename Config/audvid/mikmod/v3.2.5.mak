# mikmod v3.2.5			[ EARLIEST v3.1.6, c.2012-09-04? ]
# last mod WmT, 2014-06-21	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_MIKMOD_CONFIG},y)
HAVE_MIKMOD_CONFIG:=y

#DESCRLIST+= "'nti-mikmod' -- mikmod"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MIKMOD_VERSION},)
#MIKMOD_VERSION=3.1.6
#MIKMOD_VERSION=3.2.2
MIKMOD_VERSION=3.2.5
endif

MIKMOD_SRC=${SOURCES}/m/mikmod-${MIKMOD_VERSION}.tar.gz
#URLS+= http://mikmod.shlomifish.org/files/mikmod-${MIKMOD_VERSION}.tar.gz
URLS+= 'http://sourceforge.net/project/downloading.php?group_id=40531&filename=mikmod-3.2.5.tar.gz'

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak
include ${CFG_ROOT}/audvid/libmikmod/v3.3.6.mak


NTI_MIKMOD_TEMP=nti-mikmod-${MIKMOD_VERSION}

NTI_MIKMOD_EXTRACTED=${EXTTEMP}/${NTI_MIKMOD_TEMP}/configure
NTI_MIKMOD_CONFIGURED=${EXTTEMP}/${NTI_MIKMOD_TEMP}/Makefile
NTI_MIKMOD_BUILT=${EXTTEMP}/${NTI_MIKMOD_TEMP}/src/mikmod
NTI_MIKMOD_INSTALLED=${NTI_TC_ROOT}/usr/bin/mikmod


## ,-----
## |	Extract
## +-----

${NTI_MIKMOD_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/mikmod-${MIKMOD_VERSION} ] || rm -rf ${EXTTEMP}/mikmod-${MIKMOD_VERSION}
	zcat ${MIKMOD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MIKMOD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MIKMOD_TEMP}
	mv ${EXTTEMP}/mikmod-${MIKMOD_VERSION} ${EXTTEMP}/${NTI_MIKMOD_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MIKMOD_CONFIGURED}: ${NTI_MIKMOD_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MIKMOD_TEMP} || exit 1 ;\
	  CFLAGS='-O2 '"` ${NCURSES_CONFIG_TOOL} --cflags `" \
	  LDFLAGS="` ${NCURSES_CONFIG_TOOL} --libs `" \
		LIBTOOL=${HOSTSPEC}-libtool \
		LD_LIBRARY_PATH=${NTI_TC_ROOT}/usr/lib \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-libmikmod-prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#	  CFLAGS='-O2 '` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags ncurses ` \
#	  LDFLAGS=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs ncurses ` \


## ,-----
## |	Build
## +-----

${NTI_MIKMOD_BUILT}: ${NTI_MIKMOD_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MIKMOD_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_MIKMOD_INSTALLED}: ${NTI_MIKMOD_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MIKMOD_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-mikmod
nti-mikmod: nti-libtool nti-pkg-config \
	nti-libmikmod nti-ncurses ${NTI_MIKMOD_INSTALLED}

ALL_NTI_TARGETS+= nti-mikmod

endif	# HAVE_MIKMOD_CONFIG
