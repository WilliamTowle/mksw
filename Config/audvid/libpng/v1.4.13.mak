# libpng v1.4.13		[ since v1.2.5, c.2003-08-14 ]
# last mod WmT, 2013-06-30	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBPNG_CONFIG},y)
HAVE_LIBPNG_CONFIG:=y

#DESCRLIST+= "'nti-libpng' -- libpng"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBPNG_VERSION},)
#LIBPNG_VERSION=1.2.33
#LIBPNG_VERSION=1.4.12
LIBPNG_VERSION=1.4.13
endif

LIBPNG_SRC=${SOURCES}/l/libpng-${LIBPNG_VERSION}.tar.bz2

URLS+= ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-${LIBPNG_VERSION}.tar.bz2

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
	bzcat ${LIBPNG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPNG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPNG_TEMP}
	mv ${EXTTEMP}/libpng-${LIBPNG_VERSION} ${EXTTEMP}/${NTI_LIBPNG_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBPNG_CONFIGURED}: ${NTI_LIBPNG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPNG_TEMP} || exit 1 ;\
		CPPFLAGS='-I${NTI_TC_ROOT}/usr/include' \
		LDFLAGS='-L${NTI_TC_ROOT}/usr/lib' \
		LIBTOOL=${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
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
