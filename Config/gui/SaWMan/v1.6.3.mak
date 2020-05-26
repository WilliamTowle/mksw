# SaWMan v1.6.3	[ EARLIEST v1.6.3, c.2017-03-27 ]
# last mod WmT, 2017-04-05	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SAWMAN_CONFIG},y)
HAVE_SAWMAN_CONFIG:=y

#DESCRLIST+= "'nti-SaWMan' -- SaWMan

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak


ifeq (${SAWMAN_VERSION},)
SAWMAN_VERSION=1.6.3
endif

SAWMAN_SRC=${SOURCES}/s/SaWMan-${SAWMAN_VERSION}.tar.gz
URLS+= http://www.directfb.net/downloads/Extras/SaWMan-${SAWMAN_VERSION}.tar.gz


#include ${CFG_ROOT}/gui/DirectFB/v1.6.3.mak
#include ${CFG_ROOT}/gui/DirectFB-SDL/v1.6.3.mak
#include ${CFG_ROOT}/gui/DirectFB/v1.6.3--sdl.mak
include ${CFG_ROOT}/gui/DirectFB/v1.7.6--nofb.mak

NTI_SAWMAN_TEMP=nti-SaWMan-${SAWMAN_VERSION}

NTI_SAWMAN_EXTRACTED=${EXTTEMP}/${NTI_SAWMAN_TEMP}/configure
NTI_SAWMAN_CONFIGURED=${EXTTEMP}/${NTI_SAWMAN_TEMP}/config.log
NTI_SAWMAN_BUILT=${EXTTEMP}/${NTI_SAWMAN_TEMP}/src/libsawman.la
NTI_SAWMAN_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sawman.pc


## ,-----
## |	Extract
## +-----

${NTI_SAWMAN_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SaWMan-${SAWMAN_VERSION} ] || rm -rf ${EXTTEMP}/SaWMan-${SAWMANFB_VERSION}
	zcat ${SAWMAN_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SAWMAN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SAWMAN_TEMP}
	mv ${EXTTEMP}/SaWMan-${SAWMAN_VERSION} ${EXTTEMP}/${NTI_SAWMAN_TEMP}


## ,-----
## |	Configure
## +-----

## df_stereo3d requires SaWMan(not dependency-checked)
## hbOS: 'configure' reports "libz not found" despite ZLIB_LIBS setting?
## [v1.7.0] doesn't '--disable-zlib'

${NTI_SAWMAN_CONFIGURED}: ${NTI_SAWMAN_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SAWMAN_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SAWMAN_BUILT}: ${NTI_SAWMAN_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SAWMAN_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SAWMAN_INSTALLED}: ${NTI_SAWMAN_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SAWMAN_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-SaWMan
nti-SaWMan: nti-libtool nti-pkg-config \
	${NTI_SAWMAN_INSTALLED}

ALL_NTI_TARGETS+= nti-SaWMan

endif	# HAVE_SAWMAN_CONFIG
