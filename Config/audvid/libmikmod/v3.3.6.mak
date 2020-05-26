# libmikmod v3.3.6		[ since v3.1.10, c.2014-01-18 ]
# last mod WmT, 2014-06-19	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBMIKMOD_CONFIG},y)
HAVE_LIBMIKMOD_CONFIG:=y

#DESCRLIST+= "'nti-libmikmod' -- libmikmod"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBMIKMOD_VERSION},)
#LIBMIKMOD_VERSION=3.1.10
#LIBMIKMOD_VERSION=3.3.5
LIBMIKMOD_VERSION=3.3.6
endif

LIBMIKMOD_SRC=${SOURCES}/l/libmikmod-${LIBMIKMOD_VERSION}.tar.gz
#URLS+= http://downloads.xiph.org/releases/mikmod/libmikmod-${LIBMIKMOD_VERSION}.tar.gz
URLS+= 'http://sourceforge.net/project/downloading.php?group_id=40531&filename=libmikmod-3.3.6.tar.gz'

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


NTI_LIBMIKMOD_TEMP=nti-libmikmod-${LIBMIKMOD_VERSION}

NTI_LIBMIKMOD_EXTRACTED=${EXTTEMP}/${NTI_LIBMIKMOD_TEMP}/README
NTI_LIBMIKMOD_CONFIGURED=${EXTTEMP}/${NTI_LIBMIKMOD_TEMP}/config.status
NTI_LIBMIKMOD_BUILT=${EXTTEMP}/${NTI_LIBMIKMOD_TEMP}/libmikmod.la
NTI_LIBMIKMOD_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libmikmod.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBMIKMOD_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libmikmod-${LIBMIKMOD_VERSION} ] || rm -rf ${EXTTEMP}/libmikmod-${LIBMIKMOD_VERSION}
	zcat ${LIBMIKMOD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP}
	mv ${EXTTEMP}/libmikmod-${LIBMIKMOD_VERSION} ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBMIKMOD_CONFIGURED}: ${NTI_LIBMIKMOD_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBMIKMOD_BUILT}: ${NTI_LIBMIKMOD_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBMIKMOD_INSTALLED}: ${NTI_LIBMIKMOD_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBMIKMOD_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		mkdir -p `dirname ${NTI_LIBMIKMOD_INSTALLED}` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/libmikmod.pc ${NTI_LIBMIKMOD_INSTALLED} \
	)

##

.PHONY: nti-libmikmod
nti-libmikmod: nti-libtool ${NTI_LIBMIKMOD_INSTALLED}

ALL_NTI_TARGETS+= nti-libmikmod

endif	# HAVE_LIBMIKMOD_CONFIG
