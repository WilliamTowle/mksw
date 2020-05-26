# libiconv v1.12		[ since v?.?, c.????-??-?? ]
# last mod WmT, 2014-07-02	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBICONV},y)
HAVE_LIBICONV:=y

#DESCRLIST+= "'nti-libiconv' -- libiconv"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${LIBICONV_VERSION},)
#LIBICONV_VERSION=1.9.2
#LIBICONV_VERSION=1.11.1
LIBICONV_VERSION=1.12
endif

LIBICONV_SRC=${SOURCES}/l/libiconv-${LIBICONV_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-1.12.tar.gz
# http://download.videolan.org/pub/videolan/vlc/0.8.0/contrib/libiconv-1.9.2.tar.gz


NTI_LIBICONV_TEMP=nti-libiconv-${LIBICONV_VERSION}

NTI_LIBICONV_EXTRACTED=${EXTTEMP}/${NTI_LIBICONV_TEMP}/README
NTI_LIBICONV_CONFIGURED=${EXTTEMP}/${NTI_LIBICONV_TEMP}/config.status
NTI_LIBICONV_BUILT=${EXTTEMP}/${NTI_LIBICONV_TEMP}/lib/libiconv.la
NTI_LIBICONV_INSTALLED=${NTI_TC_ROOT}/usr/lib/libiconv.so


## ,-----
## |	Extract
## +-----

${NTI_LIBICONV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ] || rm -rf ${EXTTEMP}/libiconv-${LIBICONV_VERSION}
	zcat ${LIBICONV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBICONV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBICONV_TEMP}
	mv ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ${EXTTEMP}/${NTI_LIBICONV_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBICONV_CONFIGURED}: ${NTI_LIBICONV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
		LIBTOOL=${HOSTSPEC}-libtool \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-largefile --disable-nls \
			|| exit 1 \
	)
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_LIBICONV_BUILT}: ${NTI_LIBICONV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
		make all LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBICONV_INSTALLED}: ${NTI_LIBICONV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)


##

.PHONY: nti-libiconv
nti-libiconv: nti-libtool ${NTI_LIBICONV_INSTALLED}

ALL_NTI_TARGETS+= nti-libiconv

endif	# HAVE_LIBICONV_CONFIG
