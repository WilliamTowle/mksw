# seaBIOS v1.10.0		[ since vUNKNOWN, c.2017-07-24 ]
# last mod WmT, 2017-10-26	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SEABIOS_CONFIG},y)
HAVE_SEABIOS_CONFIG:=y

#DESCRLIST+= "'nti-seaBIOS' -- seaBIOS"
#DESCRLIST+= "'cti-seaBIOS' -- seaBIOS"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${SEABIOS_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
#SEABIOS_VERSION=vUNKNOWN
SEABIOS_VERSION=1.10.0
endif

SEABIOS_SRC=${SOURCES}/s/seabios-1.10.0.tar.gz
#SEABIOS_SRC= git://git.seabios.org/seabios.git
URLS+= https://code.coreboot.org/p/seabios/downloads/get/seabios-1.10.0.tar.gz
#URLS+= git://git.seabios.org/seabios.git

NTI_SEABIOS_TEMP=nti-seaBIOS-${SEABIOS_VERSION}

NTI_SEABIOS_EXTRACTED=${EXTTEMP}/${NTI_SEABIOS_TEMP}/COPYING
NTI_SEABIOS_CONFIGURED=${EXTTEMP}/${NTI_SEABIOS_TEMP}/.configured
NTI_SEABIOS_BUILT=${EXTTEMP}/${NTI_SEABIOS_TEMP}/bin/seaBIOS
NTI_SEABIOS_INSTALLED=${NTI_TC_ROOT}/usr/bin/seaBIOS


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly

${NTI_SEABIOS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/seabios-${SEABIOS_VERSION} ] || rm -rf ${EXTTEMP}/seabios-${SEABIOS_VERSION}
	zcat ${SEABIOS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SEABIOS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SEABIOS_TEMP}
	mv ${EXTTEMP}/seabios-${SEABIOS_VERSION} ${EXTTEMP}/${NTI_SEABIOS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SEABIOS_CONFIGURED}: ${NTI_SEABIOS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		touch ${NTI_SEABIOS_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_SEABIOS_BUILT}: ${NTI_SEABIOS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		make || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_SEABIOS_INSTALLED}: ${NTI_SEABIOS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-seabios
nti-seabios: ${NTI_SEABIOS_INSTALLED}

ALL_NTI_TARGETS+= nti-seabios

endif	# HAVE_SEABIOS_CONFIG
