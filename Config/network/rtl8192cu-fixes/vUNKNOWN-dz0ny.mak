# rtl8192cu-fixes @dzony	[ since v?.?, c.2016-09-03 ]
# last mod WmT, 2016-09-08	[ (c) and GPLv2 1999-2016* ]

# Based on rtl driver "for Ubuntu 13.10 and later"
# Other dev support available
# Implies "dkms module" only
# For blacklisting of native module:
# 	sudo cp ./rtl8192cu-fixes/blacklist-native-rtl8192.conf /etc/modprobe.d/

ifneq (${HAVE_RTL8192CU_FIXES_CONFIG},y)
HAVE_RTL8192CU_FIXES_CONFIG:=y

#DESCRLIST+= "'nti-rtl8192cu-fixes' -- rtl8192cu-fixes"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/tools/unzip/v60.mak


ifeq (${RTL8192CU_FIXES_VERSION},)
RTL8192CU_FIXES_VERSION=UNKNOWN
endif

RTL8192CU_FIXES_SRC=${SOURCES}/r/rtl8192cu-fixes-master.zip
URLS+= https://github.com/dz0ny/rt8192cu/archive/master.zip
RTL8192CU_FIXES_PATCHES=
URLS+=

#include ${CFG_ROOT}/misc/linux/v3.16.0-headers.mak
#include ${CFG_ROOT}/misc/linux/v3.16.36.mak

NTI_RTL8192CU_FIXES_TEMP=nti-rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}

NTI_RTL8192CU_FIXES_EXTRACTED=${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}/README.md
NTI_RTL8192CU_FIXES_CONFIGURED=${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}/Makefile.OLD
NTI_RTL8192CU_FIXES_BUILT=${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}/rtl8192cu-fixes/rtl8192cu-fixes
NTI_RTL8192CU_FIXES_INSTALLED=${NTI_TC_ROOT}/usr/bin/rtl8192cu-fixes


## ,-----
## |	Extract
## +-----

${NTI_RTL8192CU_FIXES_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION} ] || rm -rf ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}
	[ ! -d ${EXTTEMP}/rtl8192cu-fixes-master ] || rm -rf ${EXTTEMP}/rtl8192cu-fixes-master
	#zcat ${RTL8192CU_FIXES_SRC} | tar xvf - -C ${EXTTEMP}
	unzip -d ${EXTTEMP} ${RTL8192CU_FIXES_SRC}
ifneq (${RTL8192CU_FIXES_PATCHES},)
	mkdir -p ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}/patches
	( cd ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}/patches ;\
		unzip -d . ${RTL8192CU_FIXES_PATCHES} \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}
	#mv ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION} ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}
	mv ${EXTTEMP}/rtl8192cu-fixes-master ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP}


## ,-----
## |	Configure
## +-----

## TODO: Makefile needs KSRC and/or MODDESTDIR

${NTI_RTL8192CU_FIXES_CONFIGURED}: ${NTI_RTL8192CU_FIXES_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		touch ${NTI_RTL8192CU_FIXES_CONFIGURED} \
	)
#...		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#...		cat Makefile.OLD \
#...			| sed '/^KSRC/	s%=.*%= '${CTI_TC_ROOT}'/usr/src/linux%' \
#...			> Makefile \
#...	)


## ,-----
## |	Build
## +-----

${NTI_RTL8192CU_FIXES_BUILT}: ${NTI_RTL8192CU_FIXES_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_RTL8192CU_FIXES_INSTALLED}: ${NTI_RTL8192CU_FIXES_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make -C rtl8192cu-fixes install \
	)

##

.PHONY: nti-rtl8192cu-fixes
nti-rtl8192cu-fixes: \
	nti-unzip \
	${NTI_RTL8192CU_FIXES_INSTALLED}
#nti-rtl8192cu-fixes: \
#	nti-unzip nti-lxheaders \
#	${NTI_RTL8192CU_FIXES_INSTALLED}

ALL_NTI_TARGETS+= nti-rtl8192cu-fixes

endif	# HAVE_RTL8192CU_FIXES_CONFIG
