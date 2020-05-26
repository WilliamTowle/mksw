# directvnc v0.7.8		[ EARLIEST v0.7.8, 2014-03-15 ]
# last mod WmT, 2018-02-06	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_DIRECTVNC_CONFIG},y)
HAVE_DIRECTVNC_CONFIG:=y

#DESCRLIST+= "'nti-directvnc' -- directvnc"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DIRECTVNC_VERSION},)
DIRECTVNC_VERSION=0.7.8
endif

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.8.5.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

DIRECTVNC_SRC=${SOURCES}/d/directvnc-0.7.8.tar.gz
URLS+= https://github.com/downloads/drinkmilk/directvnc/directvnc-0.7.8.tar.gz

#include ${CFG_ROOT}/gui/DirectFB/v1.3.1.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.4.17.mak
include ${CFG_ROOT}/gui/DirectFB/v1.6.3.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.6.3--sdl.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.7.7.mak
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_DIRECTVNC_TEMP=nti-directvnc-${DIRECTVNC_VERSION}

NTI_DIRECTVNC_EXTRACTED=${EXTTEMP}/${NTI_DIRECTVNC_TEMP}/configure
NTI_DIRECTVNC_CONFIGURED=${EXTTEMP}/${NTI_DIRECTVNC_TEMP}/config.status
NTI_DIRECTVNC_BUILT=${EXTTEMP}/${NTI_DIRECTVNC_TEMP}/src/directvnc
NTI_DIRECTVNC_INSTALLED=${NTI_TC_ROOT}/usr/bin/directvnc


## ,-----
## |	Extract
## +-----

${NTI_DIRECTVNC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/directvnc-${DIRECTVNC_VERSION} ] || rm -rf ${EXTTEMP}/directvnc-${DIRECTVNC_VERSION}
	zcat ${DIRECTVNC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIRECTVNC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIRECTVNC_TEMP}
	mv ${EXTTEMP}/directvnc-${DIRECTVNC_VERSION} ${EXTTEMP}/${NTI_DIRECTVNC_TEMP}


## ,-----
## |	Configure
## +-----

## [v0.7.8] Using the svn tarball means no config.{sub|guess}
## [v0.7.8] --x-{includes|libraries} broken; needs CFLAGS/LDFLAGS
## is DSPF_RGB16 (src/dfb.c, dfb_init()) a problem?

${NTI_DIRECTVNC_CONFIGURED}: ${NTI_DIRECTVNC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTVNC_TEMP} || exit 1 ;\
		[ -r config.sub ] || cp ${AUTOMAKE_SHAREDIR}/config.sub config.sub || exit 1 ;\
		[ -r config.guess ] || cp ${AUTOMAKE_SHAREDIR}/config.guess config.guess || exit 1 ;\
		CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		  LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DIRECTVNC_BUILT}: ${NTI_DIRECTVNC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTVNC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DIRECTVNC_INSTALLED}: ${NTI_DIRECTVNC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTVNC_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-directvnc
nti-directvnc:	nti-automake nti-pkg-config \
		nti-jpegsrc nti-DirectFB nti-zlib ${NTI_DIRECTVNC_INSTALLED}
#nti-directvnc: nti-SDL ${NTI_DIRECTVNC_INSTALLED}

ALL_NTI_TARGETS+= nti-directvnc

endif	# HAVE_DIRECTVNC_CONFIG
