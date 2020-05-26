# fs-uae v2.8.3			[ since v2.8.3, c.2018-03-05 ]
# last mod WmT, 2018-03-13	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_FS_UAE_CONFIG},y)
HAVE_FS_UAE_CONFIG:=y

#DESCRLIST+= "'nti-fs-uae' -- fs-uae (amiga emulator)"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/tools/zip/v30.mak

ifeq (${FS_UAE_VERSION},)
FS_UAE_VERSION=2.8.3
# NB. also has development version at v2.9.7
endif

URLS+= https://fs-uae.net/stable/2.8.3/fs-uae-2.8.3.tar.gz
FS_UAE_SRC=${SOURCES}/f/fs-uae-2.8.3.tar.gz

include ${CFG_ROOT}/gui/SDL/v2.0.8.mak
include ${CFG_ROOT}/misc/glib/v2.55.2.mak
include ${CFG_ROOT}/gui/libgl-mesa/v17.0.0.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/audvid/openal-soft/v1.18.2.mak
# needs X11r7.7+ for X11/Xatom.h with XA_CARDINAL
include ${CFG_ROOT}/x11-r7.7/libX11/v1.5.0.mak
include ${CFG_ROOT}/x11-r7.7/libXext/v1.3.1.mak


NTI_FS_UAE_TEMP=nti-fs-uae-${FS_UAE_VERSION}

NTI_FS_UAE_EXTRACTED=${EXTTEMP}/${NTI_FS_UAE_TEMP}/configure
NTI_FS_UAE_CONFIGURED=${EXTTEMP}/${NTI_FS_UAE_TEMP}/config.log
NTI_FS_UAE_BUILT=${EXTTEMP}/${NTI_FS_UAE_TEMP}/fs-uae
NTI_FS_UAE_INSTALLED=${NTI_TC_ROOT}/usr/bin/fs-uae


## ,-----
## |	Extract
## +-----

${NTI_FS_UAE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/fs-uae-${FS_UAE_VERSION} ] || rm -rf ${EXTTEMP}/fs-uae-${FS_UAE_VERSION}
	#bzcat ${FS_UAE_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${FS_UAE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FS_UAE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FS_UAE_TEMP}
	mv ${EXTTEMP}/fs-uae-${FS_UAE_VERSION} ${EXTTEMP}/${NTI_FS_UAE_TEMP}


## ,-----
## |	Configure
## +-----

## [v2.8.3] Bad detection -> force HAVE_AL_{AL|ALC}_H in config.h
## [v2.8.3] Missing include of <X11/Xatom.h>?

${NTI_FS_UAE_CONFIGURED}: ${NTI_FS_UAE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FS_UAE_TEMP} || exit 1 ;\
		[ -r libfsemu/src/ml/x11.c.OLD ] || mv libfsemu/src/ml/x11.c libfsemu/src/ml/x11.c.OLD || exit 1 ;\
		cat libfsemu/src/ml/x11.c.OLD \
			| sed '/X11\/Xlib.h/	s%$$%\n#include <X11/Xatom.h>%' \
			> libfsemu/src/ml/x11.c ;\
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_LIBDIR=${PKG_CONFIG_CONFIG_HOST_PATH} \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --disable-a2065 --disable-action-replay \
			  --disable-cd32 --disable-cdtv \
			  --without-glad \
			  --without-libmpeg2 \
			  --x-includes=${NTI_TC_ROOT}/usr/include \
			  --x-libraries=${NTI_TC_ROOT}/usr/lib \
				|| exit 1 ;\
		[ -r config.h.OLD ] || mv config.h config.h.OLD || exit 1 ;\
		cat config.h.OLD \
			| sed '/HAVE_AL_AL_H/	{ s/^.*undef/#define/ ; s/ \*\/// }' \
			| sed '/HAVE_AL_ALC_H/	{ s/^.*undef/#define/ ; s/ \*\/// }' \
			> config.h \
	)
## non-working 'disable' options - result in "undefined reference"s
##	--disable-ncr --disable-ncr9x


## ,-----
## |	Build
## +-----

${NTI_FS_UAE_BUILT}: ${NTI_FS_UAE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FS_UAE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FS_UAE_INSTALLED}: ${NTI_FS_UAE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FS_UAE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-fs-uae
nti-fs-uae: \
	nti-pkg-config nti-zip \
	nti-glib nti-libpng nti-openal-soft \
	nti-SDL2 nti-libX11 nti-libXext \
	${NTI_FS_UAE_INSTALLED}

ALL_NTI_TARGETS+= nti-fs-uae

endif	# HAVE_FS_UAE_CONFIG
