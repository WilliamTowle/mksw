# util-macros v1.3.0		[ since v1.17.1, 2015-10-06 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_UTIL_MACROS_CONFIG},y)
HAVE_UTIL_MACROS_CONFIG:=y

#DESCRLIST+= "'nti-util-macros' -- util-macros"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${UTIL_MACROS_VERSION},)
UTIL_MACROS_VERSION=1.3.0
endif

#UTIL_MACROS_SRC=${SOURCES}/u/util-macros-${UTIL_MACROS_VERSION}.tar.gz
UTIL_MACROS_SRC=${SOURCES}/u/util-macros-${UTIL_MACROS_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/util/util-macros-1.3.0.tar.bz2

# deps?
#include ${CFG_ROOT}/gui/x11proto/v7.0.28.mak


NTI_UTIL_MACROS_TEMP=nti-util-macros-${UTIL_MACROS_VERSION}

NTI_UTIL_MACROS_EXTRACTED=${EXTTEMP}/${NTI_UTIL_MACROS_TEMP}/configure
NTI_UTIL_MACROS_CONFIGURED=${EXTTEMP}/${NTI_UTIL_MACROS_TEMP}/config.status
NTI_UTIL_MACROS_BUILT=${EXTTEMP}/${NTI_UTIL_MACROS_TEMP}/xorg-macros.m4
NTI_UTIL_MACROS_INSTALLED=${NTI_TC_ROOT}/usr/share/aclocal/xorg-macros.m4


## ,-----
## |	Extract
## +-----

${NTI_UTIL_MACROS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/util-macros-${UTIL_MACROS_VERSION} ] || rm -rf ${EXTTEMP}/util-macros-${UTIL_MACROS_VERSION}
	bzcat ${UTIL_MACROS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP}
	mv ${EXTTEMP}/util-macros-${UTIL_MACROS_VERSION} ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_UTIL_MACROS_CONFIGURED}: ${NTI_UTIL_MACROS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP} || exit 1 ;\
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
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_UTIL_MACROS_BUILT}: ${NTI_UTIL_MACROS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_UTIL_MACROS_INSTALLED}: ${NTI_UTIL_MACROS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UTIL_MACROS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-util-macros
nti-util-macros: nti-pkg-config \
	${NTI_UTIL_MACROS_INSTALLED}

ALL_NTI_TARGETS+= nti-util-macros

endif	# HAVE_UTIL_MACROS_CONFIG
