# greed 4.1			[ since v4.1, c. 2015-08-12 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_GREED_CONFIG},y)
HAVE_GREED_CONFIG:=y

#DESCRLIST+= "'nti-greed' -- greed"
#DESCRLIST+= "'cti-greed' -- greed"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${GREED_VERSION},)
GREED_VERSION=4.1
endif

GREED_SRC=${SOURCES}/g/greed-${GREED_VERSION}.tar.gz
URLS+= http://www.catb.org/~esr/greed/greed-${GREED_VERSION}.tar.gz

NTI_GREED_TEMP=nti-greed-${GREED_VERSION}

NTI_GREED_EXTRACTED=${EXTTEMP}/${NTI_GREED_TEMP}/README
NTI_GREED_CONFIGURED=${EXTTEMP}/${NTI_GREED_TEMP}/Makefile.OLD
NTI_GREED_BUILT=${EXTTEMP}/${NTI_GREED_TEMP}/greed
NTI_GREED_INSTALLED=${NTI_TC_ROOT}/usr/games/greed


## ,-----
## |	Extract
## +-----

${NTI_GREED_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/greed-${GREED_VERSION} ] || rm -rf ${EXTTEMP}/greed-${GREED_VERSION}
	#[ ! -d ${EXTTEMP}/greed ] || rm -rf ${EXTTEMP}/greed
	zcat ${GREED_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GREED_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GREED_TEMP}
	mv ${EXTTEMP}/greed-${GREED_VERSION} ${EXTTEMP}/${NTI_GREED_TEMP}
	#mv ${EXTTEMP}/greed ${EXTTEMP}/${NTI_GREED_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_GREED_CONFIGURED}: ${NTI_GREED_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GREED_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^VERS/		s%$$%\nCC='${NTI_GCC}'%' \
			| sed '/^BIN/		s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^SFILE/		s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_GREED_BUILT}: ${NTI_GREED_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GREED_TEMP} || exit 1 ;\
		make || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_GREED_INSTALLED}: ${NTI_GREED_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GREED_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/games || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/share/man/man6 || exit 1 ;\
		make install \
	)

.PHONY: nti-greed
nti-greed: nti-ncurses ${NTI_GREED_INSTALLED}

ALL_NTI_TARGETS+= nti-greed

endif	# HAVE_GREED_CONFIG
