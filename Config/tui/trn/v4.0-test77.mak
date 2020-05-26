# trn v4.0-test77		[ since v4.0-test77 c.2017-03-27 ]
# last mod WmT, 2017-03-27	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_TRN_CONFIG},y)
HAVE_TRN_CONFIG:=y

#DESCRLIST+= "'nti-trn' -- trn"

include ${CFG_ROOT}/ENV/buildtype.mak

# ...build deps?

ifeq (${TRN_VERSION},)
TRN_VERSION=4.0-test77
endif

TRN_SRC=${SOURCES}/t/trn-${TRN_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/trn/trn4/trn-${TRN_VERSION}.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ftrn%2F&ts=1490630301&use_mirror=freefr"


##include ${CFG_ROOT}/tui/ncurses/v5.6.mak
##include ${CFG_ROOT}/tui/ncurses/v5.9.mak
#include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_TRN_TEMP=nti-trn-${TRN_VERSION}

NTI_TRN_EXTRACTED=${EXTTEMP}/${NTI_TRN_TEMP}/configure
NTI_TRN_CONFIGURED=${EXTTEMP}/${NTI_TRN_TEMP}/Makefile.OLD
NTI_TRN_BUILT=${EXTTEMP}/${NTI_TRN_TEMP}/trn
NTI_TRN_INSTALLED=${NTI_TC_ROOT}/usr/bin/trn


## ,-----
## |	Extract
## +-----

${NTI_TRN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/trn-${TRN_VERSION} ] || rm -rf ${EXTTEMP}/trn-${TRN_VERSION}
	zcat ${TRN_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TRN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TRN_TEMP}
	mv ${EXTTEMP}/trn-${TRN_VERSION} ${EXTTEMP}/${NTI_TRN_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TRN_CONFIGURED}: ${NTI_TRN_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TRN_TEMP} || exit 1 ;\
		./Configure -des -Dprefix=${NTI_TC_ROOT}/usr \
			-Dcc=`which gcc` \
	)


## ,-----
## |	Build
## +-----

${NTI_TRN_BUILT}: ${NTI_TRN_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TRN_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_TRN_INSTALLED}: ${NTI_TRN_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TRN_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-trn
#nti-trn: nti-ncurses \
#	${NTI_TRN_INSTALLED}
nti-trn: ${NTI_TRN_INSTALLED}

ALL_NTI_TARGETS+= nti-trn

endif	# HAVE_TRN_CONFIG
