# alsa-firmware v1.0.29		[ EARLIEST v1.0.13, ????-??-?? ]
# last mod WmT, 2015-07-29	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_ALSA_FIRMWARE_CONFIG},y)
HAVE_ALSA_FIRMWARE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-alsa-firmware' -- alsa-firmware"

ifeq (${ALSA_FIRMWARE_VERSION},)
#ALSA_FIRMWARE_VERSION=1.0.13
#ALSA_FIRMWARE_VERSION=1.0.25
#ALSA_FIRMWARE_VERSION=1.0.25
ALSA_FIRMWARE_VERSION=1.0.29
endif

ALSA_FIRMWARE_SRC=${SOURCES}/a/alsa-firmware-${ALSA_FIRMWARE_VERSION}.tar.bz2
URLS+= ftp://ftp.alsa-project.org/pub/lib/alsa-firmware-${ALSA_FIRMWARE_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


NTI_ALSA_FIRMWARE_TEMP=nti-alsa-firmware-${ALSA_FIRMWARE_VERSION}

NTI_ALSA_FIRMWARE_EXTRACTED=${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP}/configure.in
NTI_ALSA_FIRMWARE_CONFIGURED=${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP}/config.log
NTI_ALSA_FIRMWARE_BUILT=${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP}/ymfpci
NTI_ALSA_FIRMWARE_INSTALLED=${NTI_TC_ROOT}/usr/share/alsa/firmware/vxloader/vx222.conf


## ,-----
## |	Extract
## +-----

${NTI_ALSA_FIRMWARE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-firmware-${ALSA_FIRMWARE_VERSION} ] || rm -rf ${EXTTEMP}/alsa-firmware-${ALSA_FIRMWARE_VERSION}
	bzcat ${ALSA_FIRMWARE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP}
	mv ${EXTTEMP}/alsa-firmware-${ALSA_FIRMWARE_VERSION} ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ALSA_FIRMWARE_CONFIGURED}: ${NTI_ALSA_FIRMWARE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-hotplug-dir=${NTI_TC_ROOT}/lib/firmware \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSA_FIRMWARE_BUILT}: ${NTI_ALSA_FIRMWARE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ALSA_FIRMWARE_INSTALLED}: ${NTI_ALSA_FIRMWARE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_FIRMWARE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-alsa-firmware
nti-alsa-firmware: ${NTI_ALSA_FIRMWARE_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-firmware

endif	# HAVE_ALSA_FIRMWARE_CONFIG
