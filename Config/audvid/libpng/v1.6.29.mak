# libpng v1.6.29		[ since v1.2.5, c.2003-08-14 ]
# last mod WmT, 2017-04-18	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBPNG_CONFIG},y)
HAVE_LIBPNG_CONFIG:=y

#DESCRLIST+= "'nti-libpng' -- libpng"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBPNG_VERSION},)
#LIBPNG_VERSION=1.2.33
#LIBPNG_VERSION=1.5.14
#LIBPNG_VERSION=1.6.10
#LIBPNG_VERSION=1.6.16
#LIBPNG_VERSION=1.6.21
#LIBPNG_VERSION=1.6.22
#LIBPNG_VERSION=1.6.23
#LIBPNG_VERSION=1.6.28
LIBPNG_VERSION=1.6.29
endif

#LIBPNG_SRC=${SOURCES}/l/libpng-${LIBPNG_VERSION}.tar.bz2
LIBPNG_SRC=${SOURCES}/l/libpng-${LIBPNG_VERSION}.tar.gz

URLS+= ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-${LIBPNG_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/libpng/libpng16/1.6.10/libpng-1.6.10.tar.gz?use_mirror=garr


include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_LIBPNG_TEMP=nti-libpng-${LIBPNG_VERSION}

NTI_LIBPNG_EXTRACTED=${EXTTEMP}/${NTI_LIBPNG_TEMP}/README
NTI_LIBPNG_CONFIGURED=${EXTTEMP}/${NTI_LIBPNG_TEMP}/config.log
NTI_LIBPNG_BUILT=${EXTTEMP}/${NTI_LIBPNG_TEMP}/libpng.vers
NTI_LIBPNG_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libpng.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBPNG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libpng-${LIBPNG_VERSION} ] || rm -rf ${EXTTEMP}/libpng-${LIBPNG_VERSION}
	zcat ${LIBPNG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPNG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPNG_TEMP}
	mv ${EXTTEMP}/libpng-${LIBPNG_VERSION} ${EXTTEMP}/${NTI_LIBPNG_TEMP}


## ,-----
## |	Configure
## +-----

## /!\ --with-zlib-prefix is NOT the installation path!

${NTI_LIBPNG_CONFIGURED}: ${NTI_LIBPNG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPNG_TEMP} || exit 1 ;\
		LIBTOOL=${HOSTSPEC}-libtool \
		CPPFLAGS=`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags zlib` \
		LDFLAGS=`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs-only-L zlib` \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			--disable-shared \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBPNG_BUILT}: ${NTI_LIBPNG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPNG_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBPNG_INSTALLED}: ${NTI_LIBPNG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPNG_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-libpng
nti-libpng: nti-zlib nti-pkg-config nti-libtool ${NTI_LIBPNG_INSTALLED}

ALL_NTI_TARGETS+= nti-libpng

endif	# HAVE_LIBPNG_CONFIG
