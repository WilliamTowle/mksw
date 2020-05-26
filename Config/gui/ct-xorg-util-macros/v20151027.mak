# ct-xorg-util-macros v20151027	[ since v20151027, c.2015-10-27 ]
# last mod WmT, 2015-10-27	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_CT_XORG_UTIL_MACROS_CONFIG},y)
HAVE_CT_XORG_UTIL_MACROS_CONFIG:=y

DESCRLIST+= "'nti-ct-xorg-util-macros' -- ct-xorg-util-macros"
DESCRLIST+= "'nui-ct-xorg-util-macros' -- ct-xorg-util-macros"

include ${CFG_ROOT}/ENV/buildtype.mak

# TODO: pkg-config for retrieving X11 includes/libs
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${CT_XORG_UTIL_MACROS_VERSION},)
CT_XORG_UTIL_MACROS_VERSION=20151027
endif

CT_XORG_UTIL_MACROS_SRC=git://git.baserock.org/delta/xorg-util-macros
URLS+= git://git.baserock.org/delta/xorg-util-macros

# deps?
#include ${CFG_ROOT}/gui/libXdamage/v1.1.4.mak
#include ${CFG_ROOT}/gui/libXext/v1.3.2.mak
#include ${CFG_ROOT}/gui/wayland/v1.8.1.mak

NUI_CT_XORG_UTIL_MACROS_TEMP=nui-ct-xorg-util-macros-${CT_XORG_UTIL_MACROS_VERSION}

NUI_CT_XORG_UTIL_MACROS_EXTRACTED=${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP}/.git
NUI_CT_XORG_UTIL_MACROS_CONFIGURED=${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP}/config.status
NUI_CT_XORG_UTIL_MACROS_BUILT=${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP}/FOO.pc
NUI_CT_XORG_UTIL_MACROS_INSTALLED=/usr/lib/pkgconfig/FOO.pc


## ,-----
## |	Extract
## +-----

${NUI_CT_XORG_UTIL_MACROS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	( mkdir -p ${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP} ;\
		git clone ${CT_XORG_UTIL_MACROS_SRC} \
			${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP} \
	)


## ,-----
## |	Configure
## +-----

${NUI_CT_XORG_UTIL_MACROS_CONFIGURED}: ${NUI_CT_XORG_UTIL_MACROS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP} || exit 1 ;\
		autoreconf -ivf ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=/usr \
			  --enable-shared --disable-static \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NUI_CT_XORG_UTIL_MACROS_BUILT}: ${NUI_CT_XORG_UTIL_MACROS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CT_XORG_UTIL_MACROS_FLOATABI=hardfp

${NUI_CT_XORG_UTIL_MACROS_INSTALLED}: ${NUI_CT_XORG_UTIL_MACROS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NUI_CT_XORG_UTIL_MACROS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nui-ct-xorg-util-macros
nui-ct-xorg-util-macros: ${NUI_CT_XORG_UTIL_MACROS_INSTALLED}

ALL_NUI_TARGETS+= nui-ct-xorg-util-macros

endif	# HAVE_CT_XORG_UTIL_MACROS_CONFIG
