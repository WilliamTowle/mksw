# vitetris v0.57		[ since v0.57, c. 2014-11-18 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_VITETRIS_CONFIG},y)
HAVE_VITETRIS_CONFIG:=y

#DESCRLIST+= "'nti-vitetris' -- vitetris"
#DESCRLIST+= "'cti-vitetris' -- vitetris"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${VITETRIS_VERSION},)
VITETRIS_VERSION=0.57
endif

VITETRIS_SRC=${SOURCES}/v/vitetris-${VITETRIS_VERSION}.tar.gz
URLS+= http://www.victornils.net/tetris/vitetris-0.57.tar.gz

NTI_VITETRIS_TEMP=nti-vitetris-${VITETRIS_VERSION}

NTI_VITETRIS_EXTRACTED=${EXTTEMP}/${NTI_VITETRIS_TEMP}/configure
NTI_VITETRIS_CONFIGURED=${EXTTEMP}/${NTI_VITETRIS_TEMP}/Makefile
NTI_VITETRIS_BUILT=${EXTTEMP}/${NTI_VITETRIS_TEMP}/tetris
NTI_VITETRIS_INSTALLED=${NTI_TC_ROOT}/usr/bin/tetris


## ,-----
## |	Extract
## +-----

${NTI_VITETRIS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/vitetris-${VITETRIS_VERSION} ] || rm -rf ${EXTTEMP}/vitetris-${VITETRIS_VERSION}
	#[ ! -d ${EXTTEMP}/vitetris ] || rm -rf ${EXTTEMP}/vitetris
	zcat ${VITETRIS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VITETRIS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VITETRIS_TEMP}
	mv ${EXTTEMP}/vitetris-${VITETRIS_VERSION} ${EXTTEMP}/${NTI_VITETRIS_TEMP}
	#mv ${EXTTEMP}/vitetris ${EXTTEMP}/${NTI_VITETRIS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VITETRIS_CONFIGURED}: ${NTI_VITETRIS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_VITETRIS_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INSTALL/	s/-[og]root//g' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_VITETRIS_BUILT}: ${NTI_VITETRIS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_VITETRIS_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_VITETRIS_INSTALLED}: ${NTI_VITETRIS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_VITETRIS_TEMP} || exit 1 ;\
		make install \
			LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)

.PHONY: nti-vitetris
nti-vitetris: nti-libtool nti-pkg-config \
	nti-ncurses ${NTI_VITETRIS_INSTALLED}

ALL_NTI_TARGETS+= nti-vitetris

endif	# HAVE_VITETRIS_CONFIG
