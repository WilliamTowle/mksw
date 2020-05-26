# libpcap v1.7.4		[ since v1.7.4, c.2016-08-16 ]
# last mod WmT, 2016-08-16	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_LIBPCAP_CONFIG},y)
HAVE_LIBPCAP_CONFIG:=y

#DESCRLIST+= "'nti-libpcap' -- libpcap"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${LIBPCAP_VERSION},)
LIBPCAP_VERSION=1.7.4
endif

LIBPCAP_SRC=${SOURCES}/l/libpcap-${LIBPCAP_VERSION}.tar.gz
URLS+= http://www.tcpdump.org/release/libpcap-${LIBPCAP_VERSION}.tar.gz

#include ${CFG_ROOT}/buildtools/bison/v2.4.1.mak
include ${CFG_ROOT}/buildtools/bison/v2.5.1.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_LIBPCAP_TEMP=nti-libpcap-${LIBPCAP_VERSION}

NTI_LIBPCAP_EXTRACTED=${EXTTEMP}/${NTI_LIBPCAP_TEMP}/configure
NTI_LIBPCAP_CONFIGURED=${EXTTEMP}/${NTI_LIBPCAP_TEMP}/config.status
NTI_LIBPCAP_BUILT=${EXTTEMP}/${NTI_LIBPCAP_TEMP}/libpcap.so.${LIBPCAP_VERSION}
NTI_LIBPCAP_INSTALLED=${NTI_TC_ROOT}/usr/lib/libpcap.so.${LIBPCAP_VERSION}


## ,-----
## |	Extract
## +-----

${NTI_LIBPCAP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libpcap-${LIBPCAP_VERSION} ] || rm -rf ${EXTTEMP}/libpcap-${LIBPCAP_VERSION}
	zcat ${LIBPCAP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPCAP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPCAP_TEMP}
	mv ${EXTTEMP}/libpcap-${LIBPCAP_VERSION} ${EXTTEMP}/${NTI_LIBPCAP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBPCAP_CONFIGURED}: ${NTI_LIBPCAP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBPCAP_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			--disable-cli \
			|| exit 1 \
	)
# cross-compilation needs:
#	PKG_CONFIG=${CUI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
#	--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_LIBPCAP_BUILT}: ${NTI_LIBPCAP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBPCAP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBPCAP_INSTALLED}: ${NTI_LIBPCAP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBPCAP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libpcap
nti-libpcap: nti-bison nti-flex \
	${NTI_LIBPCAP_INSTALLED}

ALL_NTI_TARGETS+= nti-libpcap

endif	# HAVE_LIBPCAP_CONFIG
