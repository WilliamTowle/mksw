# xorg-server-input-wacom v0.35.0	[ since v0.35.0, c.2017-08-24 ]
# last mod WmT, 2017-08-25		[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_XORG_SERVER_INPUT_WACOM_CONFIG},y)
HAVE_XORG_SERVER_INPUT_WACOM_CONFIG:=y

#DESCRLIST+= "'nui-xorg-server-input-wacom' -- xorg-server-input-wacom"

include ${CFG_ROOT}/ENV/buildtype.mak

# autotools?
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
# {x|un}zip?
include ${CFG_ROOT}/buildtools/dpkg/v1.18.24.mak

ifeq (${XORG_SERVER_INPUT_WACOM_VERSION},)
XORG_SERVER_INPUT_WACOM_VERSION=0.35.0
endif

XORG_SERVER_INPUT_WACOM_SRC=${SOURCES}/x/xf86-input-wacom-0.35.0.tar.bz2
URLS+= https://sourceforge.net/projects/linuxwacom/files/xf86-input-wacom/xf86-input-wacom-0.35.0.tar.bz2/download

## deps?
# for libudev.pc, debian package 'libudev-dev'
# for xorg-macros.pc, debian package 'xutils-dev'
# for xorg-server.pc, debian package 'xserver-xorg-dev'

NUI_XORG_SERVER_INPUT_WACOM_TEMP=nui-xorg-server-input-wacom-${XORG_SERVER_INPUT_WACOM_VERSION}

NUI_XORG_SERVER_INPUT_WACOM_EXTRACTED=${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP}/configure
NUI_XORG_SERVER_INPUT_WACOM_CONFIGURED=${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP}/config.status
NUI_XORG_SERVER_INPUT_WACOM_BUILT=${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP}/xorg-wacom.pc
#NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP=${EXTTEMP}/insttemp
NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP=${EXTTEMP}/xserver-xorg-input-wacom_${XORG_SERVER_INPUT_WACOM_VERSION}-mksw
NUI_XORG_SERVER_INPUT_WACOM_INSTALLED=${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}/usr/lib/pkgconfig/xorg-wacom.pc


## ,-----
## |	Extract
## +-----

${NUI_XORG_SERVER_INPUT_WACOM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86-input-wacom-${XORG_SERVER_INPUT_WACOM_VERSION} ] || rm -rf ${EXTTEMP}/xf86-input-wacom-${XORG_SERVER_INPUT_WACOM_VERSION}
	bzcat ${XORG_SERVER_INPUT_WACOM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP} ] || rm -rf ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP}
	mv ${EXTTEMP}/xf86-input-wacom-${XORG_SERVER_INPUT_WACOM_VERSION} ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP}


## ,-----
## |	Configure
## +-----

${NUI_XORG_SERVER_INPUT_WACOM_CONFIGURED}: ${NUI_XORG_SERVER_INPUT_WACOM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP} || exit 1 ;\
		./configure \
			--prefix=/usr \
			|| exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NUI_XORG_SERVER_INPUT_WACOM_BUILT}: ${NUI_XORG_SERVER_INPUT_WACOM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

ALL_NTI_TARGETS:=

##

# TODO: complains at empty 'conffiles' - maybe can omit?

${NUI_XORG_SERVER_INPUT_WACOM_INSTALLED}: ${NUI_XORG_SERVER_INPUT_WACOM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NUI_XORG_SERVER_INPUT_WACOM_TEMP} || exit 1 ;\
		mkdir -p ${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}/DEBIAN ;\
		( \
			echo 'Package: xserver-xorg-input-wacom' ;\
			echo 'Architecture:' `uname --kernel-release | sed 's/.*-//'` ;\
			echo 'Maintainer: none (hacky test build)' ;\
			echo 'Depends: libudev-dev, xutils-dev, xserver-xorg-dev' ;\
			echo 'Priority: optional' ;\
			echo 'Version:' ${XORG_SERVER_INPUT_WACOM_VERSION} ;\
			echo 'Description: build from' `basename ${XORG_SERVER_INPUT_WACOM_RC}` ;\
		) > ${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}/DEBIAN/control ;\
		echo '' > ${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}/DEBIAN/conffiles ;\
		make install \
			DESTDIR=${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP} || exit 1 ;\
		( cd `dirname ${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}` || exit 1 ;\
			${DPKG_DEB_HOST_TOOL} --build `basename ${NUI_XORG_SERVER_INPUT_WACOM_INSTTEMP}` \
		) \
	)

.PHONY: nui-xorg-server-input-wacom
nui-xorg-server-input-wacom: \
	${NUI_XORG_SERVER_INPUT_WACOM_INSTALLED}

ALL_NUI_TARGETS+= nti-dpkg \
	nui-xorg-server-input-wacom

##

ALL_CTI_TARGETS:=

##

ALL_CUI_TARGETS:=


endif	# HAVE_XORG_SERVER_INPUT_WACOM_CONFIG
