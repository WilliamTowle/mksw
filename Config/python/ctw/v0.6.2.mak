# ctw v0.6.2			[ since v0.6.2, c.2014-03-17 ]
# last mod WmT, 2018-04-05	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_CTW_CONFIG},y)
HAVE_CTW_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CTW_VERSION},)
CTW_VERSION=0.6.2
endif

#CTW_SRC=${SOURCES}/c/ctw-v${CTW_VERSION}.tar.gz
CTW_SRC=${SOURCES}/v/v${CTW_VERSION}.tar.gz
URLS+= https://github.com/tdy/ctw/archive/v0.6.2.tar.gz

include ${CFG_ROOT}/tui/ncurses/v6.0.mak
#include ${CFG_ROOT}/tui/ncurses/v6.1.mak
#include ${CFG_ROOT}/python/python3/v3.3.4.mak
#include ${CFG_ROOT}/python/python3/v3.3.7.mak
include ${CFG_ROOT}/python/python3/v3.4.8.mak

NTI_CTW_TEMP=nti-ctw-${CTW_VERSION}

NTI_CTW_EXTRACTED=${EXTTEMP}/${NTI_CTW_TEMP}/GPL.gz
NTI_CTW_CONFIGURED=${EXTTEMP}/${NTI_CTW_TEMP}/BAR
NTI_CTW_BUILT=${EXTTEMP}/${NTI_CTW_TEMP}/BAZ
NTI_CTW_INSTALLED=${NTI_TC_ROOT}/QUX


## ,-----
## |	Extract
## +-----

${NTI_CTW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ctw-${CTW_VERSION} ] || rm -rf ${EXTTEMP}/ctw-${CTW_VERSION}
	zcat ${CTW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CTW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CTW_TEMP}
	mv ${EXTTEMP}/ctw-${CTW_VERSION} ${EXTTEMP}/${NTI_CTW_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_CTW_CONFIGURED}: ${NTI_CTW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CTW_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		perl Makefile.PL PREFIX=${NTI_TC_ROOT}/usr \
	)


## ,-----
## |	Build
## +-----

${NTI_CTW_BUILT}: ${NTI_CTW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CTW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CTW_INSTALLED}: ${NTI_CTW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CTW_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ctw
nti-ctw: nti-ncurses nti-python3 \
	${NTI_CTW_INSTALLED}

ALL_NTI_TARGETS+= nti-ctw

endif	# HAVE_CTW_CONFIG
