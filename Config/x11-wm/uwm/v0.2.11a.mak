# uwm v0.2.11a			[ since v0.2.10a, c.2013-05-01 ]
# last mod WmT, 2017-07-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_UWM_CONFIG},y)
HAVE_UWM_CONFIG:=y

#DESCRLIST+= "'cui-uwm' -- uwm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${UWM_VERSION},)
#UWM_VERSION=0.2.10a
UWM_VERSION=0.2.11a
endif

UWM_SRC=${SOURCES}/u/uwm-${UWM_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/udeproject/UWM/uwm-0.2.10a%20stable/uwm-0.2.10a.tar.gz
URLS+= http://downloads.sourceforge.net/project/udeproject/UWM/uwm-0.2.11a%20stable/uwm-0.2.11a.tar.gz

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak

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
	[ ! -d ${EXTTEMP}/uwm-${UWM_VERSION} ] || rm -rf ${EXTTEMP}/uwm-${UWM_VERSION}
	zcat ${UWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UWM_TEMP}
	mv ${EXTTEMP}/uwm-${UWM_VERSION} ${EXTTEMP}/${NTI_UWM_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_UWM_CONFIGURED}: ${NTI_UWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UWM_TEMP} || exit 1 ;\
		PKGCONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib \
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
nti-uwm: nti-pkg-config \
	nti-libXpm \
	${NTI_UWM_INSTALLED}
#nti-uwm: nti-libX11 ${NTI_UWM_INSTALLED}

ALL_NTI_TARGETS+= nti-uwm

endif	# HAVE_UWM_CONFIG
