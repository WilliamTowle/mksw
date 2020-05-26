# libmcrypt v2.6.8 	      	[ since v2.6.8, c.2011-08-18 ]
# last mod WmT, 2017-04-11	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBMCRYPT},y)
HAVE_LIBMCRYPT:=y

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak

ifeq (${LIBMCRYPT_VERSION},)
LIBMCRYPT_VERSION=2.5.8
endif

LIBMCRYPT_SRC=${SOURCES}/l/libmcrypt-${LIBMCRYPT_VERSION}.tar.gz
URLS+= https://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz/download

# deps?
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_LIBMCRYPT_TEMP=nti-libmcrypt-${LIBMCRYPT_VERSION}

NTI_LIBMCRYPT_EXTRACTED=${EXTTEMP}/${NTI_LIBMCRYPT_TEMP}/configure
NTI_LIBMCRYPT_CONFIGURED=${EXTTEMP}/${NTI_LIBMCRYPT_TEMP}/Makefile
NTI_LIBMCRYPT_BUILT=${EXTTEMP}/${NTI_LIBMCRYPT_TEMP}/lib/libmcrypt.la
NTI_LIBMCRYPT_INSTALLED=${NTI_TC_ROOT}/usr/bin/libmcrypt-config

# Helpers for external use (post-installation)
NTI_LIBMCRYPT_CONFIG_TOOL= ${NTI_LIBMCRYPT_INSTALLED}


## ,-----
## |	Extract
## +-----

${NTI_LIBMCRYPT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libmcrypt-${LIBMCRYPT_VERSION} ] || rm -rf ${EXTTEMP}/libmcrypt-${LIBMCRYPT_VERSION}
	zcat ${LIBMCRYPT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP}
	mv ${EXTTEMP}/libmcrypt-${LIBMCRYPT_VERSION} ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBMCRYPT_CONFIGURED}: ${NTI_LIBMCRYPT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-static \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBMCRYPT_BUILT}: ${NTI_LIBMCRYPT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP} || exit 1 ;\
		make \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBMCRYPT_INSTALLED}: ${NTI_LIBMCRYPT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMCRYPT_TEMP} || exit 1 ;\
		make install \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
	)


.PHONY: nti-libmcrypt
nti-libmcrypt: nti-libtool \
	${NTI_LIBMCRYPT_INSTALLED}

ALL_NTI_TARGETS+= nti-libmcrypt

endif	# HAVE_LIBMCRYPT_CONFIG
