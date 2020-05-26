# xkbutils v1.0.2		[ since v1.0.2, c.2013-04-13 ]
# last mod WmT, 2013-04-13	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XKBUTILS_CONFIG},y)
HAVE_XKBUTILS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xkbutils' -- xkbutils"

ifeq (${XKBUTILS_VERSION},)
XKBUTILS_VERSION=1.0.2
endif

XKBUTILS_SRC=${SOURCES}/x/xkbutils-${XKBUTILS_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/everything/xkbutils-1.0.2.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

NTI_XKBUTILS_TEMP=nti-xkbutils-${XKBUTILS_VERSION}

NTI_XKBUTILS_EXTRACTED=${EXTTEMP}/${NTI_XKBUTILS_TEMP}/configure
NTI_XKBUTILS_CONFIGURED=${EXTTEMP}/${NTI_XKBUTILS_TEMP}/config.status
NTI_XKBUTILS_BUILT=${EXTTEMP}/${NTI_XKBUTILS_TEMP}/xkbutils.pc
NTI_XKBUTILS_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xkbutils.pc


## ,-----
## |	Extract
## +-----

${NTI_XKBUTILS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xkbutils-${XKBUTILS_VERSION} ] || rm -rf ${EXTTEMP}/xkbutils-${XKBUTILS_VERSION}
	bzcat ${XKBUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XKBUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XKBUTILS_TEMP}
	mv ${EXTTEMP}/xkbutils-${XKBUTILS_VERSION} ${EXTTEMP}/${NTI_XKBUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XKBUTILS_CONFIGURED}: ${NTI_XKBUTILS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XKBUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


## ,-----
## |	Build
## +-----

${NTI_XKBUTILS_BUILT}: ${NTI_XKBUTILS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XKBUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XKBUTILS_INSTALLED}: ${NTI_XKBUTILS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XKBUTILS_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/share/pkgconfig/xkbutils.pc ${NTI_XKBUTILS_INSTALLED} \
	)

.PHONY: nti-xkbutils
nti-xkbutils: nti-pkg-config ${NTI_XKBUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-xkbutils

endif	# HAVE_XKBUTILS_CONFIG
