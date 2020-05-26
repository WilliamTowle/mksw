# open-avb v'master'		[ since v?.?, c.2016-08-17 ]
# last mod WmT, 2016-08-17	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_OPEN_AVB_CONFIG},y)
HAVE_OPEN_AVB_CONFIG:=y

#DESCRLIST+= "'nti-open-avb' -- open-avb"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${OPEN_AVB_VERSION},)
OPEN_AVB_VERSION=master
endif

OPEN_AVB_SRC=${SOURCES}/o/Open-AVB-${OPEN_AVB_VERSION}.zip
URLS+= https://SERVER/PATH/Open-AVB-${OPEN_AVB_VERSION}.zip

##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/tools/unzip/v60.mak

include ${CFG_ROOT}/hwtools/pciutils/v3.3.1.mak
include ${CFG_ROOT}/network/libpcap/v1.7.4.mak


NTI_OPEN_AVB_TEMP=nti-open-avb-${OPEN_AVB_VERSION}

NTI_OPEN_AVB_EXTRACTED=${EXTTEMP}/${NTI_OPEN_AVB_TEMP}/Makefile
NTI_OPEN_AVB_CONFIGURED=${EXTTEMP}/${NTI_OPEN_AVB_TEMP}/Makefile.OLD
NTI_OPEN_AVB_BUILT=${EXTTEMP}/${NTI_OPEN_AVB_TEMP}/QUX
NTI_OPEN_AVB_INSTALLED=${NTI_TC_ROOT}/usr/bin/QUX


## ,-----
## |	Extract
## +-----

${NTI_OPEN_AVB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/Open-AVB-${OPEN_AVB_VERSION} ] || rm -rf ${EXTTEMP}/Open-AVB-${OPEN_AVB_VERSION}
	#bzcat ${OPEN_AVB_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${OPEN_AVB_SRC} -d ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPEN_AVB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPEN_AVB_TEMP}
	mv ${EXTTEMP}/Open-AVB-${OPEN_AVB_VERSION} ${EXTTEMP}/${NTI_OPEN_AVB_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_OPEN_AVB_CONFIGURED}: ${NTI_OPEN_AVB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPEN_AVB_TEMP} || exit 1 ;\
		touch ${NTI_OPEN_AVB_CONFIGURED} \
	)
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		(	echo 'CC=gcc' ;\
#			echo 'CFLAGS='`${NTI_TC_ROOT}/usr/bin/pcap-config --cflags` ;\
#			echo 'LDFLAGS='`${NTI_TC_ROOT}/usr/bin/pcap-config --ldflags` ;\
#			echo 'LIBS='`${NTI_TC_ROOT}/usr/bin/pcap-config --libs` ;\
#			cat Makefile.OLD \
#		) > Makefile ;\


## ,-----
## |	Build
## +-----

${NTI_OPEN_AVB_BUILT}: ${NTI_OPEN_AVB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPEN_AVB_TEMP} || exit 1 ;\
		make \
			daemons_all \
				CC=gcc \
				CFLAGS=`${NTI_TC_ROOT}/usr/bin/pcap-config --cflags` \
				FLAGS='-lpthread '`${NTI_TC_ROOT}/usr/bin/pcap-config --ldflags` \
				LIBS=`${NTI_TC_ROOT}/usr/bin/pcap-config --libs` \
	)
# TODO: wants pci/pci.h for all remaining targets:
#			avtp_pipeline avtp_pipline_doc \
#			simple_talker simple_listener \


## ,-----
## |	Install
## +-----

${NTI_OPEN_AVB_INSTALLED}: ${NTI_OPEN_AVB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPEN_AVB_TEMP} || exit 1 ;\
		echo '...' ;\
		make install \
	)

##

.PHONY: nti-open-avb
nti-open-avb: nti-unzip \
	nti-libpcap nti-pciutils \
	${NTI_OPEN_AVB_INSTALLED}

ALL_NTI_TARGETS+= nti-open-avb

endif	# HAVE_OPEN_AVB_CONFIG
