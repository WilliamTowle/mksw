# ncurses v6.4			[ since v5.2, c.2003-05-30 ]
# last mod WmT, 2024-03-20	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_NCURSES_CONFIG},y)
HAVE_NCURSES_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${NCURSES_VERSION},)
#NCURSES_VERSION:=5.6
#NCURSES_VERSION:=5.7
#NCURSES_VERSION:=5.9
#NCURSES_VERSION:=6.0
#NCURSES_VERSION:=6.1
NCURSES_VERSION:=6.4
endif

#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
##URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/n/ncurses/ncurses_5.9.orig.tar.gz
NCURSES_SRC=${DIR_DOWNLOADS}/n/ncurses-${NCURSES_VERSION}.tar.gz
NCURSES_URL=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz


# Dependencies
#include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk

NTI_NCURSES_TEMP=${DIR_EXTTEMP}/nti-ncurses-${NCURSES_VERSION}

NTI_NCURSES_EXTRACTED=${NTI_NCURSES_TEMP}/configure
NTI_NCURSES_CONFIGURED=${NTI_NCURSES_TEMP}/config.status
NTI_NCURSES_BUILT=${NTI_NCURSES_TEMP}/include/curses.h
NTI_NCURSES_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/lib/libncurses.a


# Helper for external use (post-installation)
# NB. correct value depends on --with-abi-version=5 use
#NCURSES_CONFIG_TOOL=${DIR_NTI_TOOLCHAIN}/usr/bin/ncurses5-config
NCURSES_CONFIG_TOOL=${DIR_NTI_TOOLCHAIN}/usr/bin/ncurses6-config


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-ncurses-uriurl:
	@echo "${NCURSES_SRC} ${NCURSES_URL}"

show-all-uriurl:: show-nti-ncurses-uriurl


${NTI_NCURSES_EXTRACTED}: | nti-sanity ${NCURSES_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_NCURSES_TEMP} ARCHIVES=${NCURSES_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_NCURSES_CONFIGURED}: ${NTI_NCURSES_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_NCURSES_TEMP} && CC=${NTI_GCC} ./configure --prefix=${DIR_NTI_TOOLCHAIN}/usr )


${NTI_NCURSES_BUILT}: ${NTI_NCURSES_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_NCURSES_TEMP} && make )


${NTI_NCURSES_INSTALLED}: ${NTI_NCURSES_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_NCURSES_TEMP} && make install )


#

USAGE_TEXT+= "'nti-ncurses' - build ncurses for NTI toolchain"

.PHONY: nti-ncurses
nti-ncurses: ${NTI_NCURSES_INSTALLED}


all-nti-targets:: nti-ncurses


endif	# HAVE_NCURSES_CONFIG
