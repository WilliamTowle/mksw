# rtl8192cu-fixes @pvaret	[ since v?.?, c.2017-08-24 ]
# last mod WmT, 2017-09-25	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_RTL8192CU_FIXES_CONFIG},y)
HAVE_RTL8192CU_FIXES_CONFIG:=y

#DESCRLIST+= "'nui-rtl8192cu-fixes' -- rtl8192cu-fixes"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${RTL8192CU_FIXES_VERSION},)
# TODO: maybe check for a specific SHA? or check one out?
RTL8192CU_FIXES_VERSION=vUNKNOWN
endif

#RTL8192CU_FIXES_SRC=${SOURCES}/m/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}.tar.gz
RTL8192CU_FIXES_SRC= https://github.com/pvaret/rtl8192cu-fixes.git
URLS+= https://github.com/pvaret/rtl8192cu-fixes.git


NUI_RTL8192CU_FIXES_TEMP=nui-rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}

NUI_RTL8192CU_FIXES_EXTRACTED=${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}/rtl8192cu-fixes/.git
NUI_RTL8192CU_FIXES_CONFIGURED=${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}/.configured
NUI_RTL8192CU_FIXES_BUILT=${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}/bin/rtl8192cu-fixes
NUI_RTL8192CU_FIXES_INSTTEMP=${EXTTEMP}/insttemp
NUI_RTL8192CU_FIXES_INSTALLED=${NUI_TC_ROOT}/usr/bin/rtl8192cu-fixes


## ,-----
## |	Extract
## +-----

## See http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.x86
## can boot kernel as part of FIT image, or compressed zImage directly

## dkms sometimes expects source in /usr/src/<module>-<module-version>/

${NUI_RTL8192CU_FIXES_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION} ] || rm -rf ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION}
#	zcat ${RTL8192CU_FIXES_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP} ] || rm -rf ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}
#	mv ${EXTTEMP}/rtl8192cu-fixes-${RTL8192CU_FIXES_VERSION} ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}
	( mkdir -p ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP} ;\
		git clone ${RTL8192CU_FIXES_SRC} \
			${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP}/rtl8192cu-fixes \
	)


## ,-----
## |	Configure
## +-----

${NUI_RTL8192CU_FIXES_CONFIGURED}: ${NUI_RTL8192CU_FIXES_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		touch ${NUI_RTL8192CU_FIXES_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NUI_RTL8192CU_FIXES_BUILT}: ${NUI_RTL8192CU_FIXES_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		[ -d /var/lib/dkms/8192cu/1.10 ] || dkms add ./rtl8192cu-fixes || exit 1 \
	)
#		make all || exit 1 \


## ,-----
## |	Install
## +-----

ALL_NTI_TARGETS:=

##

# Build against wheezy/stretch
TARGET_KERNEL=3.2.0-4-686-pae
#TARGET_KERNEL=4.9.0-3-686-pae

${NUI_RTL8192CU_FIXES_INSTALLED}: ${NUI_RTL8192CU_FIXES_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NUI_RTL8192CU_FIXES_TEMP} || exit 1 ;\
		dkms install 8192cu/1.10 -k ${TARGET_KERNEL}/i386 || exit 1 ;\
		depmod -a ${TARGET_KERNEL} \
	)
#		make install \

.PHONY: nui-rtl8192cu-fixes
nui-rtl8192cu-fixes: ${NUI_RTL8192CU_FIXES_INSTALLED}

ALL_NUI_TARGETS+= nui-rtl8192cu-fixes

##

ALL_CTI_TARGETS:=

##

ALL_CUI_TARGETS:=


endif	# HAVE_RTL8192CU_FIXES_CONFIG
