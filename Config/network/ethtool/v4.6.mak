# ethtool v4.6			[ since v2.6.39, c.2011-06-29 ]
# last mod WmT, 2016-08-16	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_ETHTOOL_CONFIG},y)
HAVE_ETHTOOL_CONFIG:=y

#DESCRLIST+= "'nti-ethtool' -- ethtool"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ETHTOOL_VERSION},)
ETHTOOL_VERSION=4.6
endif

ETHTOOL_SRC=${SOURCES}/e/ethtool-${ETHTOOL_VERSION}.tar.gz
URLS+= http://www.kernel.org/pub/software/network/ethtool/ethtool-${ETHTOOL_VERSION}.tar.gz

##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak


NTI_ETHTOOL_TEMP=nti-ethtool-${ETHTOOL_VERSION}

NTI_ETHTOOL_EXTRACTED=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/autogen.sh
NTI_ETHTOOL_CONFIGURED=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/config.log
NTI_ETHTOOL_BUILT=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/ethtool
NTI_ETHTOOL_INSTALLED=${NTI_TC_ROOT}/usr/sbin/ethtool


## ,-----
## |	Extract
## +-----

${NTI_ETHTOOL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/lha-${ETHTOOL_VERSION} ] || rm -rf ${EXTTEMP}/lha-${ETHTOOL_VERSION}
	#[ ! -d ${EXTTEMP}/ethtool-0.2.0+git3fe46 lha-${ETHTOOL_VERSION} ] || rm -rf ${EXTTEMP}/ethtool-0.2.0+git3fe46
	[ ! -d ${EXTTEMP}/ethtool-${ETHTOOL_VERSION} ] || rm -rf ${EXTTEMP}/ethtool-${ETHTOOL_VERSION}
	zcat ${ETHTOOL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ETHTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ETHTOOL_TEMP}
	#mv ${EXTTEMP}/lha-${ETHTOOL_VERSION} ${EXTTEMP}/${NTI_ETHTOOL_TEMP}
	#mv ${EXTTEMP}/ethtool-0.2.0+git3fe46 ${EXTTEMP}/${NTI_ETHTOOL_TEMP}
	mv ${EXTTEMP}/ethtool-${ETHTOOL_VERSION} ${EXTTEMP}/${NTI_ETHTOOL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ETHTOOL_CONFIGURED}: ${NTI_ETHTOOL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ETHTOOL_BUILT}: ${NTI_ETHTOOL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ETHTOOL_INSTALLED}: ${NTI_ETHTOOL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ethtool
#nti-ethtool: nti-autoconf nti-automake nti-libtool \
#	${NTI_ETHTOOL_INSTALLED}
nti-ethtool: \
	${NTI_ETHTOOL_INSTALLED}

ALL_NTI_TARGETS+= nti-ethtool

endif	# HAVE_ETHTOOL_CONFIG
