# libtheora v1.1.1		[ since v1.1.1, c.2017-08-14 ]
# last mod WmT, 2017-08-14	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_LIBTHEORA_CONFIG},y)
HAVE_LIBTHEORA_CONFIG:=y

#DESCRLIST+= "'nti-libtheora' -- libtheora"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${LIBTHEORA_VERSION},)
LIBTHEORA_VERSION=1.1.1
endif

LIBTHEORA_SRC=${SOURCES}/l/libtheora-${LIBTHEORA_VERSION}.tar.gz
URLS+= http://downloads.xiph.org/releases/theora/libtheora-${LIBTHEORA_VERSION}.tar.gz

include ${CFG_ROOT}/audvid/libogg/v1.3.2.mak

NTI_LIBTHEORA_TEMP=nti-libtheora-${LIBTHEORA_VERSION}

NTI_LIBTHEORA_EXTRACTED=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/README
NTI_LIBTHEORA_CONFIGURED=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/config.status
NTI_LIBTHEORA_BUILT=${EXTTEMP}/${NTI_LIBTHEORA_TEMP}/lib/libtheora.la
NTI_LIBTHEORA_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/theora.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBTHEORA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libtheora-${LIBTHEORA_VERSION} ] || rm -rf ${EXTTEMP}/libtheora-${LIBTHEORA_VERSION}
	zcat ${LIBTHEORA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBTHEORA_TEMP}
	mv ${EXTTEMP}/libtheora-${LIBTHEORA_VERSION} ${EXTTEMP}/${NTI_LIBTHEORA_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBTHEORA_CONFIGURED}: ${NTI_LIBTHEORA_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^SUBDIRS/	s/doc *//' \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
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

${NTI_LIBTHEORA_BUILT}: ${NTI_LIBTHEORA_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBTHEORA_INSTALLED}: ${NTI_LIBTHEORA_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBTHEORA_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: nti-libtheora
nti-libtheora: nti-libtool nti-pkg-config \
	nti-libogg \
	${NTI_LIBTHEORA_INSTALLED}

ALL_NTI_TARGETS+= nti-libtheora

endif	# HAVE_LIBTHEORA_CONFIG
