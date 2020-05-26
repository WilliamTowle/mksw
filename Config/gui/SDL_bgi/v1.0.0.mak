# SDL_bgi v1.0.0		[ since v1.0.0, c.2014-11-13 ]
# last mod WmT, 2014-11-13	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_SDL_BGI_CONFIG},y)
HAVE_SDL_BGI_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-SDL_bgi' -- SDL_bgi"

ifeq (${SDL_BGI_VERSION},)
SDL_BGI_VERSION=1.0.0
endif

SDL_BGI_SRC=${SOURCES}/s/SDL_bgi-${SDL_BGI_VERSION}.tar.gz
URLS+= http://libxbgi.sourceforge.net/SDL_bgi-1.0.0.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_gfx/v2.0.25.mak

NTI_SDL_BGI_TEMP=nti-SDL_bgi-${SDL_BGI_VERSION}

NTI_SDL_BGI_EXTRACTED=${EXTTEMP}/${NTI_SDL_BGI_TEMP}/src/SDL_bgi.h
NTI_SDL_BGI_CONFIGURED=${EXTTEMP}/${NTI_SDL_BGI_TEMP}/src/Makefile
NTI_SDL_BGI_BUILT=${EXTTEMP}/${NTI_SDL_BGI_TEMP}/src/libSDL_bgi.so
NTI_SDL_BGI_INSTALLED=${NTI_TC_ROOT}/usr/lib/libSDL_bgi.so


## ,-----
## |	Extract
## +-----

${NTI_SDL_BGI_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL_bgi-${SDL_BGI_VERSION} ] || rm -rf ${EXTTEMP}/SDL_bgi-${SDL_BGI_VERSION}
	zcat ${SDL_BGI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL_BGI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_BGI_TEMP}
	mv ${EXTTEMP}/SDL_bgi-${SDL_BGI_VERSION} ${EXTTEMP}/${NTI_SDL_BGI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDL_BGI_CONFIGURED}: ${NTI_SDL_BGI_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_BGI_TEMP} || exit 1 ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD ;\
		cat src/Makefile.OLD \
			| sed '/^INC_DIR/	s%/usr[^ ]*%'${NTI_TC_ROOT}'/usr/include%' \
			| sed '/^LIB_DIR/	s%/usr[^ ]*%'${NTI_TC_ROOT}'/usr/lib%' \
			| sed '/^CFLAGS/	s%$$% -I'${NTI_TC_ROOT}'/usr/include%' \
			> src/Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL_BGI_BUILT}: ${NTI_SDL_BGI_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_BGI_TEMP} || exit 1 ;\
		make -C src \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL_BGI_INSTALLED}: ${NTI_SDL_BGI_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL_BGI_TEMP} || exit 1 ;\
		make -C src install \
	)

##

.PHONY: nti-SDL_bgi
nti-SDL_bgi: nti-SDL nti-SDL_gfx ${NTI_SDL_BGI_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL_bgi

endif	# HAVE_SDL_BGI_CONFIG
