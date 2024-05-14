# mtools build rules		[ since v3.9.9, c.2003-05-28 ]
# WmT, last mod. 2023-10-19	[ (c) and GPLv2 1999-2023 ]

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifneq (${HAVE_MTOOLS_CONFIG},y)
HAVE_MTOOLS_CONFIG:=y

ifeq (${MTOOLS_VERSION},)
#MTOOLS_VERSION=4.0.12
#MTOOLS_VERSION=4.0.13
#MTOOLS_VERSION=4.0.16
#MTOOLS_VERSION=4.0.18
MTOOLS_VERSION=4.0.43
endif


MTOOLS_SRC=${DIR_DOWNLOADS}/m/mtools-${MTOOLS_VERSION}.tar.bz2
#URLS+= ftp://ftp.gnu.org/gnu/mtools/mtools-${MTOOLS_VERSION}.tar.bz2
MTOOLS_URL=ftp://ftp.gnu.org/gnu/mtools/mtools-${MTOOLS_VERSION}.tar.bz2


NTI_MTOOLS_TEMP=${DIR_EXTTEMP}/nti-mtools-${MTOOLS_VERSION}

NTI_MTOOLS_EXTRACTED=${NTI_MTOOLS_TEMP}/configure
NTI_MTOOLS_CONFIGURED=${NTI_MTOOLS_TEMP}/config.status
NTI_MTOOLS_BUILT=${NTI_MTOOLS_TEMP}/mtools
NTI_MTOOLS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/mtools


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-mtools-uriurl:
	@echo "${MTOOLS_SRC} ${MTOOLS_URL}"

show-all-uriurl:: show-nti-mtools-uriurl


${NTI_MTOOLS_EXTRACTED}: | nti-sanity ${MTOOLS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_MTOOLS_TEMP} ARCHIVES=${MTOOLS_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_MTOOLS_CONFIGURED}: ${NTI_MTOOLS_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_MTOOLS_TEMP} && CC=${NTI_GCC} ./configure --prefix=${DIR_NTI_TOOLCHAIN}/usr )



${NTI_MTOOLS_BUILT}: ${NTI_MTOOLS_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_MTOOLS_TEMP} && make )



${NTI_MTOOLS_INSTALLED}: ${NTI_MTOOLS_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_MTOOLS_TEMP} && make install )


##

USAGE_TEXT+= "'nti-mtools' - build mtools for NTI toolchain"

.PHONY: nti-mtools
nti-mtools: ${NTI_MTOOLS_INSTALLED}


all-nti-targets:: nti-mtools

endif	## HAVE_MTOOLS_CONFIG
