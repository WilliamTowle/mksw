# pulseaudio v8.0		[ EARLIEST v8.0, c.2016-03-30 ]
# last mod WmT, 2016-03-30	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_PULSEAUDIO_CONFIG},y)
HAVE_PULSEAUDIO_CONFIG:=y

#DESCRLIST+= "'nti-pulseaudio' -- pulseaudio"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${PULSEAUDIO_VERSION},)
PULSEAUDIO_VERSION=8.0
endif

PULSEAUDIO_SRC=${SOURCES}/p/pulseaudio-${PULSEAUDIO_VERSION}.tar.xz
URLS+= http://freedesktop.org/software/pulseaudio/releases/pulseaudio-8.0.tar.xz

include ${CFG_ROOT}/misc/intltool/v0.40.6.mak
include ${CFG_ROOT}/misc/json-c/v0.12.1.mak
include ${CFG_ROOT}/audvid/libsndfile/v1.0.27.mak
#include ${CFG_ROOT}/audvid/libpulseaudio/v3.3.6.mak


NTI_PULSEAUDIO_TEMP=nti-pulseaudio-${PULSEAUDIO_VERSION}

NTI_PULSEAUDIO_EXTRACTED=${EXTTEMP}/${NTI_PULSEAUDIO_TEMP}/configure
NTI_PULSEAUDIO_CONFIGURED=${EXTTEMP}/${NTI_PULSEAUDIO_TEMP}/Makefile
NTI_PULSEAUDIO_BUILT=${EXTTEMP}/${NTI_PULSEAUDIO_TEMP}/src/pulseaudio
NTI_PULSEAUDIO_INSTALLED=${NTI_TC_ROOT}/usr/bin/pulseaudio


## ,-----
## |	Extract
## +-----

${NTI_PULSEAUDIO_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pulseaudio-${PULSEAUDIO_VERSION} ] || rm -rf ${EXTTEMP}/pulseaudio-${PULSEAUDIO_VERSION}
	xzcat ${PULSEAUDIO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP}
	mv ${EXTTEMP}/pulseaudio-${PULSEAUDIO_VERSION} ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PULSEAUDIO_CONFIGURED}: ${NTI_PULSEAUDIO_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP} || exit 1 ;\
		for MF in Makefile.in ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^pkgconfigdir/	s%$$(libdir)%$$(prefix)/'${HOSTSPEC}'/lib%' \
				> $${MF} ;\
		done ;\
	  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--without-caps \
			|| exit 1 \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Build
## +-----

${NTI_PULSEAUDIO_BUILT}: ${NTI_PULSEAUDIO_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_PULSEAUDIO_INSTALLED}: ${NTI_PULSEAUDIO_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PULSEAUDIO_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-pulseaudio
nti-pulseaudio: nti-pkg-config \
	nti-intltool nti-json-c nti-libsndfile \
	${NTI_PULSEAUDIO_INSTALLED}

ALL_NTI_TARGETS+= nti-pulseaudio

endif	# HAVE_PULSEAUDIO_CONFIG
