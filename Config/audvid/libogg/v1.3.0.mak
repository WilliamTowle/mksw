# libogg v1.3.0			[ since v1.0, c.2003-07-04 ]
# last mod WmT, 2013-05-05	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBOGG_CONFIG},y)
HAVE_LIBOGG_CONFIG:=y

#DESCRLIST+= "'nti-libogg' -- libogg"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBOGG_VERSION},)
LIBOGG_VERSION=1.3.0
endif

LIBOGG_SRC=${SOURCES}/l/libogg-${LIBOGG_VERSION}.tar.gz
URLS+= http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


NTI_LIBOGG_TEMP=nti-libogg-${LIBOGG_VERSION}

NTI_LIBOGG_EXTRACTED=${EXTTEMP}/${NTI_LIBOGG_TEMP}/README
NTI_LIBOGG_CONFIGURED=${EXTTEMP}/${NTI_LIBOGG_TEMP}/config.status
NTI_LIBOGG_BUILT=${EXTTEMP}/${NTI_LIBOGG_TEMP}/src/libogg.la
NTI_LIBOGG_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ogg.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBOGG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libogg-${LIBOGG_VERSION} ] || rm -rf ${EXTTEMP}/libogg-${LIBOGG_VERSION}
	zcat ${LIBOGG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBOGG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBOGG_TEMP}
	mv ${EXTTEMP}/libogg-${LIBOGG_VERSION} ${EXTTEMP}/${NTI_LIBOGG_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBOGG_CONFIGURED}: ${NTI_LIBOGG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBOGG_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBOGG_BUILT}: ${NTI_LIBOGG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBOGG_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBOGG_INSTALLED}: ${NTI_LIBOGG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBOGG_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool ;\
		mkdir -p `dirname ${NTI_LIBOGG_INSTALLED}` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/ogg.pc ${NTI_LIBOGG_INSTALLED} \
	)

##

.PHONY: nti-libogg
nti-libogg: nti-libtool ${NTI_LIBOGG_INSTALLED}

ALL_NTI_TARGETS+= nti-libogg

endif	# HAVE_LIBOGG_CONFIG
