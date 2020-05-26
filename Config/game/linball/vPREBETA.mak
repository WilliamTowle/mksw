# linball vPREBETA		[ since vPREBETA, c.2010-12-17 ]
# last mod WmT, 2017-08-21	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LINBALL_CONFIG},y)
HAVE_LINBALL_CONFIG:=y

#DESCRLIST+= "'nti-linball' -- linball"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${LINBALL_VERSION},)
LINBALL_VERSION=PREBETA
endif

LINBALL_SRC=${SOURCES}/l/linball.tar.gz
URLS+= http://linball.sourceforge.net/linball.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_ttf/v2.0.11.mak

NTI_LINBALL_TEMP=nti-linball-${LINBALL_VERSION}

NTI_LINBALL_EXTRACTED=${EXTTEMP}/${NTI_LINBALL_TEMP}/README
NTI_LINBALL_CONFIGURED=${EXTTEMP}/${NTI_LINBALL_TEMP}/Makefile.OLD
NTI_LINBALL_BUILT=${EXTTEMP}/${NTI_LINBALL_TEMP}/src/linball
NTI_LINBALL_INSTALLED=${NTI_TC_ROOT}/usr/bin/linball


## ,-----
## |	Extract
## +-----

${NTI_LINBALL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/linball-${LINBALL_VERSION} ] || rm -rf ${EXTTEMP}/linball-${LINBALL_VERSION}
	[ ! -d ${EXTTEMP}/linball ] || rm -rf ${EXTTEMP}/linball
	zcat ${LINBALL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINBALL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINBALL_TEMP}
	#mv ${EXTTEMP}/linball-${LINBALL_VERSION}-src ${EXTTEMP}/${NTI_LINBALL_TEMP}
	mv ${EXTTEMP}/linball ${EXTTEMP}/${NTI_LINBALL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LINBALL_CONFIGURED}: ${NTI_LINBALL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINBALL_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CFLAGS/	s%sdl-config%'${SDL_CONFIG_TOOL}'%' \
			| sed '/^CFLAGS/	s%-lSDL%-I'"`${PKG_CONFIG_CONFIG_HOST_TOOL} --variable=prefix sdl`"'/include -lSDL%' \
			| sed '/^CFLAGS/	s%$$% -lm%' \
			| sed 's/pinball/linball/g' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LINBALL_BUILT}: ${NTI_LINBALL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINBALL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LINBALL_INSTALLED}: ${NTI_LINBALL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINBALL_TEMP} || exit 1 ;\
		echo '...' "(target missing)" '...' ; exit 1 ;\
		make install \
	)

##

.PHONY: nti-linball
nti-linball: nti-pkg-config \
	nti-SDL nti-SDL_mixer nti-SDL_ttf \
	${NTI_LINBALL_INSTALLED}

ALL_NTI_TARGETS+= nti-linball

endif	# HAVE_LINBALL_CONFIG
