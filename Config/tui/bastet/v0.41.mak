# bastet v0.41			[ since v0.37, c. 2004-05-05 ]
# last mod WmT, 2015-08-11	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_BASTET_CONFIG},y)
HAVE_BASTET_CONFIG:=y

#DESCRLIST+= "'nti-bastet' -- bastet"
#DESCRLIST+= "'cti-bastet' -- bastet"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${BASTET_VERSION},)
BASTET_VERSION=0.41
endif

BASTET_SRC=${SOURCES}/b/bastet-${BASTET_VERSION}.tgz
URLS+=http://fph.altervista.org/prog/files/bastet-0.41.tgz

NTI_BASTET_TEMP=nti-bastet-${BASTET_VERSION}

NTI_BASTET_EXTRACTED=${EXTTEMP}/${NTI_BASTET_TEMP}/TODO
NTI_BASTET_CONFIGURED=${EXTTEMP}/${NTI_BASTET_TEMP}/Makefile.OLD
NTI_BASTET_BUILT=${EXTTEMP}/${NTI_BASTET_TEMP}/bastet
NTI_BASTET_INSTALLED=${NTI_TC_ROOT}/usr/bin/bastet


## ,-----
## |	Extract
## +-----

${NTI_BASTET_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bastet-${BASTET_VERSION} ] || rm -rf ${EXTTEMP}/bastet-${BASTET_VERSION}
	zcat ${BASTET_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BASTET_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BASTET_TEMP}
	mv ${EXTTEMP}/bastet-${BASTET_VERSION} ${EXTTEMP}/${NTI_BASTET_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BASTET_CONFIGURED}: ${NTI_BASTET_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BASTET_TEMP} || exit 1 ;\
		for MF in `find ./ -name Makefile` ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
			cat $${MF}.OLD \
				| sed '/^[A-Z]*_PREFIX=/ { s%/%$${DESTDIR}/% ; s%/%'${NTI_TC_ROOT}'/% }' \
				| sed '/^CC=/	s%g*cc$$%'${NTI_GCC}'%' \
				| sed '/^CFLAGS=/	s%$$% '"` ${NCURSES_CONFIG_TOOL} --cflags `"'%' \
				| sed '/^LDFLAGS=/	s%-lncurses%-L'"` ${NCURSES_CONFIG_TOOL} --libdir `"'%' \
				| sed '/^LDFLAGS=/	s%$$%\nLIBS=-lncurses%' \
				| sed '/^	chown/ s/^/#/' \
				| sed '/$$(CC) $$(LDFLAGS)/	s/$$/ $$(LIBS)/' \
				> $${MF} || exit 1 ;\
		done \
	)


## ,-----
## |	Build
## +-----

${NTI_BASTET_BUILT}: ${NTI_BASTET_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BASTET_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BASTET_INSTALLED}: ${NTI_BASTET_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BASTET_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/var/games ;\
		make install VARPREFIX=${NTI_TC_ROOT} \
	)

.PHONY: nti-bastet
nti-bastet: nti-ncurses ${NTI_BASTET_INSTALLED}

ALL_NTI_TARGETS+= nti-bastet

endif	# HAVE_BASTET_CONFIG
