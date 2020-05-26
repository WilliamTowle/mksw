# invaders v0.1b		[ since v0.1b, c. 2014-11-18 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_INVADERS_CONFIG},y)
HAVE_INVADERS_CONFIG:=y

#DESCRLIST+= "'nti-invaders' -- invaders"
#DESCRLIST+= "'cti-invaders' -- invaders"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${INVADERS_VERSION},)
INVADERS_VERSION=0.1b
endif

INVADERS_SRC=${SOURCES}/i/invaders${INVADERS_VERSION}.tgz
URLS+= http://web.archive.org/web/20100417061809/http://www.ip9.org/munro/invaders/invaders0.1b.tgz

NTI_INVADERS_TEMP=nti-invaders-${INVADERS_VERSION}

NTI_INVADERS_EXTRACTED=${EXTTEMP}/${NTI_INVADERS_TEMP}/TODO
NTI_INVADERS_CONFIGURED=${EXTTEMP}/${NTI_INVADERS_TEMP}/Makefile.OLD
NTI_INVADERS_BUILT=${EXTTEMP}/${NTI_INVADERS_TEMP}/ascii_invaders
NTI_INVADERS_INSTALLED=${NTI_TC_ROOT}/usr/bin/ascii_invaders


## ,-----
## |	Extract
## +-----

${NTI_INVADERS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/invaders-${INVADERS_VERSION} ] || rm -rf ${EXTTEMP}/invaders-${INVADERS_VERSION}
	[ ! -d ${EXTTEMP}/invaders ] || rm -rf ${EXTTEMP}/invaders
	zcat ${INVADERS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_INVADERS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_INVADERS_TEMP}
	#mv ${EXTTEMP}/invaders-${INVADERS_VERSION} ${EXTTEMP}/${NTI_INVADERS_TEMP}
	mv ${EXTTEMP}/invaders ${EXTTEMP}/${NTI_INVADERS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_INVADERS_CONFIGURED}: ${NTI_INVADERS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_INVADERS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^all:/		s%^%CC='${NTI_GCC}'\n\n%' \
			| sed '/^CC/		s%$$%\nLDFLAGS=-lncurses%' \
			| sed '/	/	s%cc%$${CC}%' \
			| sed '/	/	s%-lcurses%$${LDFLAGS}%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_INVADERS_BUILT}: ${NTI_INVADERS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_INVADERS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_INVADERS_INSTALLED}: ${NTI_INVADERS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_INVADERS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		cp ascii_invaders ${NTI_TC_ROOT}/usr/bin/ || exit 1 \
	)

.PHONY: nti-invaders
nti-invaders: nti-ncurses ${NTI_INVADERS_INSTALLED}

ALL_NTI_TARGETS+= nti-invaders

endif	# HAVE_INVADERS_CONFIG
