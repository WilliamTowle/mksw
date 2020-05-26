# rezerwar v0.4.2		[ EARLIEST v?.?? ]
# last mod WmT, 2013-01-21	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_REZERWAR_CONFIG},y)
HAVE_REZERWAR_CONFIG:=y

#DESCRLIST+= "'nti-rezerwar' -- rezerwar"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${REZERWAR_VERSION},)
REZERWAR_VERSION=0.4.2
endif

REZERWAR_SRC=${SOURCES}/r/rezerwar-${REZERWAR_VERSION}.tar.gz
URLS+= https://tamentis.com/projects/rezerwar/files/rezerwar-0.4.2.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak


NTI_REZERWAR_TEMP=nti-rezerwar-${REZERWAR_VERSION}

NTI_REZERWAR_EXTRACTED=${EXTTEMP}/${NTI_REZERWAR_TEMP}/configure
NTI_REZERWAR_CONFIGURED=${EXTTEMP}/${NTI_REZERWAR_TEMP}/Makefile.OLD
NTI_REZERWAR_BUILT=${EXTTEMP}/${NTI_REZERWAR_TEMP}/src/rezerwar
NTI_REZERWAR_INSTALLED=${NTI_TC_ROOT}/usr/games/rezerwar


## ,-----
## |	Extract
## +-----

${NTI_REZERWAR_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/rezerwar-${REZERWAR_VERSION} ] || rm -rf ${EXTTEMP}/rezerwar-${REZERWAR_VERSION}
	zcat ${REZERWAR_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_REZERWAR_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_REZERWAR_TEMP}
	mv ${EXTTEMP}/rezerwar-${REZERWAR_VERSION} ${EXTTEMP}/${NTI_REZERWAR_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_REZERWAR_CONFIGURED}: ${NTI_REZERWAR_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_REZERWAR_TEMP} || exit 1 ;\
		SDL_CONFIG=${NTI_TC_ROOT}/usr/bin/sdl-config \
		  ./configure Linux \
			|| exit 1 ;\
		[ -r src/config.h.OLD ] || mv src/config.h src/config.h.OLD || exit 1 ;\
		cat src/config.h.OLD \
			| sed '/#define DATAPATH/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> src/config.h || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^TARGET_/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			> Makefile || exit 1 ;\
		[ -r src/Makefile.OLD ] || mv src/Makefile src/Makefile.OLD || exit 1 ;\
		cat src/Makefile.OLD \
			| sed '/^CC?=/	{ s/?// ; s%g*cc%'${NTI_GCC}'% }' \
			| sed '/^CFLAGS+=/	{ s%$$% '"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --cflags x11`"'% }' \
			| sed '/^LIBS+=/	{ s%$$% '"`${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --libs-only-L x11`"'% }' \
			> src/Makefile || exit 1 ;\
		[ -r src/menus.c.OLD ] || mv src/menus.c src/menus.c.OLD || exit 1 ;\
		cat src/menus.c.OLD \
			| sed 's%"music/menu.ogg"%dpath("music/menu.ogg")%' \
			> src/menus.c || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_REZERWAR_BUILT}: ${NTI_REZERWAR_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_REZERWAR_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_REZERWAR_INSTALLED}: ${NTI_REZERWAR_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_REZERWAR_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-rezerwar
nti-rezerwar: nti-pkg-config \
	nti-SDL nti-SDL_mixer ${NTI_REZERWAR_INSTALLED}

ALL_NTI_TARGETS+= nti-rezerwar

endif	# HAVE_REZERWAR_CONFIG
