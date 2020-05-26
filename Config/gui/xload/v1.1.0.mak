# xload v1.1.0			[ since v1.1.0, c.2013-05-02 ]
# last mod WmT, 2013-05-02	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XLOAD_CONFIG},y)
HAVE_XLOAD_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'cui-xload' -- xload"

ifeq (${XLOAD_VERSION},)
XLOAD_VERSION=1.1.0
endif

XLOAD_SRC=${SOURCES}/x/xload-${XLOAD_VERSION}.tar.bz2
URLS+= http://pkgs.fedoraproject.org/repo/pkgs/xorg-x11-apps/xload-1.1.0.tar.bz2/5f6e8c54da51ad0e751abf54980b0ef1/xload-1.1.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

## X11R7.5 or R7.6/7.7?
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.5/libXaw/v1.0.7.mak
include ${CFG_ROOT}/x11-r7.5/libXmu/v1.0.5.mak
include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak

NTI_XLOAD_TEMP=nti-xload-${XLOAD_VERSION}
NTI_XLOAD_EXTRACTED=${EXTTEMP}/${NTI_XLOAD_TEMP}/configure
NTI_XLOAD_CONFIGURED=${EXTTEMP}/${NTI_XLOAD_TEMP}/config.log
NTI_XLOAD_BUILT=${EXTTEMP}/${NTI_XLOAD_TEMP}/xload
NTI_XLOAD_INSTALLED=${NTI_TC_ROOT}/usr/bin/xload


# ,-----
# |	Extract
# +-----

${NTI_XLOAD_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xload-${XLOAD_VERSION} ] || rm -rf ${EXTTEMP}/xload-${XLOAD_VERSION}
	bzcat ${XLOAD_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XLOAD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XLOAD_TEMP}
	mv ${EXTTEMP}/xload-${XLOAD_VERSION} ${EXTTEMP}/${NTI_XLOAD_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_XLOAD_CONFIGURED}: ${NTI_XLOAD_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XLOAD_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--with-appdefaultdir=${NTI_TC_ROOT}/etc/X11/app-defaults \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


# ,-----
# |	Build
# +-----

${NTI_XLOAD_BUILT}: ${NTI_XLOAD_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XLOAD_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_XLOAD_INSTALLED}: ${NTI_XLOAD_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XLOAD_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-xload
nti-xload: nti-pkg-config nti-libX11 nti-libXaw nti-libXmu nti-libXt ${NTI_XLOAD_INSTALLED}

ALL_NTI_TARGETS+= nti-xload

endif	# HAVE_XLOAD_CONFIG
