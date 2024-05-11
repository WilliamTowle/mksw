# libxkbfile v1.0.7		[ since v1.9, c.2013-01-04 ]
# last mod WmT, 2015-10-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXKBFILE_CONFIG},y)
HAVE_LIBXKBFILE_CONFIG:=y

#DESCRLIST+= "'nti-libxkbfile' -- libxkbfile"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXKBFILE_VERSION},)
#LIBXKBFILE_VERSION=1.0.6
LIBXKBFILE_VERSION=1.0.7
endif

LIBXKBFILE_SRC=${SOURCES}/l/libxkbfile-${LIBXKBFILE_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libxkbfile-1.0.6.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libxkbfile-1.0.7.tar.bz2

include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak
include ${CFG_ROOT}/x11-misc/x11proto-kb/v1.0.6.mak


NTI_LIBXKBFILE_TEMP=nti-libxkbfile-${LIBXKBFILE_VERSION}

NTI_LIBXKBFILE_EXTRACTED=${EXTTEMP}/${NTI_LIBXKBFILE_TEMP}/configure
NTI_LIBXKBFILE_CONFIGURED=${EXTTEMP}/${NTI_LIBXKBFILE_TEMP}/config.status
NTI_LIBXKBFILE_BUILT=${EXTTEMP}/${NTI_LIBXKBFILE_TEMP}/xkbfile.pc
NTI_LIBXKBFILE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xkbfile.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXKBFILE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxkbfile-${LIBXKBFILE_VERSION} ] || rm -rf ${EXTTEMP}/libxkbfile-${LIBXKBFILE_VERSION}
	bzcat ${LIBXKBFILE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP}
	mv ${EXTTEMP}/libxkbfile-${LIBXKBFILE_VERSION} ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXKBFILE_CONFIGURED}: ${NTI_LIBXKBFILE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXKBFILE_BUILT}: ${NTI_LIBXKBFILE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXKBFILE_INSTALLED}: ${NTI_LIBXKBFILE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXKBFILE_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_LIBXKBFILE_INSTALLED} ` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xkbfile.pc ${NTI_LIBXKBFILE_INSTALLED} \

.PHONY: nti-libxkbfile
nti-libxkbfile: nti-pkg-config nti-libX11 nti-x11proto-kb ${NTI_LIBXKBFILE_INSTALLED}

ALL_NTI_TARGETS+= nti-libxkbfile

endif	# HAVE_LIBXKBFILE_CONFIG
