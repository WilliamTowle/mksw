# diffstat v1.59		[ since v1.47, c.2009-09-24 ]
# last mod WmT, 2014-06-11	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_DIFFSTAT},y)
HAVE_DIFFSTAT:=y

#DESCRLIST+= "'nti-diffstat' -- diffstat"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DIFFSTAT_VERSION},)
DIFFSTAT_VERSION=1.59
endif

DIFFSTAT_SRC=${SOURCES}/d/diffstat-${DIFFSTAT_VERSION}.tgz
#URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/d/diffstat/diffstat_${DIFFSTAT_VER}.orig.tar.gz
URLS+= ftp://invisible-island.net/diffstat/diffstat-1.${DIFFSTAT_VERSION}.tgz

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

NTI_DIFFSTAT_TEMP=nti-diffstat-${DIFFSTAT_VERSION}

NTI_DIFFSTAT_EXTRACTED=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/configure
NTI_DIFFSTAT_CONFIGURED=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/config.status
NTI_DIFFSTAT_BUILT=${EXTTEMP}/${NTI_DIFFSTAT_TEMP}/diffstat
NTI_DIFFSTAT_INSTALLED=${NTI_TC_ROOT}/usr/bin/diffstat



## ,-----
## |	Extract
## +-----

${NTI_DIFFSTAT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/diffstat-${DIFFSTAT_VERSION} ] || rm -rf ${EXTTEMP}/diffstat-${DIFFSTAT_VERSION}
	zcat ${DIFFSTAT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIFFSTAT_TEMP}
	mv ${EXTTEMP}/diffstat-${DIFFSTAT_VERSION} ${EXTTEMP}/${NTI_DIFFSTAT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DIFFSTAT_CONFIGURED}: ${NTI_DIFFSTAT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
		CFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-graphics --without-x \
			--with-zlib \
			--disable-utf8 \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DIFFSTAT_BUILT}: ${NTI_DIFFSTAT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_DIFFSTAT_INSTALLED}: ${NTI_DIFFSTAT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFSTAT_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-diffstat
nti-diffstat: ${NTI_DIFFSTAT_INSTALLED}

ALL_NTI_TARGETS+= nti-diffstat

endif	# HAVE_DIFFSTAT_CONFIG
