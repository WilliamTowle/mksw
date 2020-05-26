# libao v1.2.0			[ since v0.8.8, c.2013-01-06 ]
# last mod WmT, 2015-04-09	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_LIBAO_CONFIG},y)
HAVE_LIBAO_CONFIG:=y

#DESCRLIST+= "'nti-libao' -- libao"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${LIBAO_VERSION},)
#LIBAO_VERSION=1.1.0
LIBAO_VERSION=1.2.0
endif
LIBAO_SRC=${SOURCES}/l/libao-${LIBAO_VERSION}.tar.gz

URLS+= http://downloads.xiph.org/releases/ao/libao-${LIBAO_VERSION}.tar.gz

NTI_LIBAO_TEMP=nti-libao-${LIBAO_VERSION}

NTI_LIBAO_EXTRACTED=${EXTTEMP}/${NTI_LIBAO_TEMP}/README
NTI_LIBAO_CONFIGURED=${EXTTEMP}/${NTI_LIBAO_TEMP}/config.status
NTI_LIBAO_BUILT=${EXTTEMP}/${NTI_LIBAO_TEMP}/src/libao.la
NTI_LIBAO_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ao.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBAO_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libao-${LIBAO_VERSION} ] || rm -rf ${EXTTEMP}/libao-${LIBAO_VERSION}
	zcat ${LIBAO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBAO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBAO_TEMP}
	mv ${EXTTEMP}/libao-${LIBAO_VERSION} ${EXTTEMP}/${NTI_LIBAO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBAO_CONFIGURED}: ${NTI_LIBAO_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)

## ,-----
## |	Build
## +-----

${NTI_LIBAO_BUILT}: ${NTI_LIBAO_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBAO_INSTALLED}: ${NTI_LIBAO_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBAO_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/ao.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ \
	)

##

.PHONY: nti-libao
nti-libao: nti-libtool nti-pkg-config ${NTI_LIBAO_INSTALLED}

ALL_NTI_TARGETS+= nti-libao

endif	# HAVE_LIBAO_CONFIG
