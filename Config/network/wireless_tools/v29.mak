# wireless_tools v29		[ since v29, c.2014-04-14 ]
# last mod WmT, 2014-04-14	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_WIRELESS_TOOLS_CONFIG},y)
HAVE_WIRELESS_TOOLS_CONFIG:=y

#DESCRLIST+= "'nti-wireless_tools' -- wireless_tools"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${WIRELESS_TOOLS_VERSION},)
WIRELESS_TOOLS_VERSION=29
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#
#include ${CFG_ROOT}/network/openssl/v1.0.2a.mak
#include ${CFG_ROOT}/network/libnl/v3.2.24.mak

WIRELESS_TOOLS_SRC=${SOURCES}/w/wireless_tools.${WIRELESS_TOOLS_VERSION}.tar.gz
URLS+= http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz

NTI_WIRELESS_TOOLS_TEMP=nti-wireless_tools-${WIRELESS_TOOLS_VERSION}

NTI_WIRELESS_TOOLS_EXTRACTED=${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}/README
NTI_WIRELESS_TOOLS_CONFIGURED=${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}/Makefile
NTI_WIRELESS_TOOLS_BUILT=${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}/iwlist
NTI_WIRELESS_TOOLS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/iwlist


## ,-----
## |	Extract
## +-----

${NTI_WIRELESS_TOOLS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/wireless_tools-${WIRELESS_TOOLS_VERSION} ] || rm -rf ${EXTTEMP}/wireless_tools-${WIRELESS_TOOLS_VERSION}
	[ ! -d ${EXTTEMP}/wireless_tools.${WIRELESS_TOOLS_VERSION} ] || rm -rf ${EXTTEMP}/wireless_tools.${WIRELESS_TOOLS_VERSION}
	zcat ${WIRELESS_TOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}
	#mv ${EXTTEMP}/wireless_tools-${WIRELESS_TOOLS_VERSION} ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}
	mv ${EXTTEMP}/wireless_tools.${WIRELESS_TOOLS_VERSION} ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_WIRELESS_TOOLS_CONFIGURED}: ${NTI_WIRELESS_TOOLS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/PREFIX *=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)
#	TODO: adapt 'AR', 'RANLIB' (...example?)

## ,-----
## |	Build
## +-----

${NTI_WIRELESS_TOOLS_BUILT}: ${NTI_WIRELESS_TOOLS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_WIRELESS_TOOLS_INSTALLED}: ${NTI_WIRELESS_TOOLS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRELESS_TOOLS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-wireless_tools
nti-wireless_tools: ${NTI_WIRELESS_TOOLS_INSTALLED}
#nti-wireless_tools: nti-pkg-config \
#		nti-libnl nti-openssl ${NTI_WIRELESS_TOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-wireless_tools

endif	# HAVE_WIRELESS_TOOLS_CONFIG
