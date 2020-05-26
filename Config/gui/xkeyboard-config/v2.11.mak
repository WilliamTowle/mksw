# xkeyboard-config v2.11	[ since v2.7, c.2013-04-14 ]
# last mod WmT, 2015-10-23	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_XKEYBOARD_CONFIG},y)
HAVE_XKEYBOARD_CONFIG_CONFIG:=y

#DESCRLIST+= "'nti-xkeyboard-config' -- xkeyboard-config"

include ${CFG_ROOT}/ENV/buildtype.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${XKEYBOARD_CONFIG_VERSION},)
#XKEYBOARD_CONFIG_VERSION=2.8
XKEYBOARD_CONFIG_VERSION=2.11
endif

XKEYBOARD_CONFIG_SRC=${SOURCES}/x/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/data/xkeyboard-config/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}.tar.bz2

include ${CFG_ROOT}/misc/intltool/v0.40.6.mak
#...
include ${CFG_ROOT}/x11-misc/x11proto/v7.0.28.mak
include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak

NTI_XKEYBOARD_CONFIG_TEMP=nti-xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}

NTI_XKEYBOARD_CONFIG_EXTRACTED=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/configure
NTI_XKEYBOARD_CONFIG_CONFIGURED=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/config.status
NTI_XKEYBOARD_CONFIG_BUILT=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/xkeyboard-config.pc
NTI_XKEYBOARD_CONFIG_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xkeyboard-config.pc


## ,-----
## |	Extract
## +-----

${NTI_XKEYBOARD_CONFIG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}
	bzcat ${XKEYBOARD_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}
	mv ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION} ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XKEYBOARD_CONFIG_CONFIGURED}: ${NTI_XKEYBOARD_CONFIG_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_XKEYBOARD_CONFIG_BUILT}: ${NTI_XKEYBOARD_CONFIG_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XKEYBOARD_CONFIG_INSTALLED}: ${NTI_XKEYBOARD_CONFIG_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/share/pkgconfig/xkeyboard-config.pc ${NTI_XKEYBOARD_CONFIG_INSTALLED} \

.PHONY: nti-xkeyboard-config
nti-xkeyboard-config: nti-pkg-config nti-intltool \
	\
	nti-x11proto \
	nti-libX11 \
	${NTI_XKEYBOARD_CONFIG_INSTALLED} \

ALL_NTI_TARGETS+= nti-xkeyboard-config

endif	# HAVE_XKEYBOARD_CONFIG_CONFIG
