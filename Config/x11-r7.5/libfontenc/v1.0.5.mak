# libfontenc v1.0.5		[ since v1.0.5, c.2013-01-04 ]
# last mod WmT, 2015-10-20	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_LIBFONTENC_CONFIG},y)
HAVE_LIBFONTENC_CONFIG:=y

#DESCRLIST+= "'nti-libfontenc' -- libfontenc"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBFONTENC_VERSION},)
LIBFONTENC_VERSION=1.0.5
endif

LIBFONTENC_SRC=${SOURCES}/l/libfontenc-1.0.5.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/lib/libfontenc-1.0.5.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_LIBFONTENC_TEMP=nti-libfontenc-${LIBFONTENC_VERSION}

NTI_LIBFONTENC_EXTRACTED=${EXTTEMP}/${NTI_LIBFONTENC_TEMP}/fontenc.pc.in
NTI_LIBFONTENC_CONFIGURED=${EXTTEMP}/${NTI_LIBFONTENC_TEMP}/config.status
NTI_LIBFONTENC_BUILT=${EXTTEMP}/${NTI_LIBFONTENC_TEMP}/fontenc.pc
NTI_LIBFONTENC_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/fontenc.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBFONTENC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libfontenc-${LIBFONTENC_VERSION} ] || rm -rf ${EXTTEMP}/libfontenc-${LIBFONTENC_VERSION}
	bzcat ${LIBFONTENC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBFONTENC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBFONTENC_TEMP}
	mv ${EXTTEMP}/libfontenc-${LIBFONTENC_VERSION} ${EXTTEMP}/${NTI_LIBFONTENC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBFONTENC_CONFIGURED}: ${NTI_LIBFONTENC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBFONTENC_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBFONTENC_BUILT}: ${NTI_LIBFONTENC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBFONTENC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBFONTENC_INSTALLED}: ${NTI_LIBFONTENC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBFONTENC_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libfontenc
nti-libfontenc: nti-pkg-config nti-x11proto nti-zlib ${NTI_LIBFONTENC_INSTALLED}

ALL_NTI_TARGETS+= nti-libfontenc

endif	# HAVE_LIBFONTENC_CONFIG
