# wireshark v2.1.1		[ since v4.6, c.2016-08-16 ]
# last mod WmT, 2016-08-16	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_WIRESHARK_CONFIG},y)
HAVE_WIRESHARK_CONFIG:=y

#DESCRLIST+= "'nti-wireshark' -- wireshark"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${WIRESHARK_VERSION},)
WIRESHARK_VERSION=2.1.1
endif

WIRESHARK_SRC=${SOURCES}/w/wireshark-${WIRESHARK_VERSION}.tar.bz2
URLS+= https://www.wireshark.org/download/src/wireshark-2.1.1.tar.bz2

##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak

include ${CFG_ROOT}/network/libpcap/v1.7.4.mak


NTI_WIRESHARK_TEMP=nti-wireshark-${WIRESHARK_VERSION}

NTI_WIRESHARK_EXTRACTED=${EXTTEMP}/${NTI_WIRESHARK_TEMP}/autogen.sh
NTI_WIRESHARK_CONFIGURED=${EXTTEMP}/${NTI_WIRESHARK_TEMP}/config.log
NTI_WIRESHARK_BUILT=${EXTTEMP}/${NTI_WIRESHARK_TEMP}/tshark
NTI_WIRESHARK_INSTALLED=${NTI_TC_ROOT}/usr/bin/tshark


## ,-----
## |	Extract
## +-----

${NTI_WIRESHARK_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/lha-${WIRESHARK_VERSION} ] || rm -rf ${EXTTEMP}/lha-${WIRESHARK_VERSION}
	#[ ! -d ${EXTTEMP}/wireshark-0.2.0+git3fe46 lha-${WIRESHARK_VERSION} ] || rm -rf ${EXTTEMP}/wireshark-0.2.0+git3fe46
	[ ! -d ${EXTTEMP}/wireshark-${WIRESHARK_VERSION} ] || rm -rf ${EXTTEMP}/wireshark-${WIRESHARK_VERSION}
	bzcat ${WIRESHARK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WIRESHARK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WIRESHARK_TEMP}
	#mv ${EXTTEMP}/lha-${WIRESHARK_VERSION} ${EXTTEMP}/${NTI_WIRESHARK_TEMP}
	#mv ${EXTTEMP}/wireshark-0.2.0+git3fe46 ${EXTTEMP}/${NTI_WIRESHARK_TEMP}
	mv ${EXTTEMP}/wireshark-${WIRESHARK_VERSION} ${EXTTEMP}/${NTI_WIRESHARK_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_WIRESHARK_CONFIGURED}: ${NTI_WIRESHARK_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRESHARK_TEMP} || exit 1 ;\
	  CFLAGS='-O2'' '`${NTI_TC_ROOT}/usr/bin/pcap-config --cflags`' -Wno-shadow' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-wireshark \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_WIRESHARK_BUILT}: ${NTI_WIRESHARK_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRESHARK_TEMP} || exit 1 ;\
		make WERROR='' \
	)


## ,-----
## |	Install
## +-----

${NTI_WIRESHARK_INSTALLED}: ${NTI_WIRESHARK_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_WIRESHARK_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-wireshark
#nti-wireshark: nti-autoconf nti-automake nti-libtool \
#	${NTI_WIRESHARK_INSTALLED}
nti-wireshark: \
	nti-libpcap \
	${NTI_WIRESHARK_INSTALLED}

ALL_NTI_TARGETS+= nti-wireshark

endif	# HAVE_WIRESHARK_CONFIG
