# seaBIOS vUNKNOWN		[ since vUNKNOWN, c.2017-07-24 ]
# last mod WmT, 2017-07-24	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SEABIOS_CONFIG},y)
HAVE_SEABIOS_CONFIG:=y

#DESCRLIST+= "'nti-seaBIOS' -- seaBIOS"
#DESCRLIST+= "'cti-seaBIOS' -- seaBIOS"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${SEABIOS_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
SEABIOS_VERSION=vUNKNOWN
endif

#SEABIOS_SRC=${SOURCES}/m/seaBIOS-${SEABIOS_VERSION}.tar.gz
SEABIOS_SRC= git://git.seabios.org/seabios.git
#URLS+= git://git.denx.de/u-boot.git
URLS+= git://git.seabios.org/seabios.git

NTI_SEABIOS_TEMP=nti-seaBIOS-${SEABIOS_VERSION}

NTI_SEABIOS_EXTRACTED=${EXTTEMP}/${NTI_SEABIOS_TEMP}/.git
NTI_SEABIOS_CONFIGURED=${EXTTEMP}/${NTI_SEABIOS_TEMP}/.configured
NTI_SEABIOS_BUILT=${EXTTEMP}/${NTI_SEABIOS_TEMP}/bin/seaBIOS
NTI_SEABIOS_INSTALLED=${NTI_TC_ROOT}/usr/bin/seaBIOS


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly
## FIXME: use 'shallow' clone to limit download size

${NTI_SEABIOS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/seaBIOS-${SEABIOS_VERSION} ] || rm -rf ${EXTTEMP}/seaBIOS-${SEABIOS_VERSION}
#	zcat ${SEABIOS_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${NTI_SEABIOS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SEABIOS_TEMP}
#	mv ${EXTTEMP}/seaBIOS-${SEABIOS_VERSION} ${EXTTEMP}/${NTI_SEABIOS_TEMP}
	( mkdir -p ${EXTTEMP}/${NTI_SEABIOS_TEMP} ;\
		git clone ${SEABIOS_SRC} \
			${EXTTEMP}/${NTI_SEABIOS_TEMP} \
	)



## ,-----
## |	Configure
## +-----

${NTI_SEABIOS_CONFIGURED}: ${NTI_SEABIOS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		cd seaBIOS ;\
		git submodule update --init --checkout ;\
		touch ${NTI_SEABIOS_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

## [2017-07-19] 32-bit build on 64-bit host needs 'gcc-6-multilib' package

${NTI_SEABIOS_BUILT}: ${NTI_SEABIOS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make all || exit 1 \
	)


## ,-----
## |	Install
## +-----

## Lacks 'install' target, therefore bail

${NTI_SEABIOS_INSTALLED}: ${NTI_SEABIOS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SEABIOS_TEMP} || exit 1 ;\
		echo "INTENTIONAL BAIL - no 'install' target upstream..." ; exit 1 ;\
		make install \
	)

.PHONY: nti-seaBIOS
nti-seaBIOS: ${NTI_SEABIOS_INSTALLED}

ALL_NTI_TARGETS+= nti-seaBIOS

endif	# HAVE_SEABIOS_CONFIG
