# LiTE v0.8.10			[ EARLIEST v1.6.3, c.2017-03-27 ]
# last mod WmT, 2017-04-10	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LITE_CONFIG},y)
HAVE_LITE_CONFIG:=y

#DESCRLIST+= "'nti-LiTE' -- LiTE

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak


ifeq (${LITE_VERSION},)
LITE_VERSION=0.8.10
endif

LITE_SRC=${SOURCES}/l/LiTE-${LITE_VERSION}.tar.gz
URLS+= https://web.archive.org/web/20150323105203/http://www.directfb.org/downloads/Libs/LiTE-0.8.10.tar.gz

#include ${CFG_ROOT}/gui/DirectFB/v1.6.3--sdl.mak
include ${CFG_ROOT}/gui/DirectFB/v1.7.6--sdl.mak

NTI_LITE_TEMP=nti-LiTE-${LITE_VERSION}

NTI_LITE_EXTRACTED=${EXTTEMP}/${NTI_LITE_TEMP}/configure
NTI_LITE_CONFIGURED=${EXTTEMP}/${NTI_LITE_TEMP}/config.log
NTI_LITE_BUILT=${EXTTEMP}/${NTI_LITE_TEMP}/lite/liblite.la
NTI_LITE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/lite.pc


## ,-----
## |	Extract
## +-----

${NTI_LITE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/LiTE-${LITE_VERSION} ] || rm -rf ${EXTTEMP}/LiTE-${LITEFB_VERSION}
	zcat ${LITE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LITE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LITE_TEMP}
	mv ${EXTTEMP}/LiTE-${LITE_VERSION} ${EXTTEMP}/${NTI_LITE_TEMP}


## ,-----
## |	Configure
## +-----

## [v0.8.10] don't build examples - dfbspy uses bad variable names

${NTI_LITE_CONFIGURED}: ${NTI_LITE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LITE_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^SUBDIRS/	s/ examples / /' \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
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

${NTI_LITE_BUILT}: ${NTI_LITE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LITE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LITE_INSTALLED}: ${NTI_LITE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LITE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-LiTE
nti-LiTE: nti-pkg-config \
	${NTI_LITE_INSTALLED}

ALL_NTI_TARGETS+= nti-LiTE

endif	# HAVE_LITE_CONFIG
