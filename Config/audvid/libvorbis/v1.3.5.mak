# libvorbis v1.3.5		[ since v1.0, c.2003-07-04 ]
# last mod WmT, 2015-12-22	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_LIBVORBIS_CONFIG},y)
HAVE_LIBVORBIS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


#DESCRLIST+= "'nti-libvorbis' -- libvorbis"

ifeq (${LIBVORBIS_VERSION},)
LIBVORBIS_VERSION=1.3.3
#LIBVORBIS_VERSION=1.3.5
endif

LIBVORBIS_SRC=${SOURCES}/l/libvorbis-${LIBVORBIS_VERSION}.tar.gz
URLS+= http://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VERSION}.tar.gz

include ${CFG_ROOT}/audvid/libogg/v1.3.2.mak

NTI_LIBVORBIS_TEMP=nti-libvorbis-${LIBVORBIS_VERSION}

NTI_LIBVORBIS_EXTRACTED=${EXTTEMP}/${NTI_LIBVORBIS_TEMP}/README
NTI_LIBVORBIS_CONFIGURED=${EXTTEMP}/${NTI_LIBVORBIS_TEMP}/config.status
NTI_LIBVORBIS_BUILT=${EXTTEMP}/${NTI_LIBVORBIS_TEMP}/lib/libvorbisfile.la
NTI_LIBVORBIS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/vorbisfile.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBVORBIS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libvorbis-${LIBVORBIS_VERSION} ] || rm -rf ${EXTTEMP}/libvorbis-${LIBVORBIS_VERSION}
	zcat ${LIBVORBIS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBVORBIS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBVORBIS_TEMP}
	mv ${EXTTEMP}/libvorbis-${LIBVORBIS_VERSION} ${EXTTEMP}/${NTI_LIBVORBIS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBVORBIS_CONFIGURED}: ${NTI_LIBVORBIS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVORBIS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		LIBTOOL=${HOSTSPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBVORBIS_BUILT}: ${NTI_LIBVORBIS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVORBIS_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBVORBIS_INSTALLED}: ${NTI_LIBVORBIS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVORBIS_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-libvorbis
nti-libvorbis: nti-libtool nti-pkg-config \
	nti-libogg \
	${NTI_LIBVORBIS_INSTALLED}

ALL_NTI_TARGETS+= nti-libvorbis

endif	# HAVE_LIBVORBIS_CONFIG

