# libffi v3.0.13		[ since v3.0.10, c.2013-01-18 ]
# last mod WmT, 2014-05-129	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBFFI},y)
HAVE_LIBFFI:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBFFI_VERSION},)
#LIBFFI_VERSION=3.0.10
LIBFFI_VERSION=3.0.13
endif

LIBFFI_SRC=${SOURCES}/l/libffi-${LIBFFI_VERSION}.tar.gz
URLS+= ftp://sourceware.org/pub/libffi/libffi-${LIBFFI_VERSION}.tar.gz

include ${CFG_ROOT}/ENV/buildtype.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_LIBFFI_TEMP=nti-libffi-${LIBFFI_VERSION}

NTI_LIBFFI_EXTRACTED=${EXTTEMP}/${NTI_LIBFFI_TEMP}/configure
NTI_LIBFFI_CONFIGURED=${EXTTEMP}/${NTI_LIBFFI_TEMP}/Makefile
NTI_LIBFFI_BUILT=${EXTTEMP}/${NTI_LIBFFI_TEMP}/$(shell uname -m)-unknown-linux-gnu/libffi.la
#NTI_LIBFFI_BUILT=${EXTTEMP}/${NTI_LIBFFI_TEMP}/$(shell uname -m)-pc-linux-gnu/libffi.la
NTI_LIBFFI_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libffi.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBFFI_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libffi-${LIBFFI_VERSION} ] || rm -rf ${EXTTEMP}/libffi-${LIBFFI_VERSION}
	zcat ${LIBFFI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBFFI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBFFI_TEMP}
	mv ${EXTTEMP}/libffi-${LIBFFI_VERSION} ${EXTTEMP}/${NTI_LIBFFI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBFFI_CONFIGURED}: ${NTI_LIBFFI_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#		LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Build
## +-----

${NTI_LIBFFI_BUILT}: ${NTI_LIBFFI_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		make all \
	)
#		make all LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBFFI_INSTALLED}: ${NTI_LIBFFI_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/libffi.pc ${NTI_LIBFFI_INSTALLED} \
	)
#		make install-lib LIBTOOL=${HOSTSPEC}-libtool \


##

.PHONY: nti-libffi
nti-libffi: nti-pkg-config ${NTI_LIBFFI_INSTALLED}

ALL_NTI_TARGETS+= nti-libffi

endif	# HAVE_LIBFFI_CONFIG
