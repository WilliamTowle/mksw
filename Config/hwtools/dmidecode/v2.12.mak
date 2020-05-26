# dmidecode v2.12		[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_DMIDECODE_CONFIG},y)
HAVE_DMIDECODE_CONFIG:=y

#DESCRLIST+= "'nti-dmidecode' -- dmidecode"
#DESCRLIST+= "'cti-dmidecode' -- dmidecode"

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

ifeq (${DMIDECODE_VERSION},)
#DMIDECODE_VERSION=2.11
DMIDECODE_VERSION=2.12
endif

DMIDECODE_SRC=${SOURCES}/d/dmidecode-${DMIDECODE_VERSION}.tar.bz2
URLS+= http://download.savannah.gnu.org/releases/dmidecode/dmidecode-2.11.tar.bz2

NTI_DMIDECODE_TEMP=nti-dmidecode-${DMIDECODE_VERSION}

NTI_DMIDECODE_EXTRACTED=${EXTTEMP}/${NTI_DMIDECODE_TEMP}/README
NTI_DMIDECODE_CONFIGURED=${EXTTEMP}/${NTI_DMIDECODE_TEMP}/Makefile.OLD
NTI_DMIDECODE_BUILT=${EXTTEMP}/${NTI_DMIDECODE_TEMP}/biosdecode
NTI_DMIDECODE_INSTALLED=${NTI_TC_ROOT}/usr/sbin/biosdecode


## ,-----
## |	Extract
## +-----

${NTI_DMIDECODE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/dmidecode-${DMIDECODE_VERSION} ] || rm -rf ${EXTTEMP}/dmidecode-${DMIDECODE_VERSION}
	bzcat ${DMIDECODE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DMIDECODE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DMIDECODE_TEMP}
	mv ${EXTTEMP}/dmidecode-${DMIDECODE_VERSION} ${EXTTEMP}/${NTI_DMIDECODE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DMIDECODE_CONFIGURED}: ${NTI_DMIDECODE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DMIDECODE_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[ 	]/		{ s/?// ; s%g*cc%'${NUI_CC_PREFIX}'cc% }' \
			| sed '/^prefix[ 	]/	{ s%/local%% ; s%/usr%'${NTI_TC_ROOT}'/usr% }' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DMIDECODE_BUILT}: ${NTI_DMIDECODE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DMIDECODE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DMIDECODE_INSTALLED}: ${NTI_DMIDECODE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DMIDECODE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-dmidecode
nti-dmidecode: ${NTI_DMIDECODE_INSTALLED}

ALL_NTI_TARGETS+= nti-dmidecode

endif	# HAVE_DMIDECODE_CONFIG
