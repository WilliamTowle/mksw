# nanoterm v0.0.2		[ since v0.0.2, c.2017-03-21 ]
# last mod WmT, 2017-03-22	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_NANOTERM_CONFIG},y)
HAVE_NANOTERM_CONFIG:=y

DESCRLIST+= "'nti-nanoterm' -- nanoterm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${NANOTERM_VERSION},)
NANOTERM_VERSION=0.0.2
endif

NANOTERM_SRC=${SOURCES}/n/nanoterm-${NANOTERM_VERSION}.tar
URLS+= ftp://microwindows.org/pub/microwindows/Ported-Applications/nanoterm-0.0.2.tar

# build deps?

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/gui/nxlib/v0.46.mak

NTI_NANOTERM_TEMP=nti-nanoterm-${NANOTERM_VERSION}
NTI_NANOTERM_EXTRACTED=${EXTTEMP}/${NTI_NANOTERM_TEMP}/README
NTI_NANOTERM_CONFIGURED=${EXTTEMP}/${NTI_NANOTERM_TEMP}/nanogui.c.OLD
NTI_NANOTERM_BUILT=${EXTTEMP}/${NTI_NANOTERM_TEMP}/nanoterm
NTI_NANOTERM_INSTALLED=${NTI_TC_ROOT}/usr/bin/nanoterm


# ,-----
# |	Extract
# +-----

${NTI_NANOTERM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_NANOTERM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NANOTERM_TEMP}
	mkdir -p ${EXTTEMP}/${NTI_NANOTERM_TEMP}
	tar xvf ${NANOTERM_SRC} -C ${EXTTEMP}/${NTI_NANOTERM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_NANOTERM_CONFIGURED}: ${NTI_NANOTERM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NANOTERM_TEMP} || exit 1 ;\
		[ -r terminal.h.OLD ] || cp terminal.h terminal.h.OLD || exit 1 ;\
		cat terminal.h.OLD \
			| sed '1,/^$$/	s/^$$/\n#include <string.h>\n/' \
			| sed '/^void char_out/,/^}$$/		{ /GrText/ s%);%, /* flags */0);% }' \
			> terminal.h ;\
		[ -r clock.h.OLD ] || cp clock.h clock.h.OLD || exit 1 ;\
		cat clock.h.OLD \
			| sed '/^void update_clock/,/^}$$/	{ /GrText/ s%);%, /* flags */0);% }' \
			> clock.h ;\
		[ -r nanogui.c.OLD ] || cp nanogui.c nanogui.c.OLD || exit 1 ;\
		cat nanogui.c.OLD \
			| sed '/"nano-X.h"/	s%^%#define MWINCLUDECOLORS\n%' \
			| sed 's/FONT_OEM_FIXED/GR_FONT_OEM_FIXED/' \
			| sed '/^void text_init/,/^}%%/	{ /GrGetGCTextSize/ s%, 1, %, 1, /* flags */0, % }' \
			> nanogui.c \
	)


# ,-----
# |	Build
# +-----

${NTI_NANOTERM_BUILT}: ${NTI_NANOTERM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NANOTERM_TEMP} || exit 1 ;\
		${NTI_GCC} nanogui.c -I${NTI_TC_ROOT}/opt/microwindows/include -o nanoterm -L${NTI_TC_ROOT}/opt/microwindows/lib -lnano-X \
	)


# ,-----
# |	Install
# +-----


${NTI_NANOTERM_INSTALLED}: ${NTI_NANOTERM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NANOTERM_TEMP} || exit 1 ;\
		echo '...' ; exit 1 ;\
		make install \
	)

.PHONY: nti-nanoterm
nti-nanoterm: \
	nti-nxlib ${NTI_NANOTERM_INSTALLED}

ALL_NTI_TARGETS+= nti-nanoterm

endif	# HAVE_NANOTERM_CONFIG
