# seatris v0.0.14		[ since v0.0.14, c.2005-12-11 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_SEATRIS_CONFIG},y)
HAVE_SEATRIS_CONFIG:=y

#DESCRLIST+= "'nti-seatris' -- seatris"
#DESCRLIST+= "'cti-seatris' -- seatris"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${SEATRIS_VERSION},)
SEATRIS_VERSION=0.0.14
endif

SEATRIS_SRC=${SOURCES}/s/seatris-${SEATRIS_VERSION}.tar.gz
URLS+=http://www.earth.li/projectpurple/files/seatris-0.0.14.tar.gz

NTI_SEATRIS_TEMP=nti-seatris-${SEATRIS_VERSION}

NTI_SEATRIS_EXTRACTED=${EXTTEMP}/${NTI_SEATRIS_TEMP}/README
NTI_SEATRIS_CONFIGURED=${EXTTEMP}/${NTI_SEATRIS_TEMP}/Makefile.OLD
NTI_SEATRIS_BUILT=${EXTTEMP}/${NTI_SEATRIS_TEMP}/seatris
NTI_SEATRIS_INSTALLED=${NTI_TC_ROOT}/usr/games/seatris


## ,-----
## |	Extract
## +-----

${NTI_SEATRIS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/seatris-${SEATRIS_VERSION} ] || rm -rf ${EXTTEMP}/seatris-${SEATRIS_VERSION}
	zcat ${SEATRIS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SEATRIS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SEATRIS_TEMP}
	mv ${EXTTEMP}/seatris-${SEATRIS_VERSION} ${EXTTEMP}/${NTI_SEATRIS_TEMP}


## ,-----
## |	Configure
## +-----

## custom 'configure' script

${NTI_SEATRIS_CONFIGURED}: ${NTI_SEATRIS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SEATRIS_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS="` ${NCURSES_CONFIG_TOOL} --cflags `" \
		  LFLAGS="` ${NCURSES_CONFIG_TOOL} --libs `" \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^	/	s% \$$(PREFIX)% $$(DESTDIR)/$$(PREFIX)%' \
			| sed '/^	/	s% \$$(INSTALLDIR)% $$(DESTDIR)/$$(INSTALLDIR)%' \
			| sed '/^	/	s% /var/lib% $$(DESTDIR)$$(VARPREFIX)/var/lib%' \
			| sed '/^LFLAGS[ 	]*=/	s/ -g//' \
			| sed '/^	chown/		s/^/#/' \
			| sed '/^	install/	s/-[og] [^ ]*//g' \
			> Makefile \
	)
#			| sed '/^LIBS[ 	]*=/		s%=%= -L'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/lib%' \


## ,-----
## |	Build
## +-----

${NTI_SEATRIS_BUILT}: ${NTI_SEATRIS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SEATRIS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SEATRIS_INSTALLED}: ${NTI_SEATRIS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SEATRIS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/games ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man/man6 ;\
		mkdir -p ${NTI_TC_ROOT}/var/lib/games ;\
		make install VARPREFIX=${NTI_TC_ROOT} \
	)

.PHONY: nti-seatris
nti-seatris: nti-ncurses ${NTI_SEATRIS_INSTALLED}

ALL_NTI_TARGETS+= nti-seatris

endif	# HAVE_SEATRIS_CONFIG
