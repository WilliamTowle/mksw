# uwm v0.30			[ since v0.2.10a, c.2013-05-01 ]
# last mod WmT, 2018-01-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_UWM_CONFIG},y)
HAVE_UWM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-uwm' -- uwm"

ifeq (${UWM_VERSION},)
#UWM_VERSION=0.2.10a
UWM_VERSION=0.30
endif

UWM_SRC=${SOURCES}/u/uwm-${UWM_VERSION}.tar.bz2
#UWM_SRC=${SOURCES}/u/uwm-${UWM_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/udeproject/UWM/uwm-0.2.10a%20stable/uwm-0.2.10a.tar.gz
URLS+= 'https://downloads.sourceforge.net/project/uwm/Source/uwm-0.30.tar.bz2?r=http%3A%2F%2Fuwm.sourceforge.net%2F&ts=1492083024&use_mirror=netcologne'

## X11 R7.5 unsuitable due xcb-util needing suitable libxcb
include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.29.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/x11-misc/xcb-util/v0.3.8.mak
include ${CFG_ROOT}/x11-misc/xcb-util-image/v0.3.8.mak
include ${CFG_ROOT}/x11-misc/xcb-util-keysyms/v0.3.8.mak
include ${CFG_ROOT}/x11-misc/xcb-util-renderutil/v0.3.8.mak
include ${CFG_ROOT}/x11-misc/xcb-util-wm/v0.3.8.mak

NTI_UWM_TEMP=nti-uwm-${UWM_VERSION}
NTI_UWM_EXTRACTED=${EXTTEMP}/${NTI_UWM_TEMP}/uwm.1
NTI_UWM_CONFIGURED=${EXTTEMP}/${NTI_UWM_TEMP}/Makefile.OLD
NTI_UWM_BUILT=${EXTTEMP}/${NTI_UWM_TEMP}/uwm
NTI_UWM_INSTALLED=${NTI_TC_ROOT}/usr/bin/uwm


# ,-----
# |	Extract
# +-----

${NTI_UWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/uwm-${UWM_VERSION} ] || rm -rf ${EXTTEMP}/uwm-${UWM_VERSION}
	bzcat ${UWM_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${UWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UWM_TEMP}
	mv ${EXTTEMP}/uwm-${UWM_VERSION} ${EXTTEMP}/${NTI_UWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_UWM_CONFIGURED}: ${NTI_UWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^#*CC.*gcc/		{ s/^#// ; s%g*cc%'${NTI_GCC}'% }' \
			| sed '/^CFLAGS=/		s%$$%\nLDFLAGS='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --libs xcb-atom `"'%' \
			| sed '/^CFLAGS=/		s%$$%\nCFLAGS+='"` ${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags xcb-atom `"'%' \
			| sed '/^LIBS/,/[^\\]$$/	s%`pkg-config%`'${PKG_CONFIG_CONFIG_HOST_TOOL}'%' \
			| sed '/^DESTDIR/		s/DESTDIR/PREFIX/' \
			| sed '/^PREFIX=/		s%/usr/*[^ ]*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^	/		s%$$(DESTDIR)%$$(DESTDIR)/$$(PREFIX)%' \
			| sed '/^	.* udm/		s%^	%	true #%' \
			> Makefile \
	)


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
