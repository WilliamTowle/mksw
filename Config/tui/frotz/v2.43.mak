# frotz v2.43			[ since v2.43d, c.2014-03-18 ]
# last mod WmT, 2015-08-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_FROTZ_CONFIG},y)
HAVE_FROTZ_CONFIG:=y

#DESCRLIST+= "'nti-frotz' -- frotz"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/tui/ncurses/v5.6.mak
#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak

ifeq (${FROTZ_VERSION},)
FROTZ_VERSION=2.43
endif

FROTZ_SRC=${SOURCES}/f/frotz-${FROTZ_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/frotz/frotz/frotz-${FROTZ_VERSION}.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffrotz%2F&ts=1483713027&use_mirror=netcologne

NTI_FROTZ_TEMP=nti-frotz-${FROTZ_VERSION}

NTI_FROTZ_EXTRACTED=${EXTTEMP}/${NTI_FROTZ_TEMP}/README
NTI_FROTZ_CONFIGURED=${EXTTEMP}/${NTI_FROTZ_TEMP}/Makefile.OLD
NTI_FROTZ_BUILT=${EXTTEMP}/${NTI_FROTZ_TEMP}/frotz
NTI_FROTZ_INSTALLED=${NTI_TC_ROOT}/usr/bin/frotz


## ,-----
## |	Extract
## +-----

${NTI_FROTZ_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/frotz-${FROTZ_VERSION} ] || rm -rf ${EXTTEMP}/frotz-${FROTZ_VERSION}
	zcat ${FROTZ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FROTZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FROTZ_TEMP}
	mv ${EXTTEMP}/frotz-${FROTZ_VERSION} ${EXTTEMP}/${NTI_FROTZ_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FROTZ_CONFIGURED}: ${NTI_FROTZ_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FROTZ_TEMP} || exit 1 ;\
		[ -r Makefile.OLD || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC *=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CC=/		s%$$%\nCFLAGS='"`${NCURSES_CONFIG_TOOL} --cflags`"'%' \
			| sed '/^CFLAGS=/	s%$$%\nLDFLAGS=-L'"`${NCURSES_CONFIG_TOOL} --libdir`"'%' \
			| sed '/^PREFIX *=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CONFIG_DIR *=/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FROTZ_BUILT}: ${NTI_FROTZ_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FROTZ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FROTZ_INSTALLED}: ${NTI_FROTZ_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FROTZ_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-frotz
nti-frotz: nti-ncurses ${NTI_FROTZ_INSTALLED}

ALL_NTI_TARGETS+= nti-frotz

endif	# HAVE_FROTZ_CONFIG
