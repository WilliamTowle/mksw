# uwm v2010-10-20-16		[ since v0.2.10a, c.2013-05-01 ]
# last mod WmT, 2018-01-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_UWM_CONFIG},y)
HAVE_UWM_CONFIG:=y

#DESCRLIST+= "'cui-uwm' -- uwm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${UWM_VERSION},)
#UWM_VERSION=0.2.10a
#UWM_VERSION=0.2.11a
UWM_VERSION=2010-10-20-16
#UWM_VERSION=2010-11-10-21
# also v0.30
endif

UWM_SRC=${SOURCES}/u/uwm-${UWM_VERSION}.tar.bz2
#UWM_SRC=${SOURCES}/u/uwm-${UWM_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/udeproject/UWM/uwm-0.2.10a%20stable/uwm-0.2.10a.tar.gz
#URLS+= http://downloads.sourceforge.net/project/udeproject/UWM/uwm-0.2.11a%20stable/uwm-0.2.11a.tar.gz
URLS+= https://sourceforge.net/projects/uwm/files/Source/uwm-${UWM_VERSION}.tar.bz2/download

## X11 R7.5 unsuitable due to no libxcb (xcb-util dependency)
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.29.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/gui/xcb-util/v0.3.8.mak
include ${CFG_ROOT}/gui/xcb-util-image/v0.3.8.mak
include ${CFG_ROOT}/gui/xcb-util-keysyms/v0.3.8.mak
include ${CFG_ROOT}/gui/xcb-util-renderutil/v0.3.8.mak
include ${CFG_ROOT}/gui/xcb-util-wm/v0.3.8.mak


NTI_UWM_TEMP=nti-uwm-${UWM_VERSION}
NTI_UWM_EXTRACTED=${EXTTEMP}/${NTI_UWM_TEMP}/configure
NTI_UWM_CONFIGURED=${EXTTEMP}/${NTI_UWM_TEMP}/config.log
NTI_UWM_BUILT=${EXTTEMP}/${NTI_UWM_TEMP}/uwm
NTI_UWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/uwm


# ,-----
# |	Extract
# +-----

${NTI_UWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/uwm-${UWM_VERSION} ] || rm -rf ${EXTTEMP}/uwm-${UWM_VERSION}
	[ ! -d ${EXTTEMP}/uwm ] || rm -rf ${EXTTEMP}/uwm
	bzcat ${UWM_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${UWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UWM_TEMP}
	#mv ${EXTTEMP}/uwm-${UWM_VERSION} ${EXTTEMP}/${NTI_UWM_TEMP}
	mv ${EXTTEMP}/uwm ${EXTTEMP}/${NTI_UWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_UWM_CONFIGURED}: ${NTI_UWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^#*CC.*gcc/		{ s/^#// ; s%g*cc%'${NTI_GCC}'% }' \
			| sed '/^LIBS/			s%^%CFLAGS+='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags xcb-atom `"'\n%' \
			| sed '/^LIBS/			s%^%LDFLAGS+='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --libs xcb-atom `"'\n%' \
			| sed '/^LIBS/,/[^\\]$$/	s%`pkg-config%`'${PKG_CONFIG_CONFIG_HOST_TOOL}'%' \
			> Makefile \
	)
#	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
#		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#		cat Makefile.OLD \
#			| sed '/^#*CC.*gcc/		{ s/^#// ; s%g*cc%'${NTI_GCC}'% }' \
#			| sed '/^CFLAGS=/		s%$$%\nLDFLAGS='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --libs xcb-atom `"'%' \
#			| sed '/^CFLAGS=/		s%$$%\nCFLAGS+='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags xcb-atom `"'%' \
#			| sed '/^LIBS/,/[^\\]$$/	s%`pkg-config%`'${PKG_CONFIG_CONFIG_HOST_TOOL}'%' \
#			| sed '/^DESTDIR/		s/DESTDIR/PREFIX/' \
#			| sed '/^PREFIX=/		s%/usr%'${NTI_TC_ROOT}'/usr%' \
#			| sed '/^	/		s%$$(DESTDIR)%$$(DESTDIR)/$$(PREFIX)%' \
#			> Makefile \
#	)


# ,-----
# |	Build
# +-----

${NTI_UWM_BUILT}: ${NTI_UWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_UWM_INSTALLED}: ${NTI_UWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-uwm
#nti-uwm: nti-libX11 nti-libxcb \
#	${NTI_UWM_INSTALLED}
nti-uwm: nti-jpegsrc nti-libpng \
	nti-xcb-util nti-xcb-util-image nti-xcb-util-keysyms nti-xcb-util-renderutil nti-xcb-util-wm \
	${NTI_UWM_INSTALLED}


ALL_NTI_TARGETS+= nti-uwm

endif	# HAVE_UWM_CONFIG
