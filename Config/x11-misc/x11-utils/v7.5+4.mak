# x11-utils v7.5+4		[ since v7.5+4, 2014-02-24 ]
# last mod WmT, 2014-02-24	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_X11_UTILS_CONFIG},y)
HAVE_X11_UTILS_CONFIG:=y

#DESCRLIST+= "'cui-x11-utils' -- x11-utils"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${X11_UTILS_VERSION},)
X11_UTILS_VERSION=7.5+4
endif

X11_UTILS_SRC=${SOURCES}/x/x11-utils_7.5+4.tar.gz
URLS+= http://ftp.de.debian.org/debian/pool/main/x/x11-utils/x11-utils_7.5+4.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/gui/libXaw/v1.0.7.mak
#include ${CFG_ROOT}/gui/libxkbfile/v1.0.6.mak

NTI_X11_UTILS_TEMP=nti-x11-utils-${X11_UTILS_VERSION}
NTI_X11_UTILS_EXTRACTED=${EXTTEMP}/${NTI_X11_UTILS_TEMP}/configure
NTI_X11_UTILS_CONFIGURED=${EXTTEMP}/${NTI_X11_UTILS_TEMP}/config.log
NTI_X11_UTILS_BUILT=${EXTTEMP}/${NTI_X11_UTILS_TEMP}/x11-utils
NTI_X11_UTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/x11-utils


# ,-----
# |	Extract
# +-----

${NTI_X11_UTILS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/x11-utils-${X11_UTILS_VERSION} ] || rm -rf ${EXTTEMP}/x11-utils-${X11_UTILS_VERSION}
	zcat ${X11_UTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11_UTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11_UTILS_TEMP}
	mv ${EXTTEMP}/x11-utils ${EXTTEMP}/${NTI_X11_UTILS_TEMP}
	#mv ${EXTTEMP}/x11-utils-${X11_UTILS_VERSION} ${EXTTEMP}/${NTI_X11_UTILS_TEMP}


# ,-----
# |	Configure
# +-----

## 2014-02-19: no specs: modern pdf/postscript generation tools barf :(

${NTI_X11_UTILS_CONFIGURED}: ${NTI_X11_UTILS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11_UTILS_TEMP}/xfontsel || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--with-appdefaultdir=${NTI_TC_ROOT}/etc/X11/app-defaults \
				--without-xft \
	)


# ,-----
# |	Build
# +-----

${NTI_X11_UTILS_BUILT}: ${NTI_X11_UTILS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11_UTILS_TEMP}/xfontsel || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_X11_UTILS_INSTALLED}: ${NTI_X11_UTILS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11_UTILS_TEMP}/xfontsel || exit 1 ;\
		make install \
	)

.PHONY: nti-x11-utils
nti-x11-utils: nti-libXaw ${NTI_X11_UTILS_INSTALLED}
#nti-x11-utils: nti-libX11 nti-libXaw nti-libxkbfile ${NTI_X11_UTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-x11-utils

endif	# HAVE_X11_UTILS_CONFIG
