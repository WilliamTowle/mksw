# libXaw v1.0.7			[ since v1.0.7,	2013-04-13 ]
# last mod WmT, 2014-02-24	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LIBXAW_CONFIG},y)
HAVE_LIBXAW_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-libXaw' -- libXaw"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXAW_VERSION},)
LIBXAW_VERSION=1.0.7
endif
LIBXAW_SRC=${SOURCES}/l/libXaw-${LIBXAW_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXaw-1.0.7.tar.bz2


include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.5/libXext/v1.1.1.mak
include ${CFG_ROOT}/x11-r7.5/libXmu/v1.0.5.mak
#include ${CFG_ROOT}/gui/libXpm/v3.5.8.mak
include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak


NTI_LIBXAW_TEMP=nti-libXaw-${LIBXAW_VERSION}

NTI_LIBXAW_EXTRACTED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/configure
NTI_LIBXAW_CONFIGURED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/config.status
NTI_LIBXAW_BUILT=${EXTTEMP}/${NTI_LIBXAW_TEMP}/xaw6.pc
NTI_LIBXAW_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xaw7.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXAW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXaw-${LIBXAW_VERSION} ] || rm -rf ${EXTTEMP}/libXaw-${LIBXAW_VERSION}
	bzcat ${LIBXAW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXAW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXAW_TEMP}
	mv ${EXTTEMP}/libXaw-${LIBXAW_VERSION} ${EXTTEMP}/${NTI_LIBXAW_TEMP}



## ,-----
## |	Configure
## +-----

## 2014-02-19: no specs: modern pdf/postscript generation tools barf :(

${NTI_LIBXAW_CONFIGURED}: ${NTI_LIBXAW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 ;\
		mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^SUBDIRS/	s/spec[s]*//' \
			> Makefile || exit 1 \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


## ,-----
## |	Build
## +-----

${NTI_LIBXAW_BUILT}: ${NTI_LIBXAW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXAW_INSTALLED}: ${NTI_LIBXAW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make install ;\
		mkdir -p ` dirname ${NTI_LIBXAW_INSTALLED} ` ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xaw6.pc `dirname ${NTI_LIBXAW_INSTALLED}`/libxaw6.pc ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xaw7.pc ${NTI_LIBXAW_INSTALLED} \
	)

.PHONY: nti-libXaw
nti-libXaw: nti-pkg-config nti-libX11 nti-libXext nti-libXmu nti-libXt nti-x11proto-xext ${NTI_LIBXAW_INSTALLED}
#nti-libXaw: nti-pkg-config nti-libX11 nti-libXext nti-libXmu nti-libXpm nti-libXt nti-x11proto-xext ${NTI_LIBXAW_INSTALLED}

ALL_NTI_TARGETS+= nti-libXaw

endif	# HAVE_LIBXAW_CONFIG
