# DFBTerm v0.8.15		[ EARLIEST v0.8.15, c.2017-04-04 ]
# last mod WmT, 2017-04-11	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DFBTERM_CONFIG},y)
HAVE_DFBTERM_CONFIG:=y

#DESCRLIST+= "'nti-DFBTerm' -- DFBTerm

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak


ifeq (${DFBTERM_VERSION},)
DFBTERM_VERSION=0.8.15
endif

DFBTERM_SRC=${SOURCES}/d/DFBTerm-${DFBTERM_VERSION}.tar.gz
URLS+= http://www.directfb.net/downloads/Programs/DFBTerm-${DFBTERM_VERSION}.tar.gz

#include ${CFG_ROOT}/gui/DirectFB/v1.6.3--sdl.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.7.6--sdl.mak
include ${CFG_ROOT}/gui/DirectFB/v1.7.6--nofb.mak
include ${CFG_ROOT}/gui/LiTE/v0.8.10.mak

NTI_DFBTERM_TEMP=nti-DFBTerm-${DFBTERM_VERSION}

NTI_DFBTERM_EXTRACTED=${EXTTEMP}/${NTI_DFBTERM_TEMP}/configure
NTI_DFBTERM_CONFIGURED=${EXTTEMP}/${NTI_DFBTERM_TEMP}/config.log
NTI_DFBTERM_BUILT=${EXTTEMP}/${NTI_DFBTERM_TEMP}/src/dfbterm
NTI_DFBTERM_INSTALLED=${NTI_TC_ROOT}/usr/bin/dfbterm


## ,-----
## |	Extract
## +-----

${NTI_DFBTERM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/DFBTerm-${DFBTERM_VERSION} ] || rm -rf ${EXTTEMP}/DFBTerm-${DFBTERMFB_VERSION}
	zcat ${DFBTERM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DFBTERM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DFBTERM_TEMP}
	mv ${EXTTEMP}/DFBTerm-${DFBTERM_VERSION} ${EXTTEMP}/${NTI_DFBTERM_TEMP}


## ,-----
## |	Configure
## +-----

## df_stereo3d requires DFBTerm(not dependency-checked)
## hbOS: 'configure' reports "libz not found" despite ZLIB_LIBS setting?
## [v1.7.0] doesn't '--disable-zlib'

${NTI_DFBTERM_CONFIGURED}: ${NTI_DFBTERM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DFBTERM_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DFBTERM_BUILT}: ${NTI_DFBTERM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DFBTERM_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_DFBTERM_INSTALLED}: ${NTI_DFBTERM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DFBTERM_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-DFBTerm
nti-DFBTerm: nti-libtool nti-pkg-config \
	nti-LiTE ${NTI_DFBTERM_INSTALLED}

ALL_NTI_TARGETS+= nti-DFBTerm

endif	# HAVE_DFBTERM_CONFIG
