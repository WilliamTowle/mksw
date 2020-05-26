# cmospwd v5.0			[ since v4.3, c. 2004-01-08 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_CMOSPWD_CONFIG},y)
HAVE_CMOSPWD_CONFIG:=y

#DESCRLIST+= "'nti-cmospwd' -- cmospwd"
#DESCRLIST+= "'cti-cmospwd' -- cmospwd"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#
#include ${CFG_ROOT}/gui/libXdmcp/v1.0.3.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.5.mak
##include ${CFG_ROOT}/gui/libXau/v1.0.6.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
##include ${CFG_ROOT}/gui/libXt/v1.0.9.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
##include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.0.mak
##include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.1.mak
#include ${CFG_ROOT}/gui/x11proto-input/v2.0.mak
##include ${CFG_ROOT}/gui/x11proto-input/v2.0.1.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.4.mak
##include ${CFG_ROOT}/gui/x11proto-kb/v1.0.5.mak
#include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.0.mak
##include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.1.mak

ifeq (${CMOSPWD_VERSION},)
CMOSPWD_VERSION=5.0
endif

CMOSPWD_SRC=${SOURCES}/c/cmospwd-${CMOSPWD_VERSION}.tar.bz2
URLS+= http://www.cgsecurity.org/cmospwd-5.0.tar.bz2

NTI_CMOSPWD_TEMP=nti-cmospwd-${CMOSPWD_VERSION}

NTI_CMOSPWD_EXTRACTED=${EXTTEMP}/${NTI_CMOSPWD_TEMP}/cmospwd.txt
NTI_CMOSPWD_CONFIGURED=${EXTTEMP}/${NTI_CMOSPWD_TEMP}/src/Makefile
NTI_CMOSPWD_BUILT=${EXTTEMP}/${NTI_CMOSPWD_TEMP}/src/cmospwd
NTI_CMOSPWD_INSTALLED=${NTI_TC_ROOT}/usr/bin/cmospwd


## ,-----
## |	Extract
## +-----

${NTI_CMOSPWD_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cmospwd-${CMOSPWD_VERSION} ] || rm -rf ${EXTTEMP}/cmospwd-${CMOSPWD_VERSION}
	bzcat ${CMOSPWD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CMOSPWD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CMOSPWD_TEMP}
	mv ${EXTTEMP}/cmospwd-${CMOSPWD_VERSION} ${EXTTEMP}/${NTI_CMOSPWD_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CMOSPWD_CONFIGURED}: ${NTI_CMOSPWD_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CMOSPWD_TEMP} || exit 1 ;\
		[ -r ${NTI_CMOSPWD_BUILT} ] && rm -f ${NTI_CMOSPWD_BUILT} ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CC[ 	]/		s%g*cc%'${NUI_GCC}'%' \
			> src/Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_CMOSPWD_BUILT}: ${NTI_CMOSPWD_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CMOSPWD_TEMP} || exit 1 ;\
		make -C src cmospwd \
	)


## ,-----
## |	Install
## +-----

${NTI_CMOSPWD_INSTALLED}: ${NTI_CMOSPWD_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CMOSPWD_TEMP} || exit 1 ;\
		mkdir -p `dirname ${NTI_CMOSPWD_INSTALLED}` ;\
		cp  ${NTI_CMOSPWD_BUILT} ${NTI_CMOSPWD_INSTALLED} \
	)

.PHONY: nti-cmospwd
nti-cmospwd: ${NTI_CMOSPWD_INSTALLED}

ALL_NTI_TARGETS+= nti-cmospwd

endif	# HAVE_CMOSPWD_CONFIG
