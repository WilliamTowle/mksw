# amiwm v0.21pl2		[ since v0.21pl2, 2017-04-19 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_AMIWM_CONFIG},y)
HAVE_AMIWM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-amiwm' -- amiwm"

ifeq (${AMIWM_VERSION},)
AMIWM_VERSION=0.21pl2
endif

AMIWM_SRC=${SOURCES}/a/amiwm${AMIWM_VERSION}.tar.gz
URLS+= ftp://ftp.lysator.liu.se/pub/X11/wm/amiwm/amiwm0.21pl2.tar.gz

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

NTI_AMIWM_TEMP=nti-amiwm-${AMIWM_VERSION}
NTI_AMIWM_EXTRACTED=${EXTTEMP}/${NTI_AMIWM_TEMP}/configure
NTI_AMIWM_CONFIGURED=${EXTTEMP}/${NTI_AMIWM_TEMP}/config.log
NTI_AMIWM_BUILT=${EXTTEMP}/${NTI_AMIWM_TEMP}/amiwm
NTI_AMIWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/amiwm


# ,-----
# |	Extract
# +-----

${NTI_AMIWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/amiwm-${AMIWM_VERSION} ] || rm -rf ${EXTTEMP}/amiwm-${AMIWM_VERSION}
	[ ! -d ${EXTTEMP}/amiwm${AMIWM_VERSION} ] || rm -rf ${EXTTEMP}/amiwm${AMIWM_VERSION}
	#bzcat ${AMIWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${AMIWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AMIWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AMIWM_TEMP}
	#mv ${EXTTEMP}/amiwm-${AMIWM_VERSION} ${EXTTEMP}/${NTI_AMIWM_TEMP}
	mv ${EXTTEMP}/amiwm${AMIWM_VERSION} ${EXTTEMP}/${NTI_AMIWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_AMIWM_CONFIGURED}: ${NTI_AMIWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)


# ,-----
# |	Build
# +-----

${NTI_AMIWM_BUILT}: ${NTI_AMIWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_AMIWM_INSTALLED}: ${NTI_AMIWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_AMIWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-amiwm
#nti-amiwm: nti-libX11 nti-libxcb \
#	${NTI_AMIWM_INSTALLED}
nti-amiwm: \
	${NTI_AMIWM_INSTALLED}

ALL_NTI_TARGETS+= nti-amiwm

endif	# HAVE_AMIWM_CONFIG
