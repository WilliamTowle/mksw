# ct-xcb-pthread-stubs v20151027	[ since v20151027, c.2015-10-27 ]
# last mod WmT, 2015-10-27	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_CT_XCB_PTHREAD_STUBS_CONFIG},y)
HAVE_CT_XCB_PTHREAD_STUBS_CONFIG:=y

DESCRLIST+= "'nti-ct-xcb-pthread-stubs' -- ct-xcb-pthread-stubs"
DESCRLIST+= "'nui-ct-xcb-pthread-stubs' -- ct-xcb-pthread-stubs"

include ${CFG_ROOT}/ENV/buildtype.mak

# TODO: pkg-config for retrieving X11 includes/libs
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${CT_XCB_PTHREAD_STUBS_VERSION},)
CT_XCB_PTHREAD_STUBS_VERSION=20151027
endif

CT_XCB_PTHREAD_STUBS_SRC=git://git.baserock.org/delta/xcb-pthread-stubs
URLS+= git://git.baserock.org/delta/xcb-pthread-stubs

# deps?
#include ${CFG_ROOT}/gui/libXdamage/v1.1.4.mak
#include ${CFG_ROOT}/gui/libXext/v1.3.2.mak
#include ${CFG_ROOT}/gui/wayland/v1.8.1.mak

NUI_CT_XCB_PTHREAD_STUBS_TEMP=nui-ct-xcb-pthread-stubs-${CT_XCB_PTHREAD_STUBS_VERSION}

NUI_CT_XCB_PTHREAD_STUBS_EXTRACTED=${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP}/.git
NUI_CT_XCB_PTHREAD_STUBS_CONFIGURED=${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP}/config.status
NUI_CT_XCB_PTHREAD_STUBS_BUILT=${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP}/pthread-stubs.pc
NUI_CT_XCB_PTHREAD_STUBS_INSTALLED=/usr/lib/pkgconfig/pthread-stubs.pc


## ,-----
## |	Extract
## +-----

${NUI_CT_XCB_PTHREAD_STUBS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	( mkdir -p ${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP} ;\
		git clone ${CT_XCB_PTHREAD_STUBS_SRC} \
			${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP} \
	)


## ,-----
## |	Configure
## +-----

${NUI_CT_XCB_PTHREAD_STUBS_CONFIGURED}: ${NUI_CT_XCB_PTHREAD_STUBS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP} || exit 1 ;\
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

${NUI_CT_XCB_PTHREAD_STUBS_BUILT}: ${NUI_CT_XCB_PTHREAD_STUBS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CT_XCB_PTHREAD_STUBS_FLOATABI=hardfp

${NUI_CT_XCB_PTHREAD_STUBS_INSTALLED}: ${NUI_CT_XCB_PTHREAD_STUBS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NUI_CT_XCB_PTHREAD_STUBS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nui-ct-xcb-pthread-stubs
nui-ct-xcb-pthread-stubs: ${NUI_CT_XCB_PTHREAD_STUBS_INSTALLED}

ALL_NUI_TARGETS+= nui-ct-xcb-pthread-stubs

endif	# HAVE_CT_XCB_PTHREAD_STUBS_CONFIG
