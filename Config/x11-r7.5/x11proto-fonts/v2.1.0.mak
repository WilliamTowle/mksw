# x11proto-fonts v2.1.0		[ since v2.1.0, c.2013-03-03 ]
# last mod WmT, 2013-05-13	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_X11PROTO_FONTS_CONFIG},y)
HAVE_X11PROTO_FONTS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-fonts' -- x11proto-fonts"

ifeq (${X11PROTO_FONTS_VERSION},)
X11PROTO_FONTS_VERSION=2.1.0
endif

X11PROTO_FONTS_SRC=${SOURCES}/f/fontsproto-${X11PROTO_FONTS_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/fontsproto-2.1.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_FONTS_TEMP=nti-x11proto-fonts-${X11PROTO_FONTS_VERSION}

NTI_X11PROTO_FONTS_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP}/configure
NTI_X11PROTO_FONTS_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP}/config.status
NTI_X11PROTO_FONTS_BUILT=${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP}/fontsproto.pc
NTI_X11PROTO_FONTS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/fontsproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_FONTS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/fontsproto-${X11PROTO_FONTS_VERSION} ] || rm -rf ${EXTTEMP}/fontsproto-${X11PROTO_FONTS_VERSION}
	bzcat ${X11PROTO_FONTS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP}
	mv ${EXTTEMP}/fontsproto-${X11PROTO_FONTS_VERSION} ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_FONTS_CONFIGURED}: ${NTI_X11PROTO_FONTS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --enable-shared --disable-static \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_FONTS_BUILT}: ${NTI_X11PROTO_FONTS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_FONTS_INSTALLED}: ${NTI_X11PROTO_FONTS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_FONTS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-fonts
nti-x11proto-fonts: nti-pkg-config ${NTI_X11PROTO_FONTS_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-fonts

endif	# HAVE_X11PROTO_FONTS_CONFIG
