# pkg-config v0.29.2		[ since v0.23 2009-09-07 ]
# last mod WmT, 2017-03-29	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_PKG_CONFIG_CONFIG},y)
HAVE_PKG_CONFIG_CONFIG:=y

#DESCRLIST+= "'nti-pkg-config' -- pkg-config"

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak


ifeq (${PKG_CONFIG_VERSION},)
#PKG_CONFIG_VERSION=0.27.1
#PKG_CONFIG_VERSION=0.28
#PKG_CONFIG_VERSION=0.29
PKG_CONFIG_VERSION=0.29.2
endif

PKG_CONFIG_SRC=${SOURCES}/p/pkg-config-${PKG_CONFIG_VERSION}.tar.gz
URLS+= http://pkgconfig.freedesktop.org/releases/pkg-config-${PKG_CONFIG_VERSION}.tar.gz

include ${CFG_ROOT}/misc/libiconv/v1.14.mak

NTI_PKG_CONFIG_TEMP=nti-pkg-config-${PKG_CONFIG_VERSION}

NTI_PKG_CONFIG_EXTRACTED=${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}/COPYING
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

##

${CTI_PKG_CONFIG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION}
	zcat ${PKG_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}
	mv ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}


## ,-----
## |	Configure
## +-----

## [v0.29.2] --with-iconv=gnu -> passes "GNU libiconv not in use" test
## [v0.29.2] hbOS: -march=i486 -> passes "lock-free atomic intrinsics" test

${NTI_PKG_CONFIG_CONFIGURED}: ${NTI_PKG_CONFIG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
	  LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-iconv=gnu \
			--with-libiconv=gnu \
			--with-pc-path=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			--program-prefix=${HOSTSPEC}- \
			--with-internal-glib \
			|| exit 1 ;\
		case ${PKG_CONFIG_VERSION} in \
		0.28|0.29|0.29.2) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^	/	{ /install-exec-hook/ s/^/#/ }' \
				> Makefile \
		;; \
		*) \
			echo "Unexpected version ${PKG_CONFIG_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

##

${CTI_PKG_CONFIG_CONFIGURED}: ${CTI_PKG_CONFIG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC}/usr \
			--bindir=${CTI_TC_ROOT}/usr/bin \
			--datadir=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib \
			  --host=${HOSTSPEC} \
			  --build=${HOSTSPEC} \
			  --target=${TARGSPEC} \
			--program-prefix=${TARGSPEC}- \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${CTI_PKG_CONFIG_BUILT}: ${CTI_PKG_CONFIG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
		make LIBTOOL=${TARGSPEC}-libtool \
	)

##

${NTI_PKG_CONFIG_BUILT}: ${NTI_PKG_CONFIG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${CTI_PKG_CONFIG_INSTALLED}: ${CTI_PKG_CONFIG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
		mkdir -p ${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig ;\
		make install LIBTOOL=${TARGSPEC}-libtool \
	)

.PHONY: cti-pkg-config
cti-pkg-config: cti-libtool ${CTI_PKG_CONFIG_INSTALLED}
#cti-pkg-config: nti-pkg-config cti-libtool ${CTI_PKG_CONFIG_INSTALLED}

ALL_CTI_TARGETS+= cti-pkg-config

##

${NTI_PKG_CONFIG_INSTALLED}: ${NTI_PKG_CONFIG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \


.PHONY: nti-pkg-config
nti-pkg-config: nti-libiconv ${NTI_PKG_CONFIG_INSTALLED}

ALL_NTI_TARGETS+= nti-pkg-config

endif	# HAVE_PKG_CONFIG_CONFIG
