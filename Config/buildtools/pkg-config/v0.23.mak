# pkg-config v0.23		[ since v0.23 2009-09-07 ]
# last mod WmT, 2015-10-02	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_PKG_CONFIG_CONFIG},y)
HAVE_PKG_CONFIG_CONFIG:=y

#DESCRLIST+= "'nti-pkg-config' -- pkg-config"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PKG_CONFIG_VERSION},)
PKG_CONFIG_VERSION=0.23
endif

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

PKG_CONFIG_SRC=${SOURCES}/p/pkg-config-${PKG_CONFIG_VERSION}.tar.gz

URLS+= http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz

NTI_PKG_CONFIG_TEMP=nti-pkg-config-${PKG_CONFIG_VERSION}

NTI_PKG_CONFIG_EXTRACTED=${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}/Makefile
NTI_PKG_CONFIG_CONFIGURED=${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}/config.log
NTI_PKG_CONFIG_BUILT=${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}/pkg-config
NTI_PKG_CONFIG_INSTALLED=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config

CTI_PKG_CONFIG_TEMP=cti-pkg-config-${PKG_CONFIG_VERSION}

CTI_PKG_CONFIG_EXTRACTED=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/Makefile
CTI_PKG_CONFIG_CONFIGURED=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/config.log
CTI_PKG_CONFIG_BUILT=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/pkg-config
CTI_PKG_CONFIG_INSTALLED=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config


PKG_CONFIG_CONFIG_HOST_TOOL= ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
PKG_CONFIG_CONFIG_HOST_PATH= ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig


## ,-----
## |	Extract
## +-----

${NTI_PKG_CONFIG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION}
	zcat ${PKG_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}
	mv ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}

${CTI_PKG_CONFIG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION}
	zcat ${PKG_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}
	mv ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}


## ,-----
## |	Configure
## +-----

## [2016-02-15] '-Wall' notes "read through pointer" (never seen IRL?)

${NTI_PKG_CONFIG_CONFIGURED}: ${NTI_PKG_CONFIG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
	  CFLAGS='-O2 -z muldefs' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pc-path=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			--program-prefix=${HOSTSPEC}- \
			|| exit 1 \
	)
#		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
#		cat configure.OLD \
#			| sed '/WARN_CFLAGS/	s/ -Wall / /' \
#			> configure || exit 1;\
#		chmod a+x configure ;\

${CTI_PKG_CONFIG_CONFIGURED}: ${CTI_PKG_CONFIG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr \
			--bindir=${CTI_TC_ROOT}/usr/bin \
			--datadir=${CTI_TC_ROOT}/usr/${CTI_SPEC}/lib \
			  --host=${NTI_SPEC} \
			  --build=${NTI_SPEC} \
			  --target=${CTI_SPEC} \
			--program-prefix=${CTI_SPEC}- \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PKG_CONFIG_BUILT}: ${NTI_PKG_CONFIG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)

${CTI_PKG_CONFIG_BUILT}: ${CTI_PKG_CONFIG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
		make LIBTOOL=${TARGSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_PKG_CONFIG_INSTALLED}: ${NTI_PKG_CONFIG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

${CTI_PKG_CONFIG_INSTALLED}: ${CTI_PKG_CONFIG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
		mkdir -p ${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig ;\
		make install LIBTOOL=${TARGSPEC}-libtool \
	)


##

.PHONY: nti-pkg-config
nti-pkg-config: nti-libtool ${NTI_PKG_CONFIG_INSTALLED}

ALL_NTI_TARGETS+= nti-pkg-config

.PHONY: cti-pkg-config
cti-pkg-config: cti-libtool ${CTI_PKG_CONFIG_INSTALLED}

ALL_CTI_TARGETS+= cti-pkg-config

endif	# HAVE_PKG_CONFIG_CONFIG
