# alsa-driver v1.0.25		[ EARLIEST v?.??, ????-??-?? ]
# last mod WmT, 2013-07-27	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_ALSA_LIB_CONFIG},y)
HAVE_ALSA_LIB_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-alsa-driver' -- alsa-driver"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${ALSA_LIB_VERSION},)
#ALSA_LIB_VERSION=1.0.13
ALSA_LIB_VERSION=1.0.25
endif
ALSA_LIB_SRC=${SOURCES}/a/alsa-driver-${ALSA_LIB_VERSION}.tar.bz2

URLS+= ftp://ftp.alsa-project.org/pub/lib/alsa-driver-${ALSA_LIB_VERSION}.tar.bz2

NTI_ALSA_LIB_TEMP=nti-alsa-driver-${ALSA_LIB_VERSION}

NTI_ALSA_LIB_EXTRACTED=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/configure.in
NTI_ALSA_LIB_CONFIGURED=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/config.log
NTI_ALSA_LIB_BUILT=${EXTTEMP}/${NTI_ALSA_LIB_TEMP}/modules.order
NTI_ALSA_LIB_INSTALLED=${NTI_TC_ROOT}/usr/include/sound/asound.h


## ,-----
## |	Extract
## +-----

${NTI_ALSA_LIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-driver-${ALSA_LIB_VERSION} ] || rm -rf ${EXTTEMP}/alsa-driver-${ALSA_LIB_VERSION}
	bzcat ${ALSA_LIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSA_LIB_TEMP}
	mv ${EXTTEMP}/alsa-driver-${ALSA_LIB_VERSION} ${EXTTEMP}/${NTI_ALSA_LIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ALSA_LIB_CONFIGURED}: ${NTI_ALSA_LIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-cards=hda-intel \
			--with-oss=yes \
			--with-sequencer=yes \
			--with-isapnp=no \
			--with-moddir=${NTI_TC_ROOT}/lib/modules \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/install -m/	s/-[og] .(I[A-Z]*)//g' \
			| sed '/install:/	s/install-scripts//' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSA_LIB_BUILT}: ${NTI_ALSA_LIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ALSA_LIB_INSTALLED}: ${NTI_ALSA_LIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_LIB_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-alsa-lib
nti-alsa-driver: ${NTI_ALSA_LIB_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-driver

endif	# HAVE_ALSA_LIB_CONFIG
