# alpine v2.20			[ since v2.20, c.2017-03-03 ]
# last mod WmT, 2017-03-03	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_ALPINE_CONFIG},y)
HAVE_ALPINE_CONFIG:=y

#DESCRLIST+= "'nti-alpine' -- alpine"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${ALPINE_VERSION},)
ALPINE_VERSION=2.20
endif

ALPINE_SRC=${SOURCES}/a/alpine-${ALPINE_VERSION}.tar.xz
URLS+= http://patches.freeiz.com/alpine/release/src/alpine-${ALPINE_VERSION}.tar.xz

# build deps
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/network/openssl/v1.0.2k.mak

NTI_ALPINE_TEMP=nti-alpine-${ALPINE_VERSION}

NTI_ALPINE_EXTRACTED=${EXTTEMP}/${NTI_ALPINE_TEMP}/VERSION
NTI_ALPINE_CONFIGURED=${EXTTEMP}/${NTI_ALPINE_TEMP}/Makefile.OLD
NTI_ALPINE_BUILT=${EXTTEMP}/${NTI_ALPINE_TEMP}/src/alpine
NTI_ALPINE_INSTALLED=${NTI_TC_ROOT}/usr/sbin/alpine


## ,-----
## |	Extract
## +-----

${NTI_ALPINE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alpine-${ALPINE_VERSION} ] || rm -rf ${EXTTEMP}/alpine-${ALPINE_VERSION}
	#bzcat ${ALPINE_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${ALPINE_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${ALPINE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALPINE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALPINE_TEMP}
	mv ${EXTTEMP}/alpine-${ALPINE_VERSION} ${EXTTEMP}/${NTI_ALPINE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ALPINE_CONFIGURED}: ${NTI_ALPINE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALPINE_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				--with-ssl-dir=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix openssl ` \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALPINE_BUILT}: ${NTI_ALPINE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALPINE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ALPINE_INSTALLED}: ${NTI_ALPINE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALPINE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-alpine
nti-alpine: nti-pkg-config \
	nti-openssl \
	${NTI_ALPINE_INSTALLED}

ALL_NTI_TARGETS+= nti-alpine

endif	# HAVE_ALPINE_CONFIG
