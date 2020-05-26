# xfishtank v2.1tp		[ since v2.1tp, c. 2016-12-28 ]
# last mod WmT, 2016-12-28	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XFISHTANK_CONFIG},y)
HAVE_XFISHTANK_CONFIG:=y

DESCRLIST+= "'nti-xfishtank' -- xfishtank"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XFISHTANK_VERSION},)
XFISHTANK_VERSION=2.1tp
endif

XFISHTANK_SRC=${SOURCES}/x/xfishtank-${XFISHTANK_VERSION}.tar.gz
URLS+= http://ibiblio.org/pub/Linux/X11/demos/xfishtank-2.1tp.tar.gz

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/x11-r7.5/libXaw/v1.0.7.mak
##include ${CFG_ROOT}/x11-r7.6/libXaw/v1.0.8.mak
#include ${CFG_ROOT}/x11-r7.5/libXmu/v1.0.5.mak
##include ${CFG_ROOT}/x11-r7.6/libXmu/v1.1.0.mak
#include ${CFG_ROOT}/x11-r7.5/libXrender/v0.9.5.mak
##include ${CFG_ROOT}/x11-r7.6/libXrender/v0.9.6.mak

NTI_XFISHTANK_TEMP=nti-xfishtank-${XFISHTANK_VERSION}

NTI_XFISHTANK_EXTRACTED=${EXTTEMP}/${NTI_XFISHTANK_TEMP}/README
NTI_XFISHTANK_CONFIGURED=${EXTTEMP}/${NTI_XFISHTANK_TEMP}/config.log
NTI_XFISHTANK_BUILT=${EXTTEMP}/${NTI_XFISHTANK_TEMP}/xfishtank
NTI_XFISHTANK_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xfishtank


## ,-----
## |	Extract
## +-----

${NTI_XFISHTANK_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xfishtank-${XFISHTANK_VERSION} ] || rm -rf ${EXTTEMP}/xfishtank-${XFISHTANK_VERSION}
	#[ ! -d ${EXTTEMP}/xfishtank ] || rm -rf ${EXTTEMP}/xfishtank
	zcat ${XFISHTANK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XFISHTANK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XFISHTANK_TEMP}
	mv ${EXTTEMP}/xfishtank-${XFISHTANK_VERSION} ${EXTTEMP}/${NTI_XFISHTANK_TEMP}
	#mv ${EXTTEMP}/xfishtank ${EXTTEMP}/${NTI_XFISHTANK_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XFISHTANK_CONFIGURED}: ${NTI_XFISHTANK_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XFISHTANK_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--without-xft \
			--without-xkb \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_XFISHTANK_BUILT}: ${NTI_XFISHTANK_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XFISHTANK_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XFISHTANK_INSTALLED}: ${NTI_XFISHTANK_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XFISHTANK_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xfishtank
nti-xfishtank: nti-pkg-config \
	nti-libX11 \
	${NTI_XFISHTANK_INSTALLED}

ALL_NTI_TARGETS+= nti-xfishtank

endif	# HAVE_XFISHTANK_CONFIG
