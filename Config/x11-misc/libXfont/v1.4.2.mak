# libXfont v1.4.2		[ since v1.4.1 c.2013-03-04 ]
# last mod WmT, 2015-10-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXFONT_CONFIG},y)
HAVE_LIBXFONT_CONFIG:=y

#DESCRLIST+= "'nti-libXfont' -- libXfont"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXFONT_VERSION},)
#LIBXFONT_VERSION=1.4.1
LIBXFONT_VERSION=1.4.2
endif

LIBXFONT_SRC=${SOURCES}/l/libXfont-${LIBXFONT_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/everything/libXfont-1.4.1.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/gui/libfontenc/v1.1.0.mak
include ${CFG_ROOT}/gui/x11proto/v7.0.28.mak
include ${CFG_ROOT}/gui/x11proto-fonts/v2.1.1.mak
include ${CFG_ROOT}/gui/xtrans/v1.2.7.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_LIBXFONT_TEMP=nti-libXfont-${LIBXFONT_VERSION}

NTI_LIBXFONT_EXTRACTED=${EXTTEMP}/${NTI_LIBXFONT_TEMP}/configure
NTI_LIBXFONT_CONFIGURED=${EXTTEMP}/${NTI_LIBXFONT_TEMP}/config.status
NTI_LIBXFONT_BUILT=${EXTTEMP}/${NTI_LIBXFONT_TEMP}/xfont.pc
NTI_LIBXFONT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xfont.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXFONT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXfont-${LIBXFONT_VERSION} ] || rm -rf ${EXTTEMP}/libXfont-${LIBXFONT_VERSION}
	bzcat ${LIBXFONT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXFONT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXFONT_TEMP}
	mv ${EXTTEMP}/libXfont-${LIBXFONT_VERSION} ${EXTTEMP}/${NTI_LIBXFONT_TEMP}



## ,-----
## |	Configure
## +-----

## 1. Needs CFLAGS/LDFLAGS to find zlib library (TODO: ask pkg-config)

${NTI_LIBXFONT_CONFIGURED}: ${NTI_LIBXFONT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFONT_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		CFLAGS='-O2' \
		LIBS='-L'${NTI_TC_ROOT}'/usr/lib' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --enable-shared --disable-static \
			  --disable-freetype \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXFONT_BUILT}: ${NTI_LIBXFONT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFONT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXFONT_INSTALLED}: ${NTI_LIBXFONT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFONT_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_LIBXFONT_INSTALLED} ` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xfont.pc ${NTI_LIBXFONT_INSTALLED} \

.PHONY: nti-libXfont
nti-libXfont: nti-pkg-config \
	nti-x11proto \
	nti-x11proto-fonts \
	nti-libfontenc \
	nti-xtrans \
	nti-zlib \
	${NTI_LIBXFONT_INSTALLED}

ALL_NTI_TARGETS+= nti-libXfont

endif	# HAVE_LIBXFONT_CONFIG
