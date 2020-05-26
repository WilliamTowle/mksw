# libiconv v1.14		[ since v?.?, c.????-??-?? ]
# last mod WmT, 2016-06-06	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_LIBICONV},y)
HAVE_LIBICONV:=y

#DESCRLIST+= "'nti-libiconv' -- libiconv"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/libtool/v2.4.6--arm64.mak

ifeq (${LIBICONV_VERSION},)
#LIBICONV_VERSION=1.9.2
#LIBICONV_VERSION=1.12
LIBICONV_VERSION=1.14
endif

LIBICONV_SRC=${SOURCES}/l/libiconv-${LIBICONV_VERSION}.tar.gz
LIBICONV_PATCHES=
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz

LIBICONV_PATCHES+= ${SOURCES}/l/libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch
URLS+= https://raw.githubusercontent.com/chef/omnibus-software/master/config/patches/libiconv/libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch

CTI_LIBICONV_TEMP=cti-libiconv-${LIBICONV_VERSION}

CTI_LIBICONV_EXTRACTED=${EXTTEMP}/${CTI_LIBICONV_TEMP}/README
CTI_LIBICONV_CONFIGURED=${EXTTEMP}/${CTI_LIBICONV_TEMP}/config.status
CTI_LIBICONV_BUILT=${EXTTEMP}/${CTI_LIBICONV_TEMP}/lib/libiconv.la
CTI_LIBICONV_INSTALLED=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/libiconv.so


NTI_LIBICONV_TEMP=nti-libiconv-${LIBICONV_VERSION}

NTI_LIBICONV_EXTRACTED=${EXTTEMP}/${NTI_LIBICONV_TEMP}/README
NTI_LIBICONV_CONFIGURED=${EXTTEMP}/${NTI_LIBICONV_TEMP}/config.status
NTI_LIBICONV_BUILT=${EXTTEMP}/${NTI_LIBICONV_TEMP}/lib/libiconv.la
NTI_LIBICONV_INSTALLED=${NTI_TC_ROOT}/usr/lib/libiconv.so



## ,-----
## |	Extract
## +-----

${CTI_LIBICONV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ] || rm -rf ${EXTTEMP}/libiconv-${LIBICONV_VERSION}
	zcat ${LIBICONV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${CTI_LIBICONV_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBICONV_TEMP}
	mv ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ${EXTTEMP}/${CTI_LIBICONV_TEMP}

##

${NTI_LIBICONV_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ] || rm -rf ${EXTTEMP}/libiconv-${LIBICONV_VERSION}
	zcat ${LIBICONV_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${LIBICONV_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${LIBICONV_PATCHES} ; do \
			echo "*** PATCHING -- PF $${PF} ***" ;\
			patch --batch -d libiconv-${LIBICONV_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_LIBICONV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBICONV_TEMP}
	mv ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ${EXTTEMP}/${NTI_LIBICONV_TEMP}


## ,-----
## |	Configure
## +-----

${CTI_LIBICONV_CONFIGURED}: ${CTI_LIBICONV_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBICONV_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC} \
			--build=${HOSTSPEC} \
			--host=${TARGSPEC} \
			--disable-largefile --disable-nls \
			|| exit 1 \
	)
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#		LIBTOOL=${TARGSPEC}-libtool \

##

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

${CTI_LIBICONV_BUILT}: ${CTI_LIBICONV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBICONV_TEMP} || exit 1 ;\
		make all \
	)
#		make all LIBTOOL=${TARGSPEC}-libtool \

##

${NTI_LIBICONV_BUILT}: ${NTI_LIBICONV_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
		make all LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${CTI_LIBICONV_INSTALLED}: ${CTI_LIBICONV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${CTI_LIBICONV_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \


.PHONY: cti-libiconv
cti-libiconv: ${CTI_LIBICONV_INSTALLED}
#cti-libiconv: cti-libtool ${CTI_LIBICONV_INSTALLED}

ALL_CTI_TARGETS+= cti-libiconv

##

${NTI_LIBICONV_INSTALLED}: ${NTI_LIBICONV_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)


.PHONY: nti-libiconv
#nti-libiconv: ${NTI_LIBICONV_INSTALLED}
nti-libiconv: nti-libtool ${NTI_LIBICONV_INSTALLED}

ALL_NTI_TARGETS+= nti-libiconv

endif	# HAVE_LIBICONV_CONFIG
