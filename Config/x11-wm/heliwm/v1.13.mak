# heliwm v1.13			[ since v1.13, 2017-10-31 ]
# last mod WmT, 2017-10-31	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_HELIWM_CONFIG},y)
HAVE_HELIWM_CONFIG:=y

#DESCRLIST+= "'nti-heliwm' -- heliwm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${HELIWM_VERSION},)
HELIWM_VERSION=1.13
endif

HELIWM_SRC=${SOURCES}/h/heliwm-${HELIWM_VERSION}.tar.gz
URLS+= http://www.cc.rim.or.jp/~hok/heliwm/heliwm-1.13.tar.gz


include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak

NTI_HELIWM_TEMP=nti-heliwm-${HELIWM_VERSION}
NTI_HELIWM_EXTRACTED=${EXTTEMP}/${NTI_HELIWM_TEMP}/configure
NTI_HELIWM_CONFIGURED=${EXTTEMP}/${NTI_HELIWM_TEMP}/config.log
NTI_HELIWM_BUILT=${EXTTEMP}/${NTI_HELIWM_TEMP}/wind
NTI_HELIWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/wind


# ,-----
# |	Extract
# +-----

${NTI_HELIWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/heliwm-${HELIWM_VERSION} ] || rm -rf ${EXTTEMP}/heliwm-${HELIWM_VERSION}
	#bzcat ${HELIWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${HELIWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_HELIWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_HELIWM_TEMP}
	mv ${EXTTEMP}/heliwm-${HELIWM_VERSION} ${EXTTEMP}/${NTI_HELIWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_HELIWM_CONFIGURED}: ${NTI_HELIWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_HELIWM_TEMP} || exit 1 ;\
		gcc *.c -DFRAME -DREORDER \
			`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags x11` \
			`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs x11` \
			-o heliwm-`date +%y%m%d-%H%M%S` || exit 1 ;\
		echo '...' ; exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
 	)


# ,-----
# |	Build
# +-----

${NTI_HELIWM_BUILT}: ${NTI_HELIWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_HELIWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_HELIWM_INSTALLED}: ${NTI_HELIWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_HELIWM_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-heliwm
nti-heliwm: \
	nti-pkg-config \
	nti-libX11 \
	${NTI_HELIWM_INSTALLED}

ALL_NTI_TARGETS+= nti-heliwm


endif	# HAVE_HELIWM_CONFIG
