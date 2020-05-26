# zwm v1.0.0			[ since v1.0.0, 2017-04-19 ]
# last mod WmT, 2017-08-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_ZWM_CONFIG},y)
HAVE_ZWM_CONFIG:=y

#DESCRLIST+= "'cui-zwm' -- zwm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${ZWM_VERSION},)
ZWM_VERSION=1.0.0
endif

ZWM_SRC=${SOURCES}/z/zwm-${ZWM_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/zwm/ZWM%20and%20amp_%20Samples%20Source/1.0.0/zwm-1.0.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fzwm%2F&ts=1492599582&use_mirror=ayera"

# SDL v1.x, because 'sdl-config' is expected
include ${CFG_ROOT}/audvid/smpeg/v0.4.5.mak
include ${CFG_ROOT}/gui/libgl-mesa/v12.0.6.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL/v2.0.5.mak
include ${CFG_ROOT}/gui/SDL_image/v1.2.12.mak
include ${CFG_ROOT}/gui/SDL_mixer/v1.2.12.mak
#include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXfixes/v4.0.4.mak
include ${CFG_ROOT}/x11-r7.5/libXxf86vm/v1.1.0.mak

NTI_ZWM_TEMP=nti-zwm-${ZWM_VERSION}
NTI_ZWM_EXTRACTED=${EXTTEMP}/${NTI_ZWM_TEMP}/Makefile
NTI_ZWM_CONFIGURED=${EXTTEMP}/${NTI_ZWM_TEMP}/Makefile.OLD
NTI_ZWM_BUILT=${EXTTEMP}/${NTI_ZWM_TEMP}/zwm
NTI_ZWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/zwm


# ,-----
# |	Extract
# +-----

${NTI_ZWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/zwm-${ZWM_VERSION} ] || rm -rf ${EXTTEMP}/zwm-${ZWM_VERSION}
	[ ! -d ${EXTTEMP}/dc-${ZWM_VERSION} ] || rm -rf ${EXTTEMP}/dc-${ZWM_VERSION}
	#bzcat ${ZWM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${ZWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZWM_TEMP}
	#mv ${EXTTEMP}/zwm-${ZWM_VERSION} ${EXTTEMP}/${NTI_ZWM_TEMP}
	mv ${EXTTEMP}/dc-${ZWM_VERSION} ${EXTTEMP}/${NTI_ZWM_TEMP}


# ,-----
# |	Configure
# +-----

# TODO: current modifications applicable to v1.0.0

${NTI_ZWM_CONFIGURED}: ${NTI_ZWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ZWM_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/but the$$/,/^minimum/	{ s/the$$/the"/ ; s/^minimum/"minimum/ }' \
			| sed '/config is$$/,/^correct/	{ s/is$$/is"/ ; s/^correct/"correct/ }' \
			| sed '/variable$$/,/^SMPEG_CONFIG/	{ s/variable$$/variable"/ ; s/^SMPEG_CONFIG/"SMPEG_CONFIG/ }' \
			| sed '/remove$$/,/^the file/	{ s/remove$$/remove"/ ; s/^the/"the/ }' \
			> configure ;\
		chmod a+x ./configure ;\
		[ -r DCLib/DCL_Error.cpp.OLD ] || mv DCLib/DCL_Error.cpp DCLib/DCL_Error.cpp.OLD || exit 1 ;\
		cat DCLib/DCL_Error.cpp.OLD \
			| sed '/<stdarg.h>/	s/$$/\n#include <string.h>/' \
			> DCLib/DCL_Error.cpp ;\
		[ -r zsdl_wm/ZSDL_WM.h.OLD ] || mv zsdl_wm/ZSDL_WM.h zsdl_wm/ZSDL_WM.h.OLD || exit 1 ;\
		cat zsdl_wm/ZSDL_WM.h.OLD \
			| sed '/"ZWM_Module.h"/	s%^%//%' \
			> zsdl_wm/ZSDL_WM.h ;\
		[ -r zsdl_wm/ZWM_CommonDlg.cpp.OLD ] || mv zsdl_wm/ZWM_CommonDlg.cpp zsdl_wm/ZWM_CommonDlg.cpp.OLD || exit 1 ;\
		cat zsdl_wm/ZWM_CommonDlg.cpp.OLD \
			| sed '/<ctype.h>/	s%$$%\n#include "ZWM_CommonDlg.h"\n\n%' \
			| sed '/"ZWM_Debug.h"/,/"ZWM_FInfo.h"/	{ /ZWM_CommonDlg.h/ s%^%//% }' \
			| sed '/"ZSDL_WM.h"/	{ s%^%//% ; s%$$%\n#include "ZWM_Module.h"% }' \
			> zsdl_wm/ZWM_CommonDlg.cpp ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-sdl-prefix=${NTI_TC_ROOT}/usr \
			--with-smpeg-prefix=${NTI_TC_ROOT}/usr \
	)


# ,-----
# |	Build
# +-----

${NTI_ZWM_BUILT}: ${NTI_ZWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ZWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_ZWM_INSTALLED}: ${NTI_ZWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ZWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-zwm
nti-zwm: nti-SDL nti-SDL_image nti-SDL_mixer \
	nti-libgl-mesa \
	nti-libXfixes nti-libXxf86vm \
	nti-smpeg \
	${NTI_ZWM_INSTALLED}

ALL_NTI_TARGETS+= nti-zwm

endif	# HAVE_ZWM_CONFIG
