# kexec-tools v2.0.10		[ since v2.0.10, c.2015-06-29 ]
# last mod WmT, 2015-06-29	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_KEXEC_TOOLS},y)
HAVE_KEXEC_TOOLS:=y

#DESCRLIST+= "'nti-kexec-tools' -- kexec-tools"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${KEXEC_TOOLS_VERSION},)
KEXEC_TOOLS_VERSION=2.0.10
endif

KEXEC_TOOLS_SRC=${SOURCES}/k/kexec-tools-${KEXEC_TOOLS_VERSION}.tar.gz
URLS+= https://www.kernel.org/pub/linux/utils/kernel/kexec/kexec-tools-2.0.10.tar.gz

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

NTI_KEXEC_TOOLS_TEMP=nti-kexec-tools-${KEXEC_TOOLS_VERSION}

NTI_KEXEC_TOOLS_EXTRACTED=${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP}/TODO
NTI_KEXEC_TOOLS_CONFIGURED=${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP}/config.status
NTI_KEXEC_TOOLS_BUILT=${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP}/build/sbin/kexec
NTI_KEXEC_TOOLS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/kexec


CUI_KEXEC_TOOLS_TEMP=cui-kexec-tools-${KEXEC_TOOLS_VERSION}
CUI_KEXEC_TOOLS_INSTTEMP=${EXTTEMP}/insttemp

CUI_KEXEC_TOOLS_EXTRACTED=${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP}/TODO
CUI_KEXEC_TOOLS_CONFIGURED=${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP}/config.status
CUI_KEXEC_TOOLS_BUILT=${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP}/build/sbin/kexec
CUI_KEXEC_TOOLS_INSTALLED=${CUI_KEXEC_TOOLS_INSTTEMP}/usr/sbin/kexec



## ,-----
## |	Extract
## +-----

${NTI_KEXEC_TOOLS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION} ] || rm -rf ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION}
	zcat ${KEXEC_TOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP}
	mv ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION} ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP}

##

${CUI_KEXEC_TOOLS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION} ] || rm -rf ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION}
	zcat ${KEXEC_TOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP}
	mv ${EXTTEMP}/kexec-tools-${KEXEC_TOOLS_VERSION} ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_KEXEC_TOOLS_CONFIGURED}: ${NTI_KEXEC_TOOLS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \

##

${CUI_KEXEC_TOOLS_CONFIGURED}: ${CUI_KEXEC_TOOLS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		CC=${CUI_GCC} \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=/usr \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_KEXEC_TOOLS_BUILT}: ${NTI_KEXEC_TOOLS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		make all \
	)

##

${CUI_KEXEC_TOOLS_BUILT}: ${CUI_KEXEC_TOOLS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_KEXEC_TOOLS_INSTALLED}: ${NTI_KEXEC_TOOLS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		make install \
	)

##

${CUI_KEXEC_TOOLS_INSTALLED}: ${CUI_KEXEC_TOOLS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CUI_KEXEC_TOOLS_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_KEXEC_TOOLS_INSTTEMP} install \
	)


##

.PHONY: nti-kexec-tools
nti-kexec-tools: ${NTI_KEXEC_TOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-kexec-tools

##

.PHONY: cui-kexec-tools
cui-kexec-tools: ${CUI_KEXEC_TOOLS_INSTALLED}

ALL_CUI_TARGETS+= cui-kexec-tools

endif	# HAVE_KEXEC_TOOLS_CONFIG
