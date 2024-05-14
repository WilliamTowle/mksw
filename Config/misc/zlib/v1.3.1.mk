# zlib build rules		[ since v1.1.4, c.2003-06-03 ]
# WmT, last mod 2024-04-29	[ (c) and GPLv2 1999-2024 ]

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifneq (${HAVE_ZLIB_CONFIG},y)
HAVE_ZLIB_CONFIG:=y

# [2013-12-24] install w/ LDCONFIG=true
# [2013-12-24] buildroot suggests '--shared' and CFLAGS='...-fPIC...'

ifeq (${ZLIB_VERSION},)
#ZLIB_VERSION= 1.2.5
#ZLIB_VERSION= 1.2.7
#ZLIB_VERSION= 1.2.8
#ZLIB_VERSION=1.3
ZLIB_VERSION=1.3.1
endif


ZLIB_SRC=${DIR_DOWNLOADS}/z/zlib-${ZLIB_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/libpng/zlib/${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.gz?use_mirror=ignum
ZLIB_URL=https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz


#| CTI_ZLIB_TEMP=cti-zlib-${ZLIB_VERSION}
#| 
#| CTI_ZLIB_EXTRACTED=${EXTTEMP}/${CTI_ZLIB_TEMP}/configure
#| CTI_ZLIB_CONFIGURED=${EXTTEMP}/${CTI_ZLIB_TEMP}/zlib.pc
#| CTI_ZLIB_BUILT=${EXTTEMP}/${CTI_ZLIB_TEMP}/example
#| CTI_ZLIB_INSTALLED=${NTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig/zlib.pc


NTI_ZLIB_TEMP=${DIR_EXTTEMP}/nti-zlib-${ZLIB_VERSION}

NTI_ZLIB_EXTRACTED=${NTI_ZLIB_TEMP}/zlib.pc.in
NTI_ZLIB_CONFIGURED=${NTI_ZLIB_TEMP}/configure
NTI_ZLIB_BUILT=${NTI_ZLIB_TEMP}/example
NTI_ZLIB_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/lib/libz.a


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-zlib-uriurl:
	@echo "${ZLIB_SRC} ${ZLIB_URL}"

show-all-uriurl:: show-nti-zlib-uriurl


${NTI_ZLIB_EXTRACTED}: | nti-sanity ${ZLIB_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_ZLIB_TEMP} ARCHIVES=${ZLIB_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_ZLIB_CONFIGURED}: ${NTI_ZLIB_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_ZLIB_TEMP} || exit 1 ;\
		./configure --prefix=${DIR_NTI_TOOLCHAIN}/usr )


${NTI_ZLIB_BUILT}: ${NTI_ZLIB_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_ZLIB_TEMP} && make )


${NTI_ZLIB_INSTALLED}: ${NTI_ZLIB_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_ZLIB_TEMP} && make install )


#

USAGE_TEXT+= "'nti-zlib' - build zlib for NTI toolchain"

.PHONY: nti-zlib
nti-zlib: ${NTI_ZLIB_INSTALLED}

all-nti-targets:: nti-zlib


endif	## HAVE_ZLIB_CONFIG
