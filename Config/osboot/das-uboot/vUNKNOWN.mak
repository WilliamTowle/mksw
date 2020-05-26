# das-uboot vUNKNOWN		[ since vUNKNOWN, c.2017-07-18 ]
# last mod WmT, 2017-07-18	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DAS_UBOOT_CONFIG},y)
HAVE_DAS_UBOOT_CONFIG:=y

#DESCRLIST+= "'nti-das-uboot' -- das-uboot"
#DESCRLIST+= "'cti-das-uboot' -- das-uboot"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${DAS_UBOOT_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
DAS_UBOOT_VERSION=vUNKNOWN
endif

#DAS_UBOOT_SRC=${SOURCES}/m/das-uboot-${DAS_UBOOT_VERSION}.tar.gz
DAS_UBOOT_SRC= git://git.denx.de/u-boot.git
# downloads at ftp://ftp.denx.de/pub/u-boot/
URLS+= git://git.denx.de/u-boot.git

NTI_DAS_UBOOT_TEMP=nti-das-uboot-${DAS_UBOOT_VERSION}

NTI_DAS_UBOOT_EXTRACTED=${EXTTEMP}/${NTI_DAS_UBOOT_TEMP}/.git
NTI_DAS_UBOOT_CONFIGURED=${EXTTEMP}/${NTI_DAS_UBOOT_TEMP}/Makefile
NTI_DAS_UBOOT_BUILT=${EXTTEMP}/${NTI_DAS_UBOOT_TEMP}/bin/das-uboot
NTI_DAS_UBOOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/das-uboot


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly

${NTI_DAS_UBOOT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/das-uboot-${DAS_UBOOT_VERSION} ] || rm -rf ${EXTTEMP}/das-uboot-${DAS_UBOOT_VERSION}
#	zcat ${DAS_UBOOT_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP}
#	mv ${EXTTEMP}/das-uboot-${DAS_UBOOT_VERSION} ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP}
	( mkdir -p ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} ;\
		git clone ${DAS_UBOOT_SRC} \
			${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} \
	)



## ,-----
## |	Configure
## +-----

${NTI_DAS_UBOOT_CONFIGURED}: ${NTI_DAS_UBOOT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} || exit 1 ;\
		make qemu-x86_defconfig || exit 1 \
	)


## ,-----
## |	Build
## +-----

## [2017-07-19] 32-bit build on 64-bit host needs 'gcc-6-multilib' package

${NTI_DAS_UBOOT_BUILT}: ${NTI_DAS_UBOOT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} || exit 1 ;\
		make all || exit 1 \
	)


## ,-----
## |	Install
## +-----

## Lacks 'install' target, therefore bail

${NTI_DAS_UBOOT_INSTALLED}: ${NTI_DAS_UBOOT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DAS_UBOOT_TEMP} || exit 1 ;\
		echo "INTENTIONAL BAIL - no 'install' target upstream..." ; exit 1 ;\
		make install \
	)

.PHONY: nti-das-uboot
nti-das-uboot: ${NTI_DAS_UBOOT_INSTALLED}

ALL_NTI_TARGETS+= nti-das-uboot

endif	# HAVE_DAS_UBOOT_CONFIG
