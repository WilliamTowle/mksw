# vttest v0.42			[ since v?.??, c.????-??-?? ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_VTTEST_CONFIG},y)
HAVE_VTTEST_CONFIG:=y

#DESCRLIST+= "'nti-vttest' -- vttest"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

ifeq (${VTTEST_VERSION},)
VTTEST_VERSION=20140305
endif

#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

VTTEST_SRC=${SOURCES}/v/vttest-${VTTEST_VERSION}.tgz
URLS+= ftp://invisible-island.net/vttest/vttest-${VTTEST_VERSION}.tgz

NTI_VTTEST_TEMP=nti-vttest-${VTTEST_VERSION}

NTI_VTTEST_EXTRACTED=${EXTTEMP}/${NTI_VTTEST_TEMP}/configure
NTI_VTTEST_CONFIGURED=${EXTTEMP}/${NTI_VTTEST_TEMP}/config.log
NTI_VTTEST_BUILT=${EXTTEMP}/${NTI_VTTEST_TEMP}/vttest
NTI_VTTEST_INSTALLED=${NTI_TC_ROOT}/usr/bin/vttest


## ,-----
## |	Extract
## +-----

${NTI_VTTEST_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/vttest-${VTTEST_VERSION} ] || rm -rf ${EXTTEMP}/vttest-${VTTEST_VERSION}
	zcat ${VTTEST_SRC} | tar xvf - -C ${EXTTEMP}
	#bzcat ${VTTEST_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VTTEST_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VTTEST_TEMP}
	mv ${EXTTEMP}/vttest-${VTTEST_VERSION} ${EXTTEMP}/${NTI_VTTEST_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VTTEST_CONFIGURED}: ${NTI_VTTEST_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_VTTEST_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_VTTEST_BUILT}: ${NTI_VTTEST_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_VTTEST_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VTTEST_INSTALLED}: ${NTI_VTTEST_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_VTTEST_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ${NTI_TC_ROOT}/usr/bin || exit 1 ;\
#		mkdir -p ${NTI_TC_ROOT}/usr/share/man/man6 || exit 1 ;\

.PHONY: nti-vttest
nti-vttest: nti-ncurses ${NTI_VTTEST_INSTALLED}

ALL_NTI_TARGETS+= nti-vttest

endif	# HAVE_VTTEST_CONFIG
