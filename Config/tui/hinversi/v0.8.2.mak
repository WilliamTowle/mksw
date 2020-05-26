# hinversi v0.8.2		[ since v0.8.2, c. 2015-08-12 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_HINVERSI_CONFIG},y)
HAVE_HINVERSI_CONFIG:=y

#DESCRLIST+= "'nti-hinversi' -- hinversi"
#DESCRLIST+= "'cti-hinversi' -- hinversi"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${HINVERSI_VERSION},)
HINVERSI_VERSION=0.8.2
endif

HINVERSI_SRC=${SOURCES}/h/hinversi-${HINVERSI_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/hinversi/latest/hinversi-${HINVERSI_VERSION}.tar.gz?use_mirror=ignum

NTI_HINVERSI_TEMP=nti-hinversi-${HINVERSI_VERSION}

NTI_HINVERSI_EXTRACTED=${EXTTEMP}/${NTI_HINVERSI_TEMP}/configure
NTI_HINVERSI_CONFIGURED=${EXTTEMP}/${NTI_HINVERSI_TEMP}/config.log
NTI_HINVERSI_BUILT=${EXTTEMP}/${NTI_HINVERSI_TEMP}/human-cli/hinversi-cli
NTI_HINVERSI_INSTALLED=${NTI_TC_ROOT}/usr/bin/hinversi-cli


## ,-----
## |	Extract
## +-----

${NTI_HINVERSI_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/hinversi-${HINVERSI_VERSION} ] || rm -rf ${EXTTEMP}/hinversi-${HINVERSI_VERSION}
	#[ ! -d ${EXTTEMP}/hinversi ] || rm -rf ${EXTTEMP}/hinversi
	zcat ${HINVERSI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_HINVERSI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_HINVERSI_TEMP}
	mv ${EXTTEMP}/hinversi-${HINVERSI_VERSION} ${EXTTEMP}/${NTI_HINVERSI_TEMP}
	#mv ${EXTTEMP}/hinversi ${EXTTEMP}/${NTI_HINVERSI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_HINVERSI_CONFIGURED}: ${NTI_HINVERSI_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_HINVERSI_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr || exit 1\
	)


## ,-----
## |	Build
## +-----

${NTI_HINVERSI_BUILT}: ${NTI_HINVERSI_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_HINVERSI_TEMP} || exit 1 ;\
		make || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_HINVERSI_INSTALLED}: ${NTI_HINVERSI_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_HINVERSI_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-hinversi
nti-hinversi: nti-ncurses ${NTI_HINVERSI_INSTALLED}

ALL_NTI_TARGETS+= nti-hinversi

endif	# HAVE_HINVERSI_CONFIG
