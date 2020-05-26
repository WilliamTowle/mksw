# sdlblock v1.2			[ EARLIEST v1.2, c.2013-01-21 ]
# last mod WmT, 2013-04-12	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_SDLBLOCK_CONFIG},y)
HAVE_SDLBLOCK_CONFIG:=y

#DESCRLIST+= "'nti-sdlblock' -- sdlblock"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SDLBLOCK_VERSION},)
SDLBLOCK_VERSION=1.2
endif

SDLBLOCK_SRC=${SOURCES}/s/SDLBlockv${SDLBLOCK_VERSION}.zip
URLS+= 'http://downloads.sourceforge.net/project/sdlblock/sdlblock/SDLBlock-1.2/SDLBlockv1.2.zip?r=&ts=1358433065&use_mirror=heanet'

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak

NTI_SDLBLOCK_TEMP=nti-sdlblock-${SDLBLOCK_VERSION}

NTI_SDLBLOCK_EXTRACTED=${EXTTEMP}/${NTI_SDLBLOCK_TEMP}/src/Blocks.cpp
NTI_SDLBLOCK_CONFIGURED=${EXTTEMP}/${NTI_SDLBLOCK_TEMP}/Makefile.OLD
NTI_SDLBLOCK_BUILT=${EXTTEMP}/${NTI_SDLBLOCK_TEMP}/src/sdlblock
NTI_SDLBLOCK_INSTALLED=${NTI_TC_ROOT}/usr/bin/sdlblock


## ,-----
## |	Extract
## +-----

## [2015-01-06] fixed to suit zipfile with source in subdirectory

${NTI_SDLBLOCK_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/-${SDLBLOCK_VERSION} ] || rm -rf ${EXTTEMP}/sdlblock-${SDLBLOCK_VERSION}
	[ ! -d ${EXTTEMP}/SDLBlockv${SDLBLOCK_VERSION} ] || rm -rf ${EXTTEMP}/SDLBlockv${SDLBLOCK_VERSION}
	#zcat ${SDLBLOCK_SRC} | tar xvf - -C ${EXTTEMP}
	unzip -d ${EXTTEMP} ${SDLBLOCK_SRC}
	[ ! -d ${EXTTEMP}/${NTI_SDLBLOCK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDLBLOCK_TEMP}
	#mv ${EXTTEMP}/sdlblock-${SDLBLOCK_VERSION} ${EXTTEMP}/${NTI_SDLBLOCK_TEMP}
	mv ${EXTTEMP}/SDLBlockv${SDLBLOCK_VERSION} ${EXTTEMP}/${NTI_SDLBLOCK_TEMP}


## ,-----
## |	Configure
## +-----

## TODO: -SDL_MIXER should be '-D...'?
## TODO: where/what is GL/glaux.h?

${NTI_SDLBLOCK_CONFIGURED}: ${NTI_SDLBLOCK_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLBLOCK_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed 's///' \
			| sed '/\.cpp/		{ s%Blocks%src/Blocks%g ; s%CGl%src/CGl%g ; s%CMenu%src/CMenu%g ; s%CSound%src/CSound%g ; s%Font%src/Font%g ; s%glBlock%src/glBlock%g ; s%log%src/log%g ; s%opengl%src/opengl%g ; s%texture%src/texture%g ; s%Win%src/Win%g ; s% \*\.h%% }' \
			| sed '/SDL-CONFIG/	{ s%SDL-CONFIG%'${NTI_TC_ROOT}'/usr/bin/sdl-config% ; s/--CFLAGS/--cflags/ ; s/--LIBS/--libs/ }' \
			| sed '/^	/	s/-SDL_MIXER//' \
			| sed '/^	cd src/	d' \
			| sed '/^	/	s/($$CC)/$$(CC)/' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_SDLBLOCK_BUILT}: ${NTI_SDLBLOCK_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLBLOCK_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SDLBLOCK_INSTALLED}: ${NTI_SDLBLOCK_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDLBLOCK_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-sdlblock
nti-sdlblock: nti-SDL ${NTI_SDLBLOCK_INSTALLED}

ALL_NTI_TARGETS+= nti-sdlblock

endif	# HAVE_SDLBLOCK_CONFIG
