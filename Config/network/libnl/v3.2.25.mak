# libnl v3.2.25			[ since v1.8.2, c.2003-06-07 ]
# last mod WmT, 2016-02-15	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_LIBNL_CONFIG},y)
HAVE_LIBNL_CONFIG:=y

#DESCRLIST+= "'nti-libnl' -- libnl"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${LIBNL_VERSION},)
#LIBNL_VERSION=3.2.24
LIBNL_VERSION=3.2.25
endif

LIBNL_SRC=${SOURCES}/l/libnl-${LIBNL_VERSION}.tar.gz
URLS+= http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-${LIBNL_VERSION}.tar.gz

#include ${CFG_ROOT}/buildtools/bison/v2.4.1.mak
include ${CFG_ROOT}/buildtools/bison/v2.5.1.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_LIBNL_TEMP=nti-libnl-${LIBNL_VERSION}

NTI_LIBNL_EXTRACTED=${EXTTEMP}/${NTI_LIBNL_TEMP}/configure
NTI_LIBNL_CONFIGURED=${EXTTEMP}/${NTI_LIBNL_TEMP}/config.status
NTI_LIBNL_BUILT=${EXTTEMP}/${NTI_LIBNL_TEMP}/lib/netfilter
NTI_LIBNL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libnl-3.0.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBNL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libnl-${LIBNL_VERSION} ] || rm -rf ${EXTTEMP}/libnl-${LIBNL_VERSION}
	zcat ${LIBNL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBNL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBNL_TEMP}
	mv ${EXTTEMP}/libnl-${LIBNL_VERSION} ${EXTTEMP}/${NTI_LIBNL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBNL_CONFIGURED}: ${NTI_LIBNL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBNL_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			--disable-cli \
			|| exit 1 \
	)
# cross-compilation needs:
#	PKG_CONFIG=${CUI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config \
#	--with-pkgconfigdir=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_LIBNL_BUILT}: ${NTI_LIBNL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBNL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBNL_INSTALLED}: ${NTI_LIBNL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBNL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libnl
nti-libnl: nti-bison nti-flex \
	${NTI_LIBNL_INSTALLED}

ALL_NTI_TARGETS+= nti-libnl

endif	# HAVE_LIBNL_CONFIG
