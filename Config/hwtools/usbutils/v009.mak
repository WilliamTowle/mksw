# usbutils v009			[ since v0.87, c.2011-06-15 ]
# last mod WmT, 2017-11-20	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_USBUTILS_CONFIG},y)
HAVE_USBUTILS_CONFIG:=y

DESCRLIST+= "'nti-usbutils' -- usbutils"

include ${CFG_ROOT}/ENV/buildtype.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

ifeq (${USBUTILS_VERSION},)
#USBUTILS_VERSION=0.87
#USBUTILS_VERSION=008
USBUTILS_VERSION=009
endif

#USBUTILS_SRC=${SOURCES}/u/usbutils-${USBUTILS_VERSION}.tar.gz
USBUTILS_SRC=${SOURCES}/v/v${USBUTILS_VERSION}.tar.gz
#URLS+= https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-${USBUTILS_VERSION}.tar.gz
URLS+= https://github.com/gregkh/usbutils/archive/v009.tar.gz

#include ${CFG_ROOT}/systools/libusb/v0.1.12.mak
include ${CFG_ROOT}/hwtools/libusb/v1.0.19.mak

NTI_USBUTILS_TEMP=nti-usbutils-${USBUTILS_VERSION}

NTI_USBUTILS_EXTRACTED=${EXTTEMP}/${NTI_USBUTILS_TEMP}/README
NTI_USBUTILS_CONFIGURED=${EXTTEMP}/${NTI_USBUTILS_TEMP}/config.status
NTI_USBUTILS_BUILT=${EXTTEMP}/${NTI_USBUTILS_TEMP}/usbutils
NTI_USBUTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/usbutils


# ,-----
# |	Extract
# +-----

${NTI_USBUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/usbutils-${USBUTILS_VERSION} ] || rm -rf ${EXTTEMP}/usbutils-${USBUTILS_VERSION}
	zcat ${USBUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_USBUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_USBUTILS_TEMP}
	mv ${EXTTEMP}/usbutils-${USBUTILS_VERSION} ${EXTTEMP}/${NTI_USBUTILS_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_USBUTILS_CONFIGURED}: ${NTI_USBUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
		sh autogen.sh || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		      ./configure \
		      	--prefix=${NTI_TC_ROOT}/usr \
		      	|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_USBUTILS_BUILT}: ${NTI_USBUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_USBUTILS_INSTALLED}: ${NTI_USBUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
		make install \
	)
#

.PHONY: nti-usbutils
#nti-usbutils: nti-native-gcc nti-pkg-config nti-libusb nti-usbutils-installed
nti-usbutils: nti-pkg-config \
	nti-libusb ${NTI_USBUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-usbutils

endif	# HAVE_USBUTILS_CONFIG
