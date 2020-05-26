# SDL v1.2.14			[ since v1.2.9, c.2004-06-29 ]
# last mod WmT, 2011-09-27	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SDL_CONFIG},y)
HAVE_SDL_CONFIG:=y

DESCRLIST+= "'cti-SDL' -- SDL"
DESCRLIST+= "'nti-SDL' -- SDL"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

#SDL_VER=1.2.13
SDL_VER=1.2.14
SDL_SRC=${SRCDIR}/s/SDL-${SDL_VER}.tar.gz

URLS+=http://www.libsdl.org/release/SDL-${SDL_VER}.tar.gz


## ,-----
## |	Extract
## +-----

CTI_SDL_TEMP=cti-SDL-${SDL_VER}

CUI_SDL_TEMP=cui-SDL-${SDL_VER}

CUI_UCLIBC_RT_INSTTEMP=${EXTTEMP}/insttemp

CTI_SDL_EXTRACTED=${EXTTEMP}/${CTI_SDL_TEMP}/Makefile

NTI_SDL_TEMP=nti-SDL-${SDL_VER}
NTI_SDL_INSTTEMP=${CTI_TC_ROOT}

##

.PHONY: cti-SDL-extracted
cti-SDL-extracted: ${CTI_SDL_EXTRACTED}

${CTI_SDL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CTI_SDL_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_SDL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_SRC}
	mv ${EXTTEMP}/SDL-${SDL_VER} ${EXTTEMP}/${CTI_SDL_TEMP}

##

CUI_SDL_EXTRACTED=${EXTTEMP}/${CUI_SDL_TEMP}/Makefile

.PHONY: cui-SDL-extracted
cui-SDL-extracted: ${CUI_SDL_EXTRACTED}

${CUI_SDL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_SDL_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SDL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_SRC}
	mv ${EXTTEMP}/SDL-${SDL_VER} ${EXTTEMP}/${CUI_SDL_TEMP}

##

NTI_SDL_EXTRACTED=${EXTTEMP}/${NTI_SDL_TEMP}/Makefile

.PHONY: nti-SDL-extracted
nti-SDL-extracted: ${NTI_SDL_EXTRACTED}

${NTI_SDL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_SDL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SDL_SRC}
	mv ${EXTTEMP}/SDL-${SDL_VER} ${EXTTEMP}/${NTI_SDL_TEMP}


## ,-----
## |	Configure
## +-----

CTI_SDL_CONFIGURED=${EXTTEMP}/${CTI_SDL_TEMP}/config.status

.PHONY: cti-SDL-configured
cti-SDL-configured: cti-SDL-extracted ${CTI_SDL_CONFIGURED}

${CTI_SDL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_SDL_TEMP} || exit 1 ;\
		CC=${CTI_GCC} \
		  CFLAGS='-O2' \
		  LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
		  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
			./configure \
			  --prefix=${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr' \
			  --build=${NTI_SPEC} \
			  --host=${CTI_SPEC} \
			  --with-x=no \
			  || exit 1 \
	)

##

CUI_SDL_CONFIGURED=${EXTTEMP}/${CUI_SDL_TEMP}/config.status

.PHONY: cui-SDL-configured
cui-SDL-configured: cui-SDL-extracted ${CUI_SDL_CONFIGURED}

${CUI_SDL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_SDL_TEMP} || exit 1 ;\
		CC=${CUI_GCC} \
		  CFLAGS='-O2' \
		  LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
		  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
			./configure \
			  --prefix=/usr \
			  --build=${NTI_SPEC} \
			  --host=${CTI_SPEC} \
			  --with-x=no \
			  || exit 1 \
	)

##

NTI_SDL_CONFIGURED=${EXTTEMP}/${NTI_SDL_TEMP}/config.status

.PHONY: nti-SDL-configured
nti-SDL-configured: nti-SDL-extracted ${NTI_SDL_CONFIGURED}

${NTI_SDL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
			./configure \
			  --prefix=${NTI_SDL_INSTTEMP}/usr \
			  --build=${NTI_SPEC} \
			  --host=${NTI_SPEC} \
			  --with-x=no \
			  || exit 1 \
	)


## ,-----
## |	Build
## +-----

CTI_SDL_BUILT=${EXTTEMP}/${CTI_SDL_TEMP}/build/.libs/libSDL.a

.PHONY: cti-SDL-built
cti-SDL-built: cti-SDL-configured ${CTI_SDL_BUILT}

${CTI_SDL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_SDL_TEMP} || exit 1 ;\
		make \
			LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
			|| exit 1 \
	)

##

CUI_SDL_BUILT=${EXTTEMP}/${CUI_SDL_TEMP}/build/.libs/libSDL.a

.PHONY: cui-SDL-built
cui-SDL-built: cui-SDL-configured ${CUI_SDL_BUILT}

${CUI_SDL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_SDL_TEMP} || exit 1 ;\
		make \
			LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
			|| exit 1 \
	)

##

NTI_SDL_BUILT=${EXTTEMP}/${NTI_SDL_TEMP}/build/.libs/libSDL.a

.PHONY: nti-SDL-built
nti-SDL-built: nti-SDL-configured ${NTI_SDL_BUILT}

${NTI_SDL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make \
			LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
			|| exit 1 \
	)


## ,-----
## |	Install
## +-----

CTI_SDL_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/sdl.pc

.PHONY: cti-SDL-installed
cti-SDL-installed: cti-SDL-built ${CTI_SDL_INSTALLED}

${CTI_SDL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_SDL_TEMP} || exit 1 ;\
		make install \
		  	LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
	)

##

CUI_SDL_INSTALLED=${CUI_UCLIBC_RT_INSTTEMP}/usr/lib/pkgconfig/sdl.pc

.PHONY: cui-SDL-installed
cui-SDL-installed: cui-SDL-built ${CUI_SDL_INSTALLED}

${CUI_SDL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_SDL_TEMP} || exit 1 ;\
		make install \
			DESTDIR=${CUI_UCLIBC_RT_INSTTEMP} \
		  	LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
	)

##

NTI_SDL_INSTALLED=${NTI_SDL_INSTTEMP}/usr/lib/pkgconfig/sdl.pc

.PHONY: nti-SDL-installed
nti-SDL-installed: nti-SDL-built ${NTI_SDL_INSTALLED}

${NTI_SDL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SDL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-SDL
nti-SDL: nti-native-gcc nti-libtool nti-SDL-installed

NTARGETS+= nti-SDL

.PHONY: cti-SDL
cti-SDL: cti-cross-pkg-config cti-cross-libtool cti-cross-gcc cti-SDL-installed

.PHONY: cui-SDL
cui-SDL: cti-cross-pkg-config cti-cross-libtool cti-cross-gcc cui-SDL-installed

CTARGETS+= cti-SDL

endif	# HAVE_SDL_CONFIG
