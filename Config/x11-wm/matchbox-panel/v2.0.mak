# matchbox-panel v2.0		[ since v2.0, 2017-12-22 ]
# last mod WmT, 2017-12-22	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_MATCHBOX_PANEL_CONFIG},y)
HAVE_MATCHBOX_PANEL_CONFIG:=y

#DESCRLIST+= "'cui-matchbox-panel' -- matchbox-panel"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${MATCHBOX_PANEL_VERSION},)
MATCHBOX_PANEL_VERSION=2.0
endif

MATCHBOX_PANEL_SRC=${SOURCES}/m/matchbox-panel-${MATCHBOX_PANEL_VERSION}.tar.bz2
URLS+= http://mirrors.kernel.org/yocto/matchbox/matchbox-panel/2.0/matchbox-panel-2.0.tar.bz2

include ${CFG_ROOT}/misc/glib/v2.52.0.mak
#	| No package 'gtk+-2.0' found
#	| No package 'gmodule-export-2.0' found

## SDL v1.x, because 'sdl-config' is expected
#include ${CFG_ROOT}/audvid/smpeg/v0.4.5.mak
#include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak
#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
##include ${CFG_ROOT}/gui/SDL/v2.0.5.mak
#include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak
##include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.5/libXfixes/v4.0.4.mak
#include ${CFG_ROOT}/x11-r7.5/libXxf86vm/v1.1.0.mak

NTI_MATCHBOX_PANEL_TEMP=nti-matchbox-panel-${MATCHBOX_PANEL_VERSION}
NTI_MATCHBOX_PANEL_EXTRACTED=${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP}/Makefile
NTI_MATCHBOX_PANEL_CONFIGURED=${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP}/Makefile.OLD
NTI_MATCHBOX_PANEL_BUILT=${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP}/matchbox-panel
NTI_MATCHBOX_PANEL_INSTALLED=${NTI_TC_ROOT}/usr/bin/matchbox-panel


# ,-----
# |	Extract
# +-----

${NTI_MATCHBOX_PANEL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/matchbox-panel-${MATCHBOX_PANEL_VERSION} ] || rm -rf ${EXTTEMP}/matchbox-panel-${MATCHBOX_PANEL_VERSION}
	bzcat ${MATCHBOX_PANEL_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${MATCHBOX_PANEL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP}
	mv ${EXTTEMP}/matchbox-panel-${MATCHBOX_PANEL_VERSION} ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP}


# ,-----
# |	Configure
# +-----

# TODO: current modifications applicable to v1.0.0

${NTI_MATCHBOX_PANEL_CONFIGURED}: ${NTI_MATCHBOX_PANEL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP} || exit 1 ;\
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
	)


# ,-----
# |	Build
# +-----

${NTI_MATCHBOX_PANEL_BUILT}: ${NTI_MATCHBOX_PANEL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_MATCHBOX_PANEL_INSTALLED}: ${NTI_MATCHBOX_PANEL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MATCHBOX_PANEL_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

#.PHONY: nti-matchbox-panel
#nti-matchbox-panel: nti-SDL nti-SDL_image nti-SDL_mixer \
#	nti-libgl-mesa \
#	nti-libXfixes nti-libXxf86vm \
#	nti-smpeg \
#	${NTI_MATCHBOX_PANEL_INSTALLED}
.PHONY: nti-matchbox-panel
nti-matchbox-panel: nti-pkg-config \
	nti-glib \
	${NTI_MATCHBOX_PANEL_INSTALLED}


ALL_NTI_TARGETS+= nti-matchbox-panel

endif	# HAVE_MATCHBOX_PANEL_CONFIG
