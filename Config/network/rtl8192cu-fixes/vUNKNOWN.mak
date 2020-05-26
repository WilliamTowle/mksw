# rt8192cu-fixes v'master'	[ since v?.?, c.2016-09-03 ]
# last mod WmT, 2016-09-08	[ (c) and GPLv2 1999-2016* ]

# with 64-bit support
# has 'dkms' and 'install' target

ifneq (${HAVE_RT8192CU_CONFIG},y)
HAVE_RT8192CU_CONFIG:=y

#DESCRLIST+= "'nti-rt8192cu' -- rt8192cu"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/tools/unzip/v60.mak


ifeq (${RT8192CU_VERSION},)
RT8192CU_VERSION=UNKNOWN
endif

RT8192CU_SRC=${SOURCES}/r/rt8192cu-master.zip
URLS+= https://github.com/pvaret/rtl8192cu-fixes/archive/master.zip
RT8192CU_PATCHES=
URLS+=

#include ${CFG_ROOT}/misc/linux/v3.16.0-headers.mak
#include ${CFG_ROOT}/misc/linux/v3.16.36.mak

NTI_RT8192CU_TEMP=nti-rt8192cu-${RT8192CU_VERSION}

NTI_RT8192CU_EXTRACTED=${EXTTEMP}/${NTI_RT8192CU_TEMP}/README.md
NTI_RT8192CU_CONFIGURED=${EXTTEMP}/${NTI_RT8192CU_TEMP}/Makefile.OLD
NTI_RT8192CU_BUILT=${EXTTEMP}/${NTI_RT8192CU_TEMP}/rt8192cu
NTI_RT8192CU_INSTALLED=${NTI_TC_ROOT}/usr/bin/rt8192cu


## ,-----
## |	Extract
## +-----

${NTI_RT8192CU_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/rt8192cu-${RT8192CU_VERSION} ] || rm -rf ${EXTTEMP}/rt8192cu-${RT8192CU_VERSION}
	[ ! -d ${EXTTEMP}/rt8192cu-master ] || rm -rf ${EXTTEMP}/rt8192cu-master
	#zcat ${RT8192CU_SRC} | tar xvf - -C ${EXTTEMP}
	unzip -d ${EXTTEMP} ${RT8192CU_SRC}
ifneq (${RT8192CU_PATCHES},)
	mkdir -p ${EXTTEMP}/rt8192cu-${RT8192CU_VERSION}/patches
	( cd ${EXTTEMP}/rt8192cu-${RT8192CU_VERSION}/patches ;\
		unzip -d . ${RT8192CU_PATCHES} \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_RT8192CU_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_RT8192CU_TEMP}
	#mv ${EXTTEMP}/rt8192cu-${RT8192CU_VERSION} ${EXTTEMP}/${NTI_RT8192CU_TEMP}
	mv ${EXTTEMP}/rt8192cu-master ${EXTTEMP}/${NTI_RT8192CU_TEMP}


## ,-----
## |	Configure
## +-----

## TODO: Makefile needs KSRC and/or MODDESTDIR

${NTI_RT8192CU_CONFIGURED}: ${NTI_RT8192CU_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RT8192CU_TEMP} || exit 1 ;\
		touch ${NTI_RT8192CU_CONFIGURED} \
	)
#...		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#...		cat Makefile.OLD \
#...			| sed '/^KSRC/	s%=.*%= '${CTI_TC_ROOT}'/usr/src/linux%' \
#...			> Makefile \
#...	)


## ,-----
## |	Build
## +-----

${NTI_RT8192CU_BUILT}: ${NTI_RT8192CU_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RT8192CU_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_RT8192CU_INSTALLED}: ${NTI_RT8192CU_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RT8192CU_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make -C rt8192cu install \
	)

##

.PHONY: nti-rt8192cu
nti-rt8192cu: \
	nti-unzip \
	${NTI_RT8192CU_INSTALLED}
#nti-rt8192cu: \
#	nti-unzip nti-lxheaders \
#	${NTI_RT8192CU_INSTALLED}

ALL_NTI_TARGETS+= nti-rt8192cu

endif	# HAVE_RT8192CU_CONFIG
