# coreboot vUNKNOWN		[ since vUNKNOWN, c.2017-07-24 ]
# last mod WmT, 2017-07-24	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_COREBOOT_CONFIG},y)
HAVE_COREBOOT_CONFIG:=y

#DESCRLIST+= "'nti-coreboot' -- coreboot"
#DESCRLIST+= "'cti-coreboot' -- coreboot"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${COREBOOT_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
COREBOOT_VERSION=vUNKNOWN
endif

#COREBOOT_SRC=${SOURCES}/m/coreboot-${COREBOOT_VERSION}.tar.gz
COREBOOT_SRC= https://review.coreboot.org/coreboot
#URLS+= git://git.denx.de/u-boot.git
URLS+= https://review.coreboot.org/coreboot

NTI_COREBOOT_TEMP=nti-coreboot-${COREBOOT_VERSION}

NTI_COREBOOT_EXTRACTED=${EXTTEMP}/${NTI_COREBOOT_TEMP}/.git
NTI_COREBOOT_CONFIGURED=${EXTTEMP}/${NTI_COREBOOT_TEMP}/.configured
NTI_COREBOOT_BUILT=${EXTTEMP}/${NTI_COREBOOT_TEMP}/bin/coreboot
NTI_COREBOOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/coreboot


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly

${NTI_COREBOOT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/coreboot-${COREBOOT_VERSION} ] || rm -rf ${EXTTEMP}/coreboot-${COREBOOT_VERSION}
#	zcat ${COREBOOT_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${NTI_COREBOOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_COREBOOT_TEMP}
#	mv ${EXTTEMP}/coreboot-${COREBOOT_VERSION} ${EXTTEMP}/${NTI_COREBOOT_TEMP}
	( mkdir -p ${EXTTEMP}/${NTI_COREBOOT_TEMP} ;\
		git clone ${COREBOOT_SRC} \
			${EXTTEMP}/${NTI_COREBOOT_TEMP} \
	)



## ,-----
## |	Configure
## +-----

${NTI_COREBOOT_CONFIGURED}: ${NTI_COREBOOT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_COREBOOT_TEMP} || exit 1 ;\
		cd coreboot ;\
		git submodule update --init --checkout ;\
		touch ${NTI_COREBOOT_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

## [2017-07-19] 32-bit build on 64-bit host needs 'gcc-6-multilib' package

${NTI_COREBOOT_BUILT}: ${NTI_COREBOOT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_COREBOOT_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make all || exit 1 \
	)


## ,-----
## |	Install
## +-----

## Lacks 'install' target, therefore bail

${NTI_COREBOOT_INSTALLED}: ${NTI_COREBOOT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_COREBOOT_TEMP} || exit 1 ;\
		echo "INTENTIONAL BAIL - no 'install' target upstream..." ; exit 1 ;\
		make install \
	)

.PHONY: nti-coreboot
nti-coreboot: ${NTI_COREBOOT_INSTALLED}

ALL_NTI_TARGETS+= nti-coreboot

endif	# HAVE_COREBOOT_CONFIG
