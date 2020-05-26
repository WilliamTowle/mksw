# mesa v11.0.2			[ since v11.0.0, c.2015-09-22 ]
# last mod WmT, 2015-09-22	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_MESA_CONFIG},y)
HAVE_MESA_CONFIG:=y

#DESCRLIST+= "'cti-mesa' -- mesa"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${MESA_VERSION},)
#MESA_VERSION=11.0.0
MESA_VERSION=11.0.2
endif

#MESA_SRC=${SOURCES}/m/mesa_${MESA_VERSION}.orig.tar.gz
MESA_SRC=${SOURCES}/m/mesa-${MESA_VERSION}.tar.gz
#URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mesa/mesa_11.0.0.orig.tar.gz
URLS+= ftp://ftp.freedesktop.org/pub/mesa/11.0.2/mesa-11.0.2.tar.gz

include ${CFG_ROOT}/gui/x11proto-gl/v1.4.15.mak
include ${CFG_ROOT}/gui/libdrm/v2.4.65.mak
include ${CFG_ROOT}/gui/x11proto-dri2/v2.6.mak
include ${CFG_ROOT}/gui/x11proto-dri3/v1.0.mak
include ${CFG_ROOT}/gui/x11proto-present/v1.0.mak
include ${CFG_ROOT}/gui/libxcb/v1.11.mak
include ${CFG_ROOT}/gui/libxshmfence/v1.2.mak
include ${CFG_ROOT}/x11-misc/libX11/v1.5.0.mak
include ${CFG_ROOT}/gui/libXext/v1.3.1.mak
include ${CFG_ROOT}/gui/libXdamage/v1.1.3.mak
## ...
#include ${CFG_ROOT}/misc/libudev/v175.mak
include ${CFG_ROOT}/misc/expat/v2.1.0.mak

CTI_MESA_TEMP=cti-mesa-${MESA_VERSION}

CTI_MESA_EXTRACTED=${EXTTEMP}/${CTI_MESA_TEMP}/autogen.sh
CTI_MESA_CONFIGURED=${EXTTEMP}/${CTI_MESA_TEMP}/config.log
# INSTTEMP?
CTI_MESA_BUILT=${EXTTEMP}/${CTI_MESA_TEMP}/BAZ
CTI_MESA_INSTALLED=${CTI_TC_ROOT}/usr/bin/QUX


## ,-----
## |	Extract
## +-----

${CTI_MESA_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/mesa-${MESA_VERSION} ] || rm -rf ${EXTTEMP}/mesa-${MESA_VERSION}
	zcat ${MESA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_MESA_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_MESA_TEMP}
	mv ${EXTTEMP}/mesa-${MESA_VERSION} ${EXTTEMP}/${CTI_MESA_TEMP}


## ,-----
## |	Configure
## +-----

## --enable-dri because "egl requires --enable-dri"
## --enable-sysfs?

${CTI_MESA_CONFIGURED}: ${CTI_MESA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_MESA_TEMP} || exit 1 ;\
	  CC=${CUI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
	  PKG_CONFIG_PATH=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${INSTTEMP}/usr \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			--enable-dri --enable-sysfs \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${CTI_MESA_BUILT}: ${CTI_MESA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_MESA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CTI_MESA_INSTALLED}: ${CTI_MESA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_MESA_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: cti-mesa
cti-mesa: cti-pkg-config \
	cti-x11proto-gl cti-x11proto-dri2 cti-x11proto-dri3 cti-x11proto-present \
	cti-libdrm cti-libxcb cti-libxshmfence \
	cti-libX11 \
	cti-libXext \
	cti-libXdamage \
	\
	cti-expat \
	${CTI_MESA_INSTALLED}
#	\
#	cti-libudev \

ALL_CTI_TARGETS+= cti-mesa

endif	# HAVE_MESA_CONFIG
