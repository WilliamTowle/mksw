# libjpeg-turbo v1.5.3		[ since v1.5.3 c. 2018-02-02 ]
# last mod WmT, 2018-02-03	[ (c) and GPLv2 1999-2018 ]

ifneq (${HAVE_LIBJPEG_TURBO_CONFIG},y)
HAVE_LIBJPEG_TURBO_CONFIG:=y

#DESCRLIST+= "'nti-libjpeg-turbo' -- libjpeg-turbo"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/nasm/v2.13.mak

ifeq (${LIBJPEG_TURBO_VERSION},)
LIBJPEG_TURBO_VERSION=1.5.3
endif

LIBJPEG_TURBO_SRC=${SOURCES}/l/libjpeg-turbo-1.5.3.tar.gz
URLS+= https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz

NTI_LIBJPEG_TURBO_TEMP=nti-libjpeg-turbo-${LIBJPEG_TURBO_VERSION}

NTI_LIBJPEG_TURBO_EXTRACTED=${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP}/configure
NTI_LIBJPEG_TURBO_CONFIGURED=${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP}/config.log
NTI_LIBJPEG_TURBO_BUILT=${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP}/libjpeg.la
NTI_LIBJPEG_TURBO_INSTALLED=${NTI_TC_ROOT}/usr/lib/libjpeg.la


## ,-----
## |	Extract
## +-----

${NTI_LIBJPEG_TURBO_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libjpeg-turbo-${LIBJPEG_TURBO_VERSION} ] || rm -rf ${EXTTEMP}/libjpeg-turbo-${LIBJPEG_TURBO_VERSION}
	zcat ${LIBJPEG_TURBO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP}
	mv ${EXTTEMP}/libjpeg-turbo-${LIBJPEG_TURBO_VERSION} ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBJPEG_TURBO_CONFIGURED}: ${NTI_LIBJPEG_TURBO_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-jpeg8 \
			|| exit 1 \
	)
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_LIBJPEG_TURBO_BUILT}: ${NTI_LIBJPEG_TURBO_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBJPEG_TURBO_INSTALLED}: ${NTI_LIBJPEG_TURBO_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBJPEG_TURBO_TEMP} || exit 1 ;\
		make install \
	)
#	mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
#	mkdir -p ${NTI_TC_ROOT}/usr/man/man1 ;\

##

.PHONY: nti-libjpeg-turbo
nti-libjpeg-turbo: \
	nti-pkg-config nti-nasm \
	${NTI_LIBJPEG_TURBO_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-libjpeg-turbo

endif	# HAVE_LIBJPEG_TURBO_CONFIG
