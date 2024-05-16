# vttest v20240218		[ since v?.??, c.????-??-?? ]
# last mod WmT, 2024-02-18	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_VTTEST_CONFIG},y)
HAVE_VTTEST_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${VTTEST_VERSION},)
#VTTEST_VERSION=20140305
VTTEST_VERSION=20240218
endif

VTTEST_SRC=${DIR_DOWNLOADS}/v/vttest-${VTTEST_VERSION}.tgz
#VTTEST_URL=ftp://invisible-island.net/archives/vttest/vttest-${VTTEST_VERSION}.tgz
VTTEST_URL=https://invisible-island.net/archives/vttest/vttest-${VTTEST_VERSION}.tgz


# Dependencies
include ${MF_CONFIGDIR}/tui/ncurses/v6.4.mk


NTI_VTTEST_TEMP=${DIR_EXTTEMP}/nti-vttest-${VTTEST_VERSION}

NTI_VTTEST_EXTRACTED=${NTI_VTTEST_TEMP}/configure
NTI_VTTEST_CONFIGURED=${NTI_VTTEST_TEMP}/config.log
NTI_VTTEST_BUILT=${NTI_VTTEST_TEMP}/vttest
NTI_VTTEST_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/vttest


## ,-----
## |	Rules - download, extract, configure, build, install


show-nti-vttest-uriurl:
	@echo "${VTTEST_SRC} ${VTTEST_URL}"

show-all-uriurl:: show-nti-vttest-uriurl


${NTI_VTTEST_EXTRACTED}: | nti-sanity ${VTTEST_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_VTTEST_TEMP} ARCHIVES=${VTTEST_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_VTTEST_CONFIGURED}: ${NTI_VTTEST_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_VTTEST_TEMP} || exit 1 ;\
	  CC=${NUI_HOST_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			|| exit 1 \
	)


${NTI_VTTEST_BUILT}: ${NTI_VTTEST_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_VTTEST_TEMP} || exit 1 ;\
		make \
	)


${NTI_VTTEST_INSTALLED}: ${NTI_VTTEST_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_VTTEST_TEMP} || exit 1 ;\
		make install \
	)


##

USAGE_TEXT+= "'nti-vttest' - build vttest for NTI toolchain"

.PHONY: nti-vttest
nti-vttest: nti-ncurses ${NTI_VTTEST_INSTALLED}


all-nti-targets:: nti-vttest


endif	# HAVE_VTTEST_CONFIG
