# libudev v175			[ since v3.0.10, c.2013-01-18 ]
# last mod WmT, 2015-10-26	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBUDEV},y)
HAVE_LIBUDEV:=y

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBUDEV_VERSION},)
LIBUDEV_VERSION=175
endif

#LIBUDEV_SRC=${SOURCES}/u/udev-${LIBUDEV_VERSION}.tar.bz2
LIBUDEV_SRC=${SOURCES}/u/udev_${LIBUDEV_VERSION}.orig.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/udev/udev_175.orig.tar.bz2

# deps?
include ${CFG_ROOT}/misc/glib/v2.46.0.mak
include ${CFG_ROOT}/misc/gobject-introspection/v1.46.0.mak

NTI_LIBUDEV_TEMP=nti-libudev-${LIBUDEV_VERSION}

NTI_LIBUDEV_EXTRACTED=${EXTTEMP}/${NTI_LIBUDEV_TEMP}/configure
NTI_LIBUDEV_CONFIGURED=${EXTTEMP}/${NTI_LIBUDEV_TEMP}/Makefile
NTI_LIBUDEV_BUILT=${EXTTEMP}/${NTI_LIBUDEV_TEMP}/${HOSTSPEC}/libudev.la
NTI_LIBUDEV_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libudev.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBUDEV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/udev-${LIBUDEV_VERSION} ] || rm -rf ${EXTTEMP}/udev-${LIBUDEV_VERSION}
	bzcat ${LIBUDEV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBUDEV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBUDEV_TEMP}
	mv ${EXTTEMP}/udev-${LIBUDEV_VERSION} ${EXTTEMP}/${NTI_LIBUDEV_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBUDEV_CONFIGURED}: ${NTI_LIBUDEV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBUDEV_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			|| exit 1 \
	)
#		  LIBTOOL=${TARGSPEC}-libtool \
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_LIBUDEV_BUILT}: ${NTI_LIBUDEV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBUDEV_TEMP} || exit 1 ;\
		make all \
	)
#		make all LIBTOOL=${TARGSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBUDEV_INSTALLED}: ${NTI_LIBUDEV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBUDEV_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${TARGSPEC}-libtool \

.PHONY: nti-libudev
nti-libudev: \
	nti-glib nti-gobject-introspection \
	${NTI_LIBUDEV_INSTALLED}

ALL_NTI_TARGETS+= nti-libudev

endif	# HAVE_LIBUDEV_CONFIG
