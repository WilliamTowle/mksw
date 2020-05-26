# xterm v292			[ since v2.7.10, c.2013-04-27 ]
# last mod WmT, 2013-05-02	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XTERM_CONFIG},y)
HAVE_XTERM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-xterm' -- xterm"

ifeq (${XTERM_VERSION},)
XTERM_VERSION=292
endif

XTERM_SRC=${SOURCES}/x/xterm-${XTERM_VERSION}.tgz
URLS+= ftp://invisible-island.net/xterm/xterm-292.tgz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

## X11R7.5 or R7.6/7.7?
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.5/libXaw/v1.0.7.mak

NTI_XTERM_TEMP=nti-xterm-${XTERM_VERSION}
NTI_XTERM_EXTRACTED=${EXTTEMP}/${NTI_XTERM_TEMP}/configure
NTI_XTERM_CONFIGURED=${EXTTEMP}/${NTI_XTERM_TEMP}/config.log
NTI_XTERM_BUILT=${EXTTEMP}/${NTI_XTERM_TEMP}/xterm
NTI_XTERM_INSTALLED=${NTI_TC_ROOT}/usr/bin/xterm


# ,-----
# |	Extract
# +-----

${NTI_XTERM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xterm-${XTERM_VERSION} ] || rm -rf ${EXTTEMP}/xterm-${XTERM_VERSION}
	zcat ${XTERM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XTERM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XTERM_TEMP}
	mv ${EXTTEMP}/xterm-${XTERM_VERSION} ${EXTTEMP}/${NTI_XTERM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_XTERM_CONFIGURED}: ${NTI_XTERM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XTERM_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-pkg-config=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
	)
#		PKGCONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


# ,-----
# |	Build
# +-----

${NTI_XTERM_BUILT}: ${NTI_XTERM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XTERM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_XTERM_INSTALLED}: ${NTI_XTERM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XTERM_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-xterm
nti-xterm: nti-pkg-config nti-libX11 nti-libXaw ${NTI_XTERM_INSTALLED}

ALL_NTI_TARGETS+= nti-xterm

endif	# HAVE_XTERM_CONFIG

#include ${CFG_ROOT}/x11-r7.5/libXaw/v1.0.7.mak
#include ${CFG_ROOT}/x11-r7.5/libXmu/v1.0.5.mak
#include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak
