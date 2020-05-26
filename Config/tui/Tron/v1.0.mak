# tron v1.0			[ since v1.0, c.2014-10-15 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_TRON_CONFIG},y)
HAVE_TRON_CONFIG:=y

#DESCRLIST+= "'nti-tron' -- tron"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${TRON_VERSION},)
TRON_VERSION=1.0
endif

TRON_SRC=${SOURCES}/t/Tron-${TRON_VERSION}.tar.gz
URLS+= https://github.com/samirotiv/Tron/archive/1.0.tar.gz

NTI_TRON_TEMP=nti-tron-${TRON_VERSION}

NTI_TRON_EXTRACTED=${EXTTEMP}/${NTI_TRON_TEMP}/tron.h
NTI_TRON_CONFIGURED=${EXTTEMP}/${NTI_TRON_TEMP}/Makefile.OLD
NTI_TRON_BUILT=${EXTTEMP}/${NTI_TRON_TEMP}/tron
NTI_TRON_INSTALLED=${NTI_TC_ROOT}/usr/bin/tron


## ,-----
## |	Extract
## +-----

${NTI_TRON_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/Tron-${TRON_VERSION} ] || rm -rf ${EXTTEMP}/Tron-${TRON_VERSION}
	zcat ${TRON_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TRON_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TRON_TEMP}
	mv ${EXTTEMP}/Tron-${TRON_VERSION} ${EXTTEMP}/${NTI_TRON_TEMP}


## ,-----
## |	Configure
## +-----

## v1.5 -> v1.7: 'chown' becomes 'install -g'

${NTI_TRON_CONFIGURED}: ${NTI_TRON_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TRON_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/Makefile/ s%$$%\nCC='${NTI_GCC}'%' \
			| sed '/^CC=/		s%$$%\nCFLAGS='"`${NCURSES_CONFIG_TOOL} --cflags`"'%' \
			| sed '/^CFLAGS=/	s%$$%\nLDFLAGS=-L'"`${NCURSES_CONFIG_TOOL} --libdir`"'%' \
			| sed '/^	/	s/g*cc/$${CC} $${CFLAGS}/' \
			| sed '/main.c engine.o/	{ s/main.c/main.o/ ; s/^/	$${CC} $${CFLAGS} -c -g main.c -o main.o\n/ }' \
			| sed '/-o tron/	s/-lncurses/$${LDFLAGS} -lncurses/' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_TRON_BUILT}: ${NTI_TRON_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TRON_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TRON_INSTALLED}: ${NTI_TRON_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TRON_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		cp tron ${NTI_TC_ROOT}/usr/bin \
	)

.PHONY: nti-tron
nti-tron: nti-ncurses ${NTI_TRON_INSTALLED}

ALL_NTI_TARGETS+= nti-tron

endif	# HAVE_TRON_CONFIG
