# libreboot vUNKNOWN		[ since vUNKNOWN, c.2017-07-24 ]
# last mod WmT, 2017-07-24	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBREBOOT_CONFIG},y)
HAVE_LIBREBOOT_CONFIG:=y

#DESCRLIST+= "'nti-libreboot' -- libreboot"
#DESCRLIST+= "'cti-libreboot' -- libreboot"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBREBOOT_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
LIBREBOOT_VERSION=vUNKNOWN
endif

#LIBREBOOT_SRC=${SOURCES}/m/libreboot-${LIBREBOOT_VERSION}.tar.gz
LIBREBOOT_SRC= https://notabug.org/libreboot/libreboot.git
URLS+= https://notabug.org/libreboot/libreboot.git

NTI_LIBREBOOT_TEMP=nti-libreboot-${LIBREBOOT_VERSION}

NTI_LIBREBOOT_EXTRACTED=${EXTTEMP}/${NTI_LIBREBOOT_TEMP}/.git
NTI_LIBREBOOT_CONFIGURED=${EXTTEMP}/${NTI_LIBREBOOT_TEMP}/.configured
NTI_LIBREBOOT_BUILT=${EXTTEMP}/${NTI_LIBREBOOT_TEMP}/bin/libreboot
NTI_LIBREBOOT_INSTALLED=${NTI_TC_ROOT}/usr/bin/libreboot


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly
## FIXME: use 'shallow' clone to limit download size

${NTI_LIBREBOOT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/libreboot-${LIBREBOOT_VERSION} ] || rm -rf ${EXTTEMP}/libreboot-${LIBREBOOT_VERSION}
#	zcat ${LIBREBOOT_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${NTI_LIBREBOOT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBREBOOT_TEMP}
#	mv ${EXTTEMP}/libreboot-${LIBREBOOT_VERSION} ${EXTTEMP}/${NTI_LIBREBOOT_TEMP}
	( mkdir -p ${EXTTEMP}/${NTI_LIBREBOOT_TEMP} ;\
		git clone ${LIBREBOOT_SRC} \
			${EXTTEMP}/${NTI_LIBREBOOT_TEMP} \
	)



## ,-----
## |	Configure
## +-----

${NTI_LIBREBOOT_CONFIGURED}: ${NTI_LIBREBOOT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBREBOOT_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		cd libreboot ;\
		git submodule update --init --checkout ;\
		touch ${NTI_LIBREBOOT_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

## [2017-07-19] 32-bit build on 64-bit host needs 'gcc-6-multilib' package

${NTI_LIBREBOOT_BUILT}: ${NTI_LIBREBOOT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBREBOOT_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make all || exit 1 \
	)


## ,-----
## |	Install
## +-----

## Lacks 'install' target, therefore bail

${NTI_LIBREBOOT_INSTALLED}: ${NTI_LIBREBOOT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBREBOOT_TEMP} || exit 1 ;\
		echo "INTENTIONAL BAIL - no 'install' target upstream..." ; exit 1 ;\
		make install \
	)

.PHONY: nti-libreboot
nti-libreboot: ${NTI_LIBREBOOT_INSTALLED}

ALL_NTI_TARGETS+= nti-libreboot

endif	# HAVE_LIBREBOOT_CONFIG
