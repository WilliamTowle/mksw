# alsaplayer v0.99.81		[ EARLIEST v?.??, ????-??-?? ]
# last mod WmT, 2013-07-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_ALSAPLAYER_CONFIG},y)
HAVE_ALSAPLAYER_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-alsaplayer' -- alsaplayer"

include ${CFG_ROOT}/audvid/alsa-lib/v1.0.25.mak

ifeq (${ALSAPLAYER_VERSION},)
ALSAPLAYER_VERSION=0.99.81
endif
ALSAPLAYER_SRC=${SOURCES}/a/alsaplayer-${ALSAPLAYER_VERSION}.tar.bz2

URLS+= http://www.alsaplayer.org/alsaplayer-0.99.81.tar.bz2

NTI_ALSAPLAYER_TEMP=nti-alsaplayer-${ALSAPLAYER_VERSION}

NTI_ALSAPLAYER_EXTRACTED=${EXTTEMP}/${NTI_ALSAPLAYER_TEMP}/Makefile
NTI_ALSAPLAYER_CONFIGURED=${EXTTEMP}/${NTI_ALSAPLAYER_TEMP}/config.log
NTI_ALSAPLAYER_BUILT=${EXTTEMP}/${NTI_ALSAPLAYER_TEMP}/app/alsaplayer
NTI_ALSAPLAYER_INSTALLED=${NTI_TC_ROOT}/usr/bin/alsaplayer


## ,-----
## |	Extract
## +-----

${NTI_ALSAPLAYER_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsaplayer-${ALSAPLAYER_VERSION} ] || rm -rf ${EXTTEMP}/alsaplayer-${ALSAPLAYER_VERSION}
	bzcat ${ALSAPLAYER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP}
	mv ${EXTTEMP}/alsaplayer-${ALSAPLAYER_VERSION} ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ALSAPLAYER_CONFIGURED}: ${NTI_ALSAPLAYER_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSAPLAYER_BUILT}: ${NTI_ALSAPLAYER_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ALSAPLAYER_INSTALLED}: ${NTI_ALSAPLAYER_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSAPLAYER_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-alsaplayer
nti-alsaplayer: ${NTI_ALSAPLAYER_INSTALLED}

ALL_NTI_TARGETS+= nti-alsaplayer

endif	# HAVE_ALSAPLAYER_CONFIG
