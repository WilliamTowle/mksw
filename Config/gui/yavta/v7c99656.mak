# yavta ver 7c99656		[ since v.7c99656, 2016-02-22 ]
# last mod WmT, 2016-02-22	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_YAVTA_CONFIG},y)
HAVE_YAVTA_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

DESCRLIST+= "'cui-yavta' -- yavta"
DESCRLIST+= "'nti-yavta' -- yavta"

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

YAVTA_VERSION=7c99656
YAVTA_SRC=${SOURCES}/y/yavta-${YAVTA_VERSION}.zip
URLS+= "via https://github.com/fastr/yavta"

#include ${CFG_ROOT}/gui/wayland/v1.8.1.mak

##

CUI_YAVTA_TEMP=cui-yavta-${YAVTA_VERSION}
CUI_YAVTA_INSTTEMP=${EXTTEMP}/insttemp-cui

CUI_YAVTA_EXTRACTED=${EXTTEMP}/${CUI_YAVTA_TEMP}/README.md
CUI_YAVTA_CONFIGURED=${EXTTEMP}/${CUI_YAVTA_TEMP}/.configured
CUI_YAVTA_BUILT=${EXTTEMP}/${CUI_YAVTA_TEMP}/yavta
CUI_YAVTA_INSTALLED=${CUI_YAVTA_INSTTEMP}/usr/bin/yavta

##

NTI_YAVTA_TEMP=nti-yavta-${YAVTA_VERSION}
#NUI_YAVTA_INSTTEMP=${EXTTEMP}/insttemp

NTI_YAVTA_EXTRACTED=${EXTTEMP}/${NTI_YAVTA_TEMP}/README.md
NTI_YAVTA_CONFIGURED=${EXTTEMP}/${NTI_YAVTA_TEMP}/.configured
NTI_YAVTA_BUILT=${EXTTEMP}/${NTI_YAVTA_TEMP}/yavta
NTI_YAVTA_INSTALLED=${NTI_TC_ROOT}/usr/bin/yavta
#NUI_YAVTA_INSTALLED=${NUI_YAVTA_INSTTEMP}/usr/X11R7/bin/yavta


## ,-----
## |	Extract
## +-----

${CUI_YAVTA_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/yavta-${YAVTA_VERSION} ] || rm -rf ${EXTTEMP}/yavta-${YAVTA_VERSION}
	[ ! -d ${EXTTEMP}/yavta-master ] || rm -rf ${EXTTEMP}/yavta-master
	#zcat ${YAVTA_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${YAVTA_SRC} -d ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CUI_YAVTA_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_YAVTA_TEMP}
	#mv ${EXTTEMP}/yavta-${YAVTA_VERSION} ${EXTTEMP}/${CUI_YAVTA_TEMP}
	mv ${EXTTEMP}/yavta-master ${EXTTEMP}/${CUI_YAVTA_TEMP}

##

${NTI_YAVTA_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/yavta-${YAVTA_VERSION} ] || rm -rf ${EXTTEMP}/yavta-${YAVTA_VERSION}
	[ ! -d ${EXTTEMP}/yavta-master ] || rm -rf ${EXTTEMP}/yavta-master
	#zcat ${YAVTA_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${YAVTA_SRC} -d ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_YAVTA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_YAVTA_TEMP}
	#mv ${EXTTEMP}/yavta-${YAVTA_VERSION} ${EXTTEMP}/${NTI_YAVTA_TEMP}
	mv ${EXTTEMP}/yavta-master ${EXTTEMP}/${NTI_YAVTA_TEMP}


## ,-----
## |	Configure
## +-----

${CUI_YAVTA_CONFIGURED}: ${CUI_YAVTA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_YAVTA_TEMP} || exit 1 ;\
		touch ${CUI_YAVTA_CONFIGURED} \
	)

##

${NTI_YAVTA_CONFIGURED}: ${NTI_YAVTA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_YAVTA_TEMP} || exit 1 ;\
		touch ${NTI_YAVTA_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${CUI_YAVTA_BUILT}: ${CUI_YAVTA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_YAVTA_TEMP} || exit 1 ;\
		make \
	)

##

${NTI_YAVTA_BUILT}: ${NTI_YAVTA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_YAVTA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${CUI_YAVTA_INSTALLED}: ${CUI_YAVTA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_YAVTA_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
	)

.PHONY: cui-yavta
cui-yavta: \
	${CUI_YAVTA_INSTALLED}

ALL_CUI_TARGETS+= \
	cui-yavta

##

${NTI_YAVTA_INSTALLED}: ${NTI_YAVTA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_YAVTA_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
	)

.PHONY: nti-yavta
nti-yavta: \
	${NTI_YAVTA_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-yavta

endif	# HAVE_YAVTA_CONFIG
