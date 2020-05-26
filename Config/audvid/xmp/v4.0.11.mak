## xmp v4.0.11			[ since v3.2.0, c.2010-06-01 ]
## last mod WmT, 2016-04-19	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_XMP_CONFIG},y)
HAVE_XMP_CONFIG:=y

#DESCRLIST+= "'nti-xmp' -- xmp"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XMP_VERSION},)
#XMP_VERSION=3.2.0
#XMP_VERSION=4.0.10
XMP_VERSION=4.0.11
endif

XMP_SRC=${SOURCES}/x/xmp-${XMP_VERSION}.tar.gz
#URLS+= http://sourceforge.net/projects/xmp/files/xmp/4.0.10/xmp-4.0.10.tar.gz/download
URLS+= 'http://downloads.sourceforge.net/project/xmp/xmp/${XMP_VERSION}/xmp-${XMP_VERSION}.tar.gz'

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/audvid/libxmp/v4.3.6.mak
include ${CFG_ROOT}/audvid/libxmp/v4.3.13.mak

NTI_XMP_TEMP=nti-xmp-${XMP_VERSION}

NTI_XMP_EXTRACTED=${EXTTEMP}/${NTI_XMP_TEMP}/Makefile
NTI_XMP_CONFIGURED=${EXTTEMP}/${NTI_XMP_TEMP}/config.log
NTI_XMP_BUILT=${EXTTEMP}/${NTI_XMP_TEMP}/src/xmp
NTI_XMP_INSTALLED=${NTI_TC_ROOT}/usr/bin/xmp


## ,-----
## |	Extract
## +-----

${NTI_XMP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/xmp-${XMP_VERSION} ] || rm -rf ${EXTTEMP}/xmp-${XMP_VERSION}
	zcat ${XMP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XMP_TEMP}
	mv ${EXTTEMP}/xmp-${XMP_VERSION} ${EXTTEMP}/${NTI_XMP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XMP_CONFIGURED}: ${NTI_XMP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XMP_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		LDFLAGS="` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs-only-L libxmp `" \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
# [2015-03-26] config.log "/usr/bin/ld: cannot find -lxmp"
#		CFLAGS="` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags libxmp `" \
#		LIBS="` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs libxmp `" \


## ,-----
## |	Build
## +-----

${NTI_XMP_BUILT}: ${NTI_XMP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XMP_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_XMP_INSTALLED}: ${NTI_XMP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_XMP_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-xmp
nti-xmp: nti-pkg-config \
	nti-libxmp ${NTI_XMP_INSTALLED}

ALL_NTI_TARGETS+= nti-xmp

endif	# HAVE_XMP_CONFIG
