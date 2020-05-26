# ctris v0.42			[ since v?.??, c.????-??-?? ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_CTRIS_CONFIG},y)
HAVE_CTRIS_CONFIG:=y

#DESCRLIST+= "'nti-ctris' -- ctris"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CTRIS_VERSION},)
CTRIS_VERSION=0.42
endif

#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

CTRIS_SRC=${SOURCES}/c/ctris-${CTRIS_VERSION}.tar.bz2
URLS+= http://www.slackware.com/~alien/slackbuilds/ctris/build/ctris-0.42.tar.bz2

NTI_CTRIS_TEMP=nti-ctris-${CTRIS_VERSION}

NTI_CTRIS_EXTRACTED=${EXTTEMP}/${NTI_CTRIS_TEMP}/create_config.sh
NTI_CTRIS_CONFIGURED=${EXTTEMP}/${NTI_CTRIS_TEMP}/Makefile.OLD
NTI_CTRIS_BUILT=${EXTTEMP}/${NTI_CTRIS_TEMP}/ctris
NTI_CTRIS_INSTALLED=${NTI_TC_ROOT}/usr/games/ctris


## ,-----
## |	Extract
## +-----

${NTI_CTRIS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ctris-${CTRIS_VERSION} ] || rm -rf ${EXTTEMP}/ctris-${CTRIS_VERSION}
	#zcat ${CTRIS_SRC} | tar xvf - -C ${EXTTEMP}
	bzcat ${CTRIS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CTRIS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CTRIS_TEMP}
	mv ${EXTTEMP}/ctris-${CTRIS_VERSION} ${EXTTEMP}/${NTI_CTRIS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CTRIS_CONFIGURED}: ${NTI_CTRIS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CTRIS_TEMP} || exit 1 ;\
		./create_config.sh || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc$$%'${NTI_GCC}'%' \
			| sed '/^CFLAGS=/	s%$$% '"` ${NCURSES_CONFIG_TOOL} --cflags `"'%' \
			| sed '/^LIBS=/		s%-lncurses*%'"`${NCURSES_CONFIG_TOOL} --libs `"'%' \
			| sed '/^BINDIR=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^MANDIR=/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_CTRIS_BUILT}: ${NTI_CTRIS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CTRIS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CTRIS_INSTALLED}: ${NTI_CTRIS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CTRIS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/share/man/man6 || exit 1 ;\
		make install \
	)

.PHONY: nti-ctris
nti-ctris: nti-ncurses ${NTI_CTRIS_INSTALLED}

ALL_NTI_TARGETS+= nti-ctris

endif	# HAVE_CTRIS_CONFIG
