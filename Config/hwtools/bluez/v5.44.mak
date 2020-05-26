# bluez v5.44			[ since v5.39, 2016-05-16 ]
# last mod WmT, 2016-05-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_BLUEZ_CONFIG},y)
HAVE_BLUEZ_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-bluez' -- bluez"
#DESCRLIST+= "'nti-bluez' -- bluez"

ifeq (${BLUEZ_VERSION},)
#BLUEZ_VERSION=5.39
BLUEZ_VERSION=5.44
endif

BLUEZ_SRC=${SOURCES}/b/bluez-${BLUEZ_VERSION}.tar.xz
URLS+= http://www.kernel.org/pub/linux/bluetooth/bluez-${BLUEZ_VERSION}.tar.xz

#include ${CFG_ROOT}/misc/libudev/v175.mak


NTI_BLUEZ_TEMP=nti-bluez-${BLUEZ_VERSION}

NTI_BLUEZ_EXTRACTED=${EXTTEMP}/${NTI_BLUEZ_TEMP}/configure
NTI_BLUEZ_CONFIGURED=${EXTTEMP}/${NTI_BLUEZ_TEMP}/config.log
NTI_BLUEZ_BUILT=${EXTTEMP}/${NTI_BLUEZ_TEMP}/src/bluetoothd
NTI_BLUEZ_INSTALLED=${NTI_TC_ROOT}/usr/bin/bluetoothctl


## ,-----
## |	Extract
## +-----

${NTI_BLUEZ_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bluez-${BLUEZ_VERSION} ] || rm -rf ${EXTTEMP}/bluez-${BLUEZ_VERSION}
	xzcat ${BLUEZ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BLUEZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BLUEZ_TEMP}
	mv ${EXTTEMP}/bluez-${BLUEZ_VERSION} ${EXTTEMP}/${NTI_BLUEZ_TEMP}


## ,-----
## |	Configure
## +-----

# "libical is required" (...dependency on cmake)
${NTI_BLUEZ_CONFIGURED}: ${NTI_BLUEZ_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-obex \
			--disable-systemd \
			--disable-udev \
			--enable-library \
			--with-dbusconfdir=${NTI_TC_ROOT}/etc \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BLUEZ_BUILT}: ${NTI_BLUEZ_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BLUEZ_INSTALLED}: ${NTI_BLUEZ_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		make install \
	)


.PHONY: nti-bluez
nti-bluez: ${NTI_BLUEZ_INSTALLED}

#ALL_NTI_TARGETS+= \
#	nti-libudev \
#	nti-bluez
ALL_NTI_TARGETS+= \
	nti-bluez

endif	# HAVE_BLUEZ_CONFIG
