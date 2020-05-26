# libvorbis v1.3.3		[ since v1.0, c.2003-07-04 ]
# last mod WmT, 2013-05-05	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBVORBIS_CONFIG},y)
HAVE_LIBVORBIS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-libvorbis' -- libvorbis"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${LIBVORBIS_VERSION},)
LIBVORBIS_VERSION=1.3.3
endif

LIBVORBIS_SRC=${SOURCES}/l/libvorbis-${LIBVORBIS_VERSION}.tar.gz
URLS+= http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.0.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/audvid/libogg/v1.3.0.mak

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
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		mkdir -p `dirname ${NTI_LIBVORBIS_INSTALLED}` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/vorbisfile.pc ${NTI_LIBVORBIS_INSTALLED} \
	)

##

.PHONY: nti-libvorbis
nti-libvorbis: nti-libtool nti-pkg-config nti-libogg ${NTI_LIBVORBIS_INSTALLED}

ALL_NTI_TARGETS+= nti-libvorbis

endif	# HAVE_LIBVORBIS_CONFIG

