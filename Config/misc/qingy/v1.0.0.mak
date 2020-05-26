## qingy v1.0.0			[ since v0.9.9, c.2010-06-11 ]
# last mod WmT, 2017-04-12	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_QINGY_CONFIG},y)
HAVE_QINGY_CONFIG:=y

#DESCRLIST+= "'nti-qingy' -- qingy"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${QINGY_VERSION},)
QINGY_VERSION=1.0.0
endif

##include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
##|include ${CFG_ROOT}/buildtools/automake/v1.8.5.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
##include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#|include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

QINGY_SRC=${SOURCES}/q/qingy-${QINGY_VERSION}.tar.bz2
URLS+=http://downloads.sourceforge.net/project/qingy/qingy/qingy%20${QINGY_VERSION}/qingy-${QINGY_VERSION}.tar.bz2?use_mirror=freefr

#include ${CFG_ROOT}/gui/DirectFB/v1.6.3mak
include ${CFG_ROOT}/gui/DirectFB/v1.7.6--nofb.mak
#include ${CFG_ROOT}/network/openssl/v1.1.0e.mak

NTI_QINGY_TEMP=nti-qingy-${QINGY_VERSION}

NTI_QINGY_EXTRACTED=${EXTTEMP}/${NTI_QINGY_TEMP}/configure
NTI_QINGY_CONFIGURED=${EXTTEMP}/${NTI_QINGY_TEMP}/config.status
NTI_QINGY_BUILT=${EXTTEMP}/${NTI_QINGY_TEMP}/src/qingy
NTI_QINGY_INSTALLED=${NTI_TC_ROOT}/usr/bin/qingy


## ,-----
## |	Extract
## +-----

${NTI_QINGY_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/qingy-${QINGY_VERSION} ] || rm -rf ${EXTTEMP}/qingy-${QINGY_VERSION}
	bzcat ${QINGY_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${QINGY_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_QINGY_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_QINGY_TEMP}
	mv ${EXTTEMP}/qingy-${QINGY_VERSION} ${EXTTEMP}/${NTI_QINGY_TEMP}


## ,-----
## |	Configure
## +-----

NTI_QINGY_CONFIGURE_OPTS=
ifneq (${QINGY_WITH_GUI},true)
NTI_QINGY_CONFIGURE_OPTS+=  \
			--disable-x-support \
			--disable-screen-savers
endif

## [2017-04-12] --disable-optimizations - cannot '-march x86_64'

${NTI_QINGY_CONFIGURED}: ${NTI_QINGY_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_QINGY_TEMP} || exit 1 ;\
		CFLAGS='-O2 '"`${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags openssl`" \
		LDFLAGS="`${PKG_CONFIG_CONFIG_HOST_TOOL} --libs openssl`" \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-optimizations \
			--enable-crypto=none \
			${NTI_QINGY_CONFIGURE_OPTS} \
			|| exit 1 \
	)
#		CFLAGS='-O2 '"`${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags x11`" \
#		LDFLAGS="`${PKG_CONFIG_CONFIG_HOST_TOOL} --libs x11`" \


## ,-----
## |	Build
## +-----

${NTI_QINGY_BUILT}: ${NTI_QINGY_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_QINGY_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_QINGY_INSTALLED}: ${NTI_QINGY_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_QINGY_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-qingy
#nti-qingy: nti-pkg-config \
#	nti-openssl ${NTI_QINGY_INSTALLED}
nti-qingy: nti-pkg-config \
	nti-DirectFB ${NTI_QINGY_INSTALLED}

ALL_NTI_TARGETS+= nti-qingy

endif	# HAVE_QINGY_CONFIG
