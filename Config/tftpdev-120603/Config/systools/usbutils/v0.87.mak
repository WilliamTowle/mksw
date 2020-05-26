# usbutils v0.87		[ since v0.87, c.2011-06-15 ]
# last mod WmT, 2011-06-15	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_USBUTILS_CONFIG},y)
HAVE_USBUTILS_CONFIG:=y

DESCRLIST+= "'nti-usbutils' -- usbutils"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif
include ${CFG_ROOT}/systools/libusb/v0.1.12.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

USBUTILS_VER=0.87
USBUTILS_SRC=${SRCDIR}/u/usbutils_0.87.orig.tar.gz

URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/u/usbutils/usbutils_0.87.orig.tar.gz


# ,-----
# |	Extract
# +-----

NTI_USBUTILS_TEMP=nti-usbutils-${USBUTILS_VER}

NTI_USBUTILS_EXTRACTED=${EXTTEMP}/${NTI_USBUTILS_TEMP}/configure

.PHONY: nti-usbutils-extracted

nti-usbutils-extracted: ${NTI_USBUTILS_EXTRACTED}

${NTI_USBUTILS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_USBUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_USBUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${USBUTILS_SRC}
	mv ${EXTTEMP}/usbutils-${USBUTILS_VER} ${EXTTEMP}/${NTI_USBUTILS_TEMP}


# ,-----
# |	Configure
# +-----

NTI_USBUTILS_CONFIGURED=${EXTTEMP}/${NTI_USBUTILS_TEMP}/config.status

.PHONY: nti-usbutils-configured

nti-usbutils-configured: nti-usbutils-extracted ${NTI_USBUTILS_CONFIGURED}

${NTI_USBUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_USBUTILS_BUILT=${EXTTEMP}/${NTI_USBUTILS_TEMP}/lsusb

.PHONY: nti-usbutils-built
nti-usbutils-built: nti-usbutils-configured ${NTI_USBUTILS_BUILT}

${NTI_USBUTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_USBUTILS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/lsusb

.PHONY: nti-usbutils-installed

nti-usbutils-installed: nti-usbutils-built ${NTI_USBUTILS_INSTALLED}

${NTI_USBUTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_USBUTILS_TEMP} || exit 1 ;\
		make install \
	)
# [WmT] v5.04 needed rm -f ${NTI_TC_ROOT}/usr/bin/usbutils 2>/dev/null ;\
#

.PHONY: nti-usbutils
nti-usbutils: nti-native-gcc nti-pkg-config nti-libusb nti-usbutils-installed

NTARGETS+= nti-usbutils

endif	# HAVE_USBUTILS_CONFIG
