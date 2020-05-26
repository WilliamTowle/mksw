# SDL v2.0.5			[ since v1.2.9, c.2004-06-29 ]
# last mod WmT, 2017-07-20	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SDL2_CONFIG},y)
HAVE_SDL2_CONFIG:=y

#DESCRLIST+= "'nti-SDL' -- SDL"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${SDL2_VERSION},)
#SDL2_VERSION=2.0.3
SDL2_VERSION=2.0.5
endif

SDL2_SRC=${SOURCES}/s/SDL2-${SDL2_VERSION}.tar.gz
URLS+= http://www.libsdl.org/release/SDL2-${SDL2_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_SDL2_TEMP=nti-SDL2-${SDL2_VERSION}

NTI_SDL2_EXTRACTED=${EXTTEMP}/${NTI_SDL2_TEMP}/sdl2.pc.in
NTI_SDL2_CONFIGURED=${EXTTEMP}/${NTI_SDL2_TEMP}/sdl2.pc
NTI_SDL2_BUILT=${EXTTEMP}/${NTI_SDL2_TEMP}/build/libSDL2.la
NTI_SDL2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sdl2.pc


## ,-----
## |	Extract
## +-----

${NTI_SDL2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/SDL2-${SDL2_VERSION} ] || rm -rf ${EXTTEMP}/SDL2-${SDL2_VERSION}
	zcat ${SDL2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDL2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL2_TEMP}
	mv ${EXTTEMP}/SDL2-${SDL2_VERSION} ${EXTTEMP}/${NTI_SDL2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDL2_CONFIGURED}: ${NTI_SDL2_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--without-x \
			--disable-video-opengl \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^	/	s%$$(libdir)/pkgconfig%'${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_SDL2_BUILT}: ${NTI_SDL2_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_SDL2_INSTALLED}: ${NTI_SDL2_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SDL2_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/sdl2.pc ${NTI_SDL2_INSTALLED} \

##

.PHONY: nti-SDL2
nti-SDL2: nti-libtool nti-pkg-config \
	${NTI_SDL2_INSTALLED}

ALL_NTI_TARGETS+= nti-SDL2

endif	# HAVE_SDL2_CONFIG
