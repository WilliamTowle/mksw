# nsnake v1.5			[ since v1.5, c.2014-02-21 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_NSNAKE_CONFIG},y)
HAVE_NSNAKE_CONFIG:=y

#DESCRLIST+= "'nti-nsnake' -- nsnake"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${NSNAKE_VERSION},)
NSNAKE_VERSION=1.5
endif

NSNAKE_SRC=${SOURCES}/n/nsnake-${NSNAKE_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-${NSNAKE_VERSION}.tar.gz?use_mirror=ignum

NTI_NSNAKE_TEMP=nti-nsnake-${NSNAKE_VERSION}

NTI_NSNAKE_EXTRACTED=${EXTTEMP}/${NTI_NSNAKE_TEMP}/README
NTI_NSNAKE_CONFIGURED=${EXTTEMP}/${NTI_NSNAKE_TEMP}/Makefile.OLD
NTI_NSNAKE_BUILT=${EXTTEMP}/${NTI_NSNAKE_TEMP}/bin/nsnake
NTI_NSNAKE_INSTALLED=${NTI_TC_ROOT}/usr/bin/nsnake


## ,-----
## |	Extract
## +-----

${NTI_NSNAKE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/nsnake-${NSNAKE_VERSION} ] || rm -rf ${EXTTEMP}/nsnake-${NSNAKE_VERSION}
	zcat ${NSNAKE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NSNAKE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NSNAKE_TEMP}
	mv ${EXTTEMP}/nsnake-${NSNAKE_VERSION} ${EXTTEMP}/${NTI_NSNAKE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_NSNAKE_CONFIGURED}: ${NTI_NSNAKE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NSNAKE_TEMP} || exit 1 ;\
		[ -r Makefile.OLD || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/ s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	.*chown/ s/^/#/' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_NSNAKE_BUILT}: ${NTI_NSNAKE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NSNAKE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_NSNAKE_INSTALLED}: ${NTI_NSNAKE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NSNAKE_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/var/games ;\
		make install VARPREFIX=${NTI_TC_ROOT} \
	)

.PHONY: nti-nsnake
nti-nsnake: nti-ncurses ${NTI_NSNAKE_INSTALLED}

ALL_NTI_TARGETS+= nti-nsnake

endif	# HAVE_NSNAKE_CONFIG
