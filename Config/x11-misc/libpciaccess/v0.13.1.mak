# libpciaccess v0.13.1		[ since v0.3, c. 2013-05-27 ]
# last mod WmT, 2016-01-13	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_X11PCIACCESS_CONFIG},y)
HAVE_X11PCIACCESS_CONFIG:=y

#DESCRLIST+= "'nti-libpciaccess' -- libpciaccess"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.6.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak

ifeq (${X11PCIACCESS_VERSION},)
#X11PCIACCESS_VERSION=0.10.9
X11PCIACCESS_VERSION=0.13.1
endif

X11PCIACCESS_SRC=${SOURCES}/l/libpciaccess-${X11PCIACCESS_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libpciaccess-0.10.9.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.7/src/lib/libpciaccess-0.13.1.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libpciaccess-0.13.1.tar.bz2


NTI_X11PCIACCESS_TEMP=nti-libpciaccess-${X11PCIACCESS_VERSION}

NTI_X11PCIACCESS_EXTRACTED=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/configure
NTI_X11PCIACCESS_CONFIGURED=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/Makefile.OLD
NTI_X11PCIACCESS_BUILT=${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}/pciaccess.pc
NTI_X11PCIACCESS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/pciaccess.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PCIACCESS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libpciaccess-${X11PCIACCESS_VERSION} ] || rm -rf ${EXTTEMP}/libpciaccess-${X11PCIACCESS_VERSION}
	bzcat ${X11PCIACCESS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}
	mv ${EXTTEMP}/libpciaccess-${X11PCIACCESS_VERSION} ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PCIACCESS_CONFIGURED}: ${NTI_X11PCIACCESS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
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

${NTI_X11PCIACCESS_BUILT}: ${NTI_X11PCIACCESS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PCIACCESS_INSTALLED}: ${NTI_X11PCIACCESS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PCIACCESS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libpciaccess
nti-libpciaccess: nti-pkg-config ${NTI_X11PCIACCESS_INSTALLED}

ALL_NTI_TARGETS+= nti-libpciaccess

endif	# HAVE_X11PCIACCESS_CONFIG
