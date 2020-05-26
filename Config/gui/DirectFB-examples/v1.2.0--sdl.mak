# DirectFB-examples v1.2.0	[ EARLIEST v1.7.0, c.2014-05-28 ]
# last mod WmT, 2018-02-05	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_DIRECTFB_EXAMPLES_CONFIG},y)
HAVE_DIRECTFB_EXAMPLES_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-DirectFB-examples' -- DirectFB"

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak


ifeq (${DIRECTFB_EXAMPLES_VERSION},)
DIRECTFB_EXAMPLES_VERSION=1.2.0
#DIRECTFB_EXAMPLES_VERSION=1.5.2
#DIRECTFB_EXAMPLES_VERSION=1.5.3
#DIRECTFB_EXAMPLES_VERSION=1.6.0
#DIRECTFB_EXAMPLES_VERSION=1.7.0
endif

DIRECTFB_EXAMPLES_SRC=${SOURCES}/d/DirectFB-examples-${DIRECTFB_EXAMPLES_VERSION}.tar.gz
#URLS+= http://www.directfb.net/downloads/Extras/DirectFB-examples-${DIRECTFB_EXAMPLES_VERSION}.tar.gz
URLS+= http://sources.buildroot.net/DirectFB-examples-1.2.0.tar.gz

#include ${CFG_ROOT}/gui/DirectFB/v1.2.10.mak
include ${CFG_ROOT}/gui/DirectFB/v1.2.10--sdl.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.6.3.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.6.3--sdl.mak
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_DIRECTFB_EXAMPLES_TEMP=nti-DirectFB-examples-${DIRECTFB_EXAMPLES_VERSION}

NTI_DIRECTFB_EXAMPLES_EXTRACTED=${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP}/configure
NTI_DIRECTFB_EXAMPLES_CONFIGURED=${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP}/config.log
NTI_DIRECTFB_EXAMPLES_BUILT=${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP}/src/ve_test
NTI_DIRECTFB_EXAMPLES_INSTALLED=${NTI_TC_ROOT}/usr/bin/df_dioload


## ,-----
## |	Extract
## +-----

${NTI_DIRECTFB_EXAMPLES_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/DIRECTFB_EXAMPLES-${DIRECTFB_EXAMPLES_VERSION} ] || rm -rf ${EXTTEMP}/DIRECTFB-${DIRECTFB_EXAMPLES_VERSION}
	zcat ${DIRECTFB_EXAMPLES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP}
	mv ${EXTTEMP}/DirectFB-examples-${DIRECTFB_EXAMPLES_VERSION} ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP}


## ,-----
## |	Configure
## +-----

## don't build df_stereo3d; a DirectFB 1.5.3 API is required (this test fails)
## hbOS: need CFLAGS/LDFLAGS to locate libz?

${NTI_DIRECTFB_EXAMPLES_CONFIGURED}: ${NTI_DIRECTFB_EXAMPLES_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 ;\
		case ${DIRECTFB_EXAMPLES_VERSION} in \
		1.5.3|1.6.0) \
			[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
			cat src/Makefile.OLD \
				| sed '/^bin_PROGRAMS/,/[^\]$$/	s/df_stereo3d[^ ]* //' \
				> src/Makefile \
		;; \
		esac \
	)

#		  ZLIB_LIBS=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs-only-l zlib ` \


## ,-----
## |	Build
## +-----

${NTI_DIRECTFB_EXAMPLES_BUILT}: ${NTI_DIRECTFB_EXAMPLES_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_DIRECTFB_EXAMPLES_INSTALLED}: ${NTI_DIRECTFB_EXAMPLES_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_EXAMPLES_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-DirectFB-examples
nti-DirectFB-examples: nti-libtool nti-pkg-config \
	nti-DirectFB ${NTI_DIRECTFB_EXAMPLES_INSTALLED}
#nti-DirectFB-examples: nti-libtool nti-pkg-config nti-DirectFB nti-zlib ${NTI_DIRECTFB_EXAMPLES_INSTALLED}

ALL_NTI_TARGETS+= nti-DirectFB-examples

endif	# HAVE_DIRECTFB_EXAMPLES_CONFIG
