# libffi v3.2.1			[ since v3.0.10, c.2013-01-18 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBFFI},y)
HAVE_LIBFFI:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/libtool/v2.4.6--arm64.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak

ifeq (${LIBFFI_VERSION},)
#LIBFFI_VERSION=3.0.10
#LIBFFI_VERSION=3.0.13
LIBFFI_VERSION=3.2.1
endif

LIBFFI_SRC=${SOURCES}/l/libffi-${LIBFFI_VERSION}.tar.gz
URLS+= ftp://sourceware.org/pub/libffi/libffi-${LIBFFI_VERSION}.tar.gz

# deps?
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


CTI_LIBFFI_TEMP=cti-libffi-${LIBFFI_VERSION}

CTI_LIBFFI_EXTRACTED=${EXTTEMP}/${CTI_LIBFFI_TEMP}/configure
CTI_LIBFFI_CONFIGURED=${EXTTEMP}/${CTI_LIBFFI_TEMP}/Makefile
CTI_LIBFFI_BUILT=${EXTTEMP}/${CTI_LIBFFI_TEMP}/${TARGSPEC}/libffi.la
#NTI_LIBFFI_BUILT=${EXTTEMP}/${CTI_LIBFFI_TEMP}/$(shell uname -m)-unknown-linux-gnu/libffi.la
#NTI_LIBFFI_BUILT=${EXTTEMP}/${CTI_LIBFFI_TEMP}/$(shell uname -m)-pc-linux-gnu/libffi.la
CTI_LIBFFI_INSTALLED=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/libffi.pc

NTI_LIBFFI_TEMP=nti-libffi-${LIBFFI_VERSION}

NTI_LIBFFI_EXTRACTED=${EXTTEMP}/${NTI_LIBFFI_TEMP}/configure
NTI_LIBFFI_CONFIGURED=${EXTTEMP}/${NTI_LIBFFI_TEMP}/Makefile
#NTI_LIBFFI_BUILT=${EXTTEMP}/${NTI_LIBFFI_TEMP}/${HOSTSPEC}/libffi.la
NTI_LIBFFI_BUILT=${EXTTEMP}/${NTI_LIBFFI_TEMP}/$(shell uname -m)-unknown-linux-gnu/libffi.la
#NTI_LIBFFI_BUILT=${EXTTEMP}/${NTI_LIBFFI_TEMP}/$(shell uname -m)-pc-linux-gnu/libffi.la
NTI_LIBFFI_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libffi.pc


## ,-----
## |	Extract
## +-----

${CTI_LIBFFI_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libffi-${LIBFFI_VERSION} ] || rm -rf ${EXTTEMP}/libffi-${LIBFFI_VERSION}
	zcat ${LIBFFI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_LIBFFI_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBFFI_TEMP}
	mv ${EXTTEMP}/libffi-${LIBFFI_VERSION} ${EXTTEMP}/${CTI_LIBFFI_TEMP}

##

${NTI_LIBFFI_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libffi-${LIBFFI_VERSION} ] || rm -rf ${EXTTEMP}/libffi-${LIBFFI_VERSION}
	zcat ${LIBFFI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBFFI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBFFI_TEMP}
	mv ${EXTTEMP}/libffi-${LIBFFI_VERSION} ${EXTTEMP}/${NTI_LIBFFI_TEMP}


## ,-----
## |	Configure
## +-----

${CTI_LIBFFI_CONFIGURED}: ${CTI_LIBFFI_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBFFI_TEMP} || exit 1 ;\
		CC=${CUI_GCC} \
		  CFLAGS='-O2' \
		  LIBTOOL=${TARGSPEC}-libtool \
		  ./configure \
			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			|| exit 1 ;\
	)

##

${NTI_LIBFFI_CONFIGURED}: ${NTI_LIBFFI_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${CTI_LIBFFI_BUILT}: ${CTI_LIBFFI_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBFFI_TEMP} || exit 1 ;\
		make all LIBTOOL=${TARGSPEC}-libtool \
	)

##

${NTI_LIBFFI_BUILT}: ${NTI_LIBFFI_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		make all LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${CTI_LIBFFI_INSTALLED}: ${CTI_LIBFFI_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBFFI_TEMP} || exit 1 ;\
		make install LIBTOOL=${TARGSPEC}-libtool \
	)

.PHONY: cti-libffi
cti-libffi: cti-pkg-config ${CTI_LIBFFI_INSTALLED}

ALL_CTI_TARGETS+= cti-libffi

##

${NTI_LIBFFI_INSTALLED}: ${NTI_LIBFFI_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBFFI_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/`basename ${NTI_LIBFFI_INSTALLED}` ${NTI_LIBFFI_INSTALLED} \


.PHONY: nti-libffi
nti-libffi: nti-pkg-config ${NTI_LIBFFI_INSTALLED}

ALL_NTI_TARGETS+= nti-libffi

endif	# HAVE_LIBFFI_CONFIG
