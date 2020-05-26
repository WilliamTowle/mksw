# aylet v0.5			[ EARLIEST v0.5, c.2014-10-09 ]
# last mod WmT, 2014-10-13	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_AYLET_CONFIG},y)
HAVE_AYLET_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${AYLET_VERSION},)
AYLET_VERSION=0.5
endif

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


AYLET_SRC=${SOURCES}/a/aylet-${AYLET_VERSION}.tar.gz
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/aylet-0.5.tar.gz
URLS+= ftp://ftp.ibiblio.org/pub/Linux/apps/sound/players/aylet-${AYLET_VERSION}.tar.gz


#include ${CFG_ROOT}/tui/ncurses/v5.9.mak
include ${CFG_ROOT}/tui/ncurses/v6.0.mak


NTI_AYLET_TEMP=nti-aylet-${AYLET_VERSION}

NTI_AYLET_EXTRACTED=${EXTTEMP}/${NTI_AYLET_TEMP}/COPYING
NTI_AYLET_CONFIGURED=${EXTTEMP}/${NTI_AYLET_TEMP}/Makefile
NTI_AYLET_BUILT=${EXTTEMP}/${NTI_AYLET_TEMP}/aylet
NTI_AYLET_INSTALLED=${NTI_TC_ROOT}/usr/bin/aylet


## ,-----
## |	Extract
## +-----

${NTI_AYLET_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/aylet-${AYLET_VERSION} ] || rm -rf ${EXTTEMP}/aylet-${AYLET_VERSION}
	zcat ${AYLET_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_AYLET_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_AYLET_TEMP}
	mv ${EXTTEMP}/aylet-${AYLET_VERSION} ${EXTTEMP}/${NTI_AYLET_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_AYLET_CONFIGURED}: ${NTI_AYLET_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AYLET_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/	{ s%$$%\nCFLAGS='"` ${NCURSES_CONFIG_TOOL} --cflags `"'% ; s%$$%\nLDFLAGS=-L'` ${NCURSES_CONFIG_TOOL} --libdir `'% }' \
			| sed '/^CFLAGS/	s/=/+=/' \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/	ln/	{ s/ln/if [ -f xaylet ]; then ln/ ; s/$$/; fi/ }' \
			| sed '/(CURSES_LIB)/	s%(OBJS)%(OBJS) $${LDFLAGS}%' \
			> Makefile \
	)
#			| sed '/^CC/	{ s%$$%\nCFLAGS=-I'` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix ncurses `'/include -I'` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix ncurses `'/include/ncurses% ; s%$$%\nLDFLAGS=-L'` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix ncurses `'/lib% }' \


## ,-----
## |	Build
## +-----

${NTI_AYLET_BUILT}: ${NTI_AYLET_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AYLET_TEMP} || exit 1 ;\
		make aylet \
	)


## ,-----
## |	Install
## +-----

${NTI_AYLET_INSTALLED}: ${NTI_AYLET_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_AYLET_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-aylet
nti-aylet: nti-ncurses ${NTI_AYLET_INSTALLED}

ALL_NTI_TARGETS+= nti-aylet

endif	# HAVE_AYLET_CONFIG
