# n2048 v0.1			[ since v0.1, c.2014-06-23 ]
# last mod WmT, 2018-04-05	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_N2048_CONFIG},y)
HAVE_N2048_CONFIG:=y

#DESCRLIST+= "'nti-n2048' -- n2048"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${N2048_VERSION},)
N2048_VERSION=0.1
endif

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
#include ${CFG_ROOT}/tui/ncurses/v6.0.mak
include ${CFG_ROOT}/tui/ncurses/v6.1.mak

N2048_SRC=${SOURCES}/n/n2048_v${N2048_VERSION}.tar.gz
URLS+= http://www.dettus.net/n2048/n2048_v0.1.tar.gz

NTI_N2048_TEMP=nti-n2048-${N2048_VERSION}

NTI_N2048_EXTRACTED=${EXTTEMP}/${NTI_N2048_TEMP}/README.txt
NTI_N2048_CONFIGURED=${EXTTEMP}/${NTI_N2048_TEMP}/Makefile.OLD
NTI_N2048_BUILT=${EXTTEMP}/${NTI_N2048_TEMP}/n2048
NTI_N2048_INSTALLED=${NTI_TC_ROOT}/usr/bin/n2048


## ,-----
## |	Extract
## +-----

${NTI_N2048_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/n2048-${N2048_VERSION} ] || rm -rf ${EXTTEMP}/n2048-${N2048_VERSION}
	[ ! -d ${EXTTEMP}/n2048_v${N2048_VERSION} ] || rm -rf ${EXTTEMP}/n2048_v${N2048_VERSION}
	zcat ${N2048_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_N2048_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_N2048_TEMP}
	#mv ${EXTTEMP}/n2048-${N2048_VERSION} ${EXTTEMP}/${NTI_N2048_TEMP}
	mv ${EXTTEMP}/n2048_v${N2048_VERSION} ${EXTTEMP}/${NTI_N2048_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_N2048_CONFIGURED}: ${NTI_N2048_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_N2048_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=[ 	]/	s%/g*cc$$%'${NTI_GCC}'%' \
			| sed '/^CPPFLAGS=/	s%-I.*%'"` ${NCURSES_CONFIG_TOOL} --cflags `"'%' \
			| sed '/^LDFLAGS=/	s%-L.*%-L'"` ${NCURSES_CONFIG_TOOL} --libdir `"'%' \
			| sed 's/DESTDIR/PREFIX/' \
			| sed '/^PREFIX=/	{ s%[ 	]/usr% '${NTI_TC_ROOT}'/usr% ; s%/local%% }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_N2048_BUILT}: ${NTI_N2048_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_N2048_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_N2048_INSTALLED}: ${NTI_N2048_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_N2048_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/share/man/man6 || exit 1 ;\
		make install \
	)

.PHONY: nti-n2048
nti-n2048: nti-ncurses ${NTI_N2048_INSTALLED}

ALL_NTI_TARGETS+= nti-n2048

endif	# HAVE_N2048_CONFIG
