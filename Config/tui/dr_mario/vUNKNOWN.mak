# dr_mario vUNKNOWN		[ since vUNKNOWN, c.2016-01-17 ]
# last mod WmT, 2016-01-17	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_DR_MARIO_CONFIG},y)
HAVE_DR_MARIO_CONFIG:=y

#DESCRLIST+= "'nti-dr_mario' -- dr_mario"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DR_MARIO_VERSION},)
DR_MARIO_VERSION=UNKNOWN
endif

DR_MARIO_SRC=${SOURCES}/d/dr_mario.tar.Z
URLS+= http://ibiblio.org/pub/linux/games/arcade/dr_mario.tar.Z

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_DR_MARIO_TEMP=nti-dr_mario-${DR_MARIO_VERSION}

NTI_DR_MARIO_EXTRACTED=${EXTTEMP}/${NTI_DR_MARIO_TEMP}/dr_mario.h
NTI_DR_MARIO_CONFIGURED=${EXTTEMP}/${NTI_DR_MARIO_TEMP}/Makefile.OLD
NTI_DR_MARIO_BUILT=${EXTTEMP}/${NTI_DR_MARIO_TEMP}/dr_mario
NTI_DR_MARIO_INSTALLED=${NTI_TC_ROOT}/usr/bin/dr_mario


## ,-----
## |	Extract
## +-----

${NTI_DR_MARIO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/dr_mario-${DR_MARIO_VERSION} ] || rm -rf ${EXTTEMP}/dr_mario-${DR_MARIO_VERSION}
	[ ! -d ${EXTTEMP}/dr_mario ] || rm -rf ${EXTTEMP}/dr_mario
	zcat ${DR_MARIO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DR_MARIO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DR_MARIO_TEMP}
	#mv ${EXTTEMP}/dr_mario-${DR_MARIO_VERSION} ${EXTTEMP}/${NTI_DR_MARIO_TEMP}
	mv ${EXTTEMP}/dr_mario ${EXTTEMP}/${NTI_DR_MARIO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DR_MARIO_CONFIGURED}: ${NTI_DR_MARIO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DR_MARIO_TEMP} || exit 1 ;\
		[ -r loop.c.OLD ] || mv loop.c loop.c.OLD || exit 1 ;\
		cat loop.c.OLD \
			| sed '/loop()/,/^$$/	s/change(), //' \
			| sed '/void[ 	]*loop2();/	s/$$/\nvoid change(int);/' \
			| sed '/time counter/		s/$$/\nvoid change(int);/' \
			> loop.c || exit 1 ;\
		[ -r main.c.OLD ] || mv main.c main.c.OLD || exit 1 ;\
		cat main.c.OLD \
			| sed '/"info.h"/	s%$$%\n#include <curses.h>%' \
			> main.c || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CFLAGS=/	s%$$% '"`${NCURSES_CONFIG_TOOL} --cflags`"'%' \
			| sed '/^CFLAGS=/	s%$$%\nLDFLAGS=-L'"`${NCURSES_CONFIG_TOOL} --libdir`"'%' \
			| sed '/^LDFLAGS=/	s%$$%\nLIBS= -lncurses%' \
			| sed '/^	/	s/-lcurses -ltermcap/$${LDFLAGS} $${LIBS}/' \
			| sed '/^main.o/,/^$$/	s/-DLINUX/-DLINUX -c/' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DR_MARIO_BUILT}: ${NTI_DR_MARIO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DR_MARIO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DR_MARIO_INSTALLED}: ${NTI_DR_MARIO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DR_MARIO_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		cp dr_mario ${NTI_TC_ROOT}/usr/bin \
	)

.PHONY: nti-dr_mario
nti-dr_mario: nti-ncurses ${NTI_DR_MARIO_INSTALLED}

ALL_NTI_TARGETS+= nti-dr_mario

endif	# HAVE_DR_MARIO_CONFIG
