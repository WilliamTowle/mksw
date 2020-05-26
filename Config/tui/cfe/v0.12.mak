# cfe v0.12			[ since v0.12, c.????-??-?? ]
# last mod WmT, 2017-03-21	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_CFE_CONFIG},y)
HAVE_CFE_CONFIG:=y

#DESCRLIST+= "'nti-cfe' -- cfe"

include ${CFG_ROOT}/ENV/buildtype.mak

# ...build deps?

ifeq (${CFE_VERSION},)
CFE_VERSION=0.12
endif

CFE_SRC=${SOURCES}/c/cfe-${CFE_VERSION}.tar.gz
URLS+= http://SERVER/PATH/cfe-${CFE_VERSION}.tar.gz


#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

NTI_CFE_TEMP=nti-cfe-${CFE_VERSION}

NTI_CFE_EXTRACTED=${EXTTEMP}/${NTI_CFE_TEMP}/configure
NTI_CFE_CONFIGURED=${EXTTEMP}/${NTI_CFE_TEMP}/Makefile.OLD
NTI_CFE_BUILT=${EXTTEMP}/${NTI_CFE_TEMP}/cfe
NTI_CFE_INSTALLED=${NTI_TC_ROOT}/usr/bin/cfe


## ,-----
## |	Extract
## +-----

${NTI_CFE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cfe-${CFE_VERSION} ] || rm -rf ${EXTTEMP}/cfe-${CFE_VERSION}
	zcat ${CFE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CFE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CFE_TEMP}
	mv ${EXTTEMP}/cfe-${CFE_VERSION} ${EXTTEMP}/${NTI_CFE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CFE_CONFIGURED}: ${NTI_CFE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CFE_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%$$% ` '${NCURSES_CONFIG_TOOL}' --cflags `%' \
			| sed '/^CFLAGS/	s%$$%\nLIBS=` '${NCURSES_CONFIG_TOOL}' --libs `%' \
			| sed '/^	/	s%-lcurses%$${LIBS}%' \
			| sed '/^	/	s%dir)%dir)/%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_CFE_BUILT}: ${NTI_CFE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CFE_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_CFE_INSTALLED}: ${NTI_CFE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CFE_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin/ || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man/man1 || exit 1 ;\
		make install || exit 1 ;\
	)

.PHONY: nti-cfe
nti-cfe: nti-ncurses ${NTI_CFE_INSTALLED}

ALL_NTI_TARGETS+= nti-cfe

endif	# HAVE_CFE_CONFIG
