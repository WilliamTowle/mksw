# gphoto2 v2.5.10		[ since v2.5.10, c.2016-06-21 ]
# last mod WmT, 2016-06-21	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_GPHOTO2_CONFIG},y)
HAVE_GPHOTO2_CONFIG:=y

#DESCRLIST+= "'nti-gphoto2' -- gphoto2"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${GPHOTO2_VERSION},)
GPHOTO2_VERSION=2.5.10
endif

GPHOTO2_SRC=${SOURCES}/g/gphoto2-${GPHOTO2_VERSION}.tar.bz2
URLS+= http://prdownloads.sourceforge.net/project/gphoto/gphoto/2.5.10/gphoto2-${GPHOTO2_VERSION}.tar.bz2?download

include ${CFG_ROOT}/audvid/libgphoto2/v2.5.10.mak
include ${CFG_ROOT}/misc/libpopt/v1.16.mak

NTI_GPHOTO2_TEMP=nti-gphoto2-${GPHOTO2_VERSION}

NTI_GPHOTO2_EXTRACTED=${EXTTEMP}/${NTI_GPHOTO2_TEMP}/README
NTI_GPHOTO2_CONFIGURED=${EXTTEMP}/${NTI_GPHOTO2_TEMP}/config.log
NTI_GPHOTO2_BUILT=${EXTTEMP}/${NTI_GPHOTO2_TEMP}/gphoto.vers
#NTI_GPHOTO2_BUILT=${EXTTEMP}/${NTI_GPHOTO2_TEMP}/gphoto12-config
NTI_GPHOTO2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/gphoto.pc


## ,-----
## |	Extract
## +-----

${NTI_GPHOTO2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/gphoto2-${GPHOTO2_VERSION} ] || rm -rf ${EXTTEMP}/gphoto2-${GPHOTO2_VERSION}
	bzcat ${GPHOTO2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GPHOTO2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GPHOTO2_TEMP}
	mv ${EXTTEMP}/gphoto2-${GPHOTO2_VERSION} ${EXTTEMP}/${NTI_GPHOTO2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_GPHOTO2_CONFIGURED}: ${NTI_GPHOTO2_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPHOTO2_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  POPT_CFLAGS=`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags popt` \
		  POPT_LIBS=`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs popt` \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)
#		LIBTOOL=${HOSTSPEC}-libtool \
#		CPPFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
#		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \


## ,-----
## |	Build
## +-----

${NTI_GPHOTO2_BUILT}: ${NTI_GPHOTO2_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPHOTO2_TEMP} || exit 1 ;\
		make \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_GPHOTO2_INSTALLED}: ${NTI_GPHOTO2_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_GPHOTO2_TEMP} || exit 1 ;\
		make install \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-gphoto2
nti-gphoto2: nti-pkg-config \
		nti-libgphoto2 \
		nti-libpopt \
		${NTI_GPHOTO2_INSTALLED}
#nti-gphoto2: nti-zlib nti-pkg-config nti-libtool ${NTI_GPHOTO2_INSTALLED}

ALL_NTI_TARGETS+= nti-gphoto2

endif	# HAVE_GPHOTO2_CONFIG
